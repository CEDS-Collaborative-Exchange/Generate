/*
	[App].[Migrate_Data_ETL_IMPLEMENTATION_STEP06_Enrollment_EncapsulatedCode] 2018
*/

CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP06_Enrollment_EncapsulatedCode]
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


---Additional Items to add in the future - exit/withdraw reason--

        ---------------------------------------------------
        --- Declare Error Handling Variables           ----
        ---------------------------------------------------
		DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP06_Enrollment_EncapsulatedCode'

		-------------------------------------------------------
		---Associate the PersonId with the temporary table ----
		-------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.Enrollment
			SET PersonId = pid.PersonId
			FROM Staging.Enrollment e
			JOIN ODS.PersonIdentifier pid ON e.Student_Identifier_State = pid.Identifier
			WHERE pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075')
			AND pid.RefPersonalInformationVerificationId = App.GetRefPersonalInformationVerificationId('01011')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Enrollment', 'PersonId', 'S06EC100' 
		END CATCH

		--------------------------------------------------------------------
		---Associate the LEA OrganizationId with the temporary table -------
		--------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.Enrollment
			SET OrganizationID_LEA = orgid.OrganizationId
			FROM Staging.Enrollment e
			JOIN ODS.OrganizationIdentifier orgid ON e.LEA_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = App.GetOrganizationIdentifierTypeId('001072')
			AND orgid.RefOrganizationIdentificationSystemId = App.GetOrganizationIdentifierSystemId('SEA', '001072')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Enrollment', 'OrganizationID_LEA', 'S06EC110' 
		END CATCH

		--------------------------------------------------------------------
		---Associate the School OrganizationId with the temporary table ----
		--------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.Enrollment
			SET OrganizationID_School = orgid.OrganizationId
			FROM Staging.Enrollment e
			JOIN ODS.OrganizationIdentifier orgid ON e.School_Identifier_State = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = App.GetOrganizationIdentifierTypeId('001073')
			AND orgid.RefOrganizationIdentificationSystemId = App.GetOrganizationIdentifierSystemId('SEA', '001073')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Enrollment', 'OrganizationID_School', 'S06EC120' 
		END CATCH

		----------------------------------------------------------------------------------------
		---Manage the OrganizationPersonRole Records for each Student to LEA relationship ------
		----------------------------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO [ODS].[OrganizationPersonRole]
						([OrganizationId]
						,[PersonId]
						,[RoleId]
						,[EntryDate]
						,[ExitDate])
			SELECT DISTINCT
						e.OrganizationID_LEA [OrganizationId]
						,e.PersonID [PersonId]
						,App.GetRoleId('K12 Student') [RoleId]
						,EnrollmentEntryDate [EntryDate]
						,EnrollmentExitDate [ExitDate]
			FROM Staging.Enrollment e
			LEFT JOIN ODS.OrganizationPersonRole opr 
				ON e.PersonID = opr.PersonId
				AND e.EnrollmentEntryDate = opr.EntryDate
				AND ISNULL(e.EnrollmentExitDate, '1900-01-01') = ISNULL(opr.ExitDate, '1900-01-01')
				AND e.OrganizationID_LEA = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student')
			WHERE opr.PersonId IS NULL
				AND e.OrganizationID_LEA IS NOT NULL
				AND e.PersonID IS NOT NULL
				AND e.EnrollmentEntryDate >= App.GetFiscalYearStartDate(@SchoolYear)
				AND (e.EnrollmentExitDate IS NULL OR e.EnrollmentExitDate <= App.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S06EC130' 
		END CATCH

		BEGIN TRY
			UPDATE Staging.Enrollment
			SET OrganizationPersonRoleId_LEA = opr.OrganizationPersonRoleId
			FROM Staging.Enrollment e
			JOIN ODS.OrganizationPersonRole opr 
				ON e.PersonID = opr.PersonId 
			WHERE e.OrganizationID_LEA = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student')
				AND EntryDate = e.EnrollmentEntryDate
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Enrollment', 'OrganizationPersonRoleId_LEA', 'S06EC140' 
		END CATCH

		-------------------------------------------------------------------------------------------
		---Manage the OrganizationPersonRole Records for each Student to School relationship ------
		-------------------------------------------------------------------------------------------

		BEGIN TRY
			INSERT INTO [ODS].[OrganizationPersonRole]
					   ([OrganizationId]
					   ,[PersonId]
					   ,[RoleId]
					   ,[EntryDate]
					   ,[ExitDate])
			SELECT DISTINCT
						e.OrganizationID_School [OrganizationId]
					   ,e.PersonID [PersonId]
					   ,App.GetRoleId('K12 Student') [RoleId]
					   ,EnrollmentEntryDate [EntryDate]
					   ,EnrollmentExitDate [ExitDate]
			FROM Staging.Enrollment e
			LEFT JOIN ODS.OrganizationPersonRole opr 
				ON e.PersonID = opr.PersonId
				AND e.EnrollmentEntryDate = opr.EntryDate
				AND ISNULL(e.EnrollmentExitDate, '1900-01-01') = ISNULL(opr.ExitDate, '1900-01-01')
				AND e.OrganizationID_School = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student')
			WHERE opr.PersonId IS NULL
				AND e.OrganizationID_School IS NOT NULL
				AND e.PersonID IS NOT NULL
				AND e.EnrollmentEntryDate >= App.GetFiscalYearStartDate(@SchoolYear)
				AND (e.EnrollmentExitDate IS NULL OR e.EnrollmentExitDate <= App.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S06EC150' 
		END CATCH

		BEGIN TRY
			UPDATE Staging.Enrollment
			SET OrganizationPersonRoleId_School = opr.OrganizationPersonRoleId
			FROM Staging.Enrollment e
			JOIN ODS.OrganizationPersonRole opr 
				ON e.PersonID = opr.PersonId 
			WHERE e.OrganizationID_School = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student')
				AND EntryDate = e.EnrollmentEntryDate
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Enrollment', 'OrganizationPersonRoleId_School', 'S06EC160' 
		END CATCH
		
		----------------------------------------------------------------------------------
		---Delete any OrganizationPersonRole Records not found in the staging table ------
		----------------------------------------------------------------------------------

		CREATE TABLE #RecordsToDelete_OrganizationPersonRole
			(OrganizationPersonRoleId INT)

		--LEA
		BEGIN TRY
			INSERT INTO #RecordsToDelete_OrganizationPersonRole
				(OrganizationPersonRoleId)
			SELECT DISTINCT OrganizationPersonRoleId 
			FROM ODS.OrganizationPersonRole opr
			JOIN ODS.OrganizationDetail orgd 
				ON opr.OrganizationId = orgd.OrganizationId
			INNER JOIN Staging.Enrollment e 
				ON opr.OrganizationPersonRoleId = e.OrganizationPersonRoleId_LEA
			WHERE e.Id IS NULL
				AND opr.RoleId = App.GetRoleId('K12 Student')
				AND orgd.RefOrganizationTypeId = App.GetOrganizationTypeId('LEA', '001156')
				AND opr.EntryDate IS NOT NULL
				AND opr.EntryDate >= App.GetFiscalYearStartDate(@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '#RecordsToDelete_OrganizationPersonRole', NULL, 'S06EC170' 
		END CATCH


		--School
		BEGIN TRY
			INSERT INTO #RecordsToDelete_OrganizationPersonRole
				(OrganizationPersonRoleId)
			SELECT DISTINCT OrganizationPersonRoleId 
			FROM ODS.OrganizationPersonRole opr
			JOIN ODS.OrganizationDetail orgd 
				ON opr.OrganizationId = orgd.OrganizationId
			INNER JOIN Staging.Enrollment e 
				ON opr.OrganizationPersonRoleId = e.OrganizationPersonRoleId_School
			WHERE e.Id IS NULL
				AND opr.RoleId = App.GetRoleId('K12 Student')
				AND orgd.RefOrganizationTypeId = App.GetOrganizationTypeId('K12School', '001156')
				AND opr.EntryDate IS NOT NULL
				AND opr.EntryDate >= App.GetFiscalYearStartDate(@SchoolYear)
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, '#RecordsToDelete_OrganizationPersonRole', NULL, 'S06EC180' 
		END CATCH

		--Verify this is in the Program ETL and then delete
		--CREATE TABLE #RecordsToDelete_PersonProgramParticipation
		--	(PersonProgramParticipationId INT)


		--INSERT INTO #RecordsToDelete_PersonProgramParticipation
		--	(PersonProgramParticipationId)
		--SELECT DISTINCT PersonProgramParticipationId
		--FROM ODS.PersonProgramParticipation ppp
		--JOIN #RecordsToDelete_OrganizationPersonRole rtdopr 
		--	ON ppp.OrganizationPersonRoleId = rtdopr.OrganizationPersonRoleId


		---------------------------------------------------------------------------
		--Remove any records that are not in the Current ODS for this School Year--
		---------------------------------------------------------------------------
		/*ODS.K12StudentDiscipline*/
		BEGIN TRY
			DELETE opr FROM ODS.K12StudentDiscipline opr JOIN #RecordsToDelete_OrganizationPersonRole rtdopr ON opr.OrganizationPersonRoleId = rtdopr.OrganizationPersonRoleId
		END TRY
		
		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentDiscipline', NULL, 'S06EC200' 
		END CATCH

		/*ODS.K12StudentEnrollment*/
		BEGIN TRY
			DELETE opr FROM ODS.K12StudentEnrollment opr JOIN #RecordsToDelete_OrganizationPersonRole rtdopr ON opr.OrganizationPersonRoleId = rtdopr.OrganizationPersonRoleId
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentEnrollment', NULL, 'S06EC210' 
		END CATCH
			
		/*ODS.OrganizationPersonRole*/
		BEGIN TRY
			DELETE opr FROM ODS.OrganizationPersonRole opr Join #RecordsToDelete_OrganizationPersonRole rtdopr ON opr.OrganizationPersonRoleId = rtdopr.OrganizationPersonRoleId
		END TRY 

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S06EC220' 
		END CATCH

		------------------------------------------------------------------------------------------------
		---Manage the OrganizationPersonRoleRelationship Records for each School to LEA relationship ---
		------------------------------------------------------------------------------------------------
		DECLARE @NewOrganizationPersonRoleRelationships TABLE (
			  Id INT
			, OrganizationPersonRoleRelationshipId INT
		)
				
		BEGIN TRY
		  MERGE [ODS].[OrganizationPersonRoleRelationship] AS TARGET
		  USING Staging.Enrollment AS SOURCE
			ON TARGET.OrganizationPersonRoleId = SOURCE.OrganizationPersonRoleId_School
			AND TARGET.OrganizationPersonRoleId_Parent = SOURCE.OrganizationPersonRoleId_Lea
			AND TARGET.RecordStartDateTime = SOURCE.EnrollmentEntryDate
		  WHEN MATCHED THEN UPDATE SET [RecordEndDateTime] = SOURCE.EnrollmentExitDate
		  WHEN NOT MATCHED THEN INSERT (
			  OrganizationPersonRoleId
			, OrganizationPersonRoleId_Parent
			, RecordStartDateTime
			, RecordEndDateTime
					)
			VALUES (
			  SOURCE.OrganizationPersonRoleId_School
			, SOURCE.OrganizationPersonRoleId_Lea
			, SOURCE.EnrollmentEntryDate
			, SOURCE.EnrollmentExitDate
			)
			  OUTPUT 
			  SOURCE.Id
			, INSERTED.OrganizationPersonRoleRelationshipId
		  INTO @NewOrganizationPersonRoleRelationships;
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRoleRelationship', NULL, 'S06EC230'
		END CATCH


		BEGIN TRY 
		  UPDATE enr
		  SET OrganizationPersonRoleRelationshipId = noprr.OrganizationPersonRoleRelationshipId
		  FROM Staging.Enrollment enr 
		  JOIN @NewOrganizationPersonRoleRelationships noprr
			ON enr.Id = noprr.Id
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Enrollment', 'OrganizationPersonRoleRelationshipId', 'S06EC240' 
		END CATCH

		BEGIN TRY
				UPDATE r SET r.RecordEndDateTime = s.RecordStartDateTime - 1
				FROM ods.OrganizationPersonRoleRelationship r				
				JOIN (
							SELECT 								  
								 OrganizationPersonRoleId
								,OrganizationPersonRoleId_Parent
								, MAX(OrganizationPersonRoleRelationshipId) AS OrganizationPersonRoleRelationshipId
								, MAX(RecordStartDateTime) AS RecordStartDateTime
							FROM ods.OrganizationPersonRoleRelationship oprr
							WHERE RecordEndDateTime IS NULL 								
							GROUP BY oprr.OrganizationPersonRoleId,oprr.OrganizationPersonRoleId_Parent
				) s ON  r.OrganizationPersonRoleId = s.OrganizationPersonRoleId
					AND r.OrganizationPersonRoleId_Parent = s.OrganizationPersonRoleId
					AND r.OrganizationPersonRoleRelationshipId <> s.OrganizationPersonRoleRelationshipId
					AND r.RecordEndDateTime IS NULL

		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRoleRelationship', NULL, 'S06EC240'
		END CATCH

		----------------------------------------------------------------------------------
		----Create LEA K12StudentEnrollment Record for Each Student for Grade Level----
		----------------------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO [ODS].[K12StudentEnrollment]
					   ([OrganizationPersonRoleId]
					   ,[RefEntryGradeLevelId]
					   ,[RefPublicSchoolResidence]
					   ,[RefEnrollmentStatusId]
					   ,[RefEntryType]
					   ,[RefExitGradeLevel]
					   ,[RefExitOrWithdrawalStatusId]
					   ,[RefExitOrWithdrawalTypeId]
					   ,[DisplacedStudentStatus]
					   ,[RefEndOfTermStatusId]
					   ,[RefPromotionReasonId]
					   ,[RefNonPromotionReasonId]
					   ,[RefFoodServiceEligibilityId]
					   ,[FirstEntryDateIntoUSSchool]
					   ,[RefDirectoryInformationBlockStatusId]
					   ,[NSLPDirectCertificationIndicator]
					   ,[RecordStartDateTime]
					   ,[RecordEndDateTime])
			SELECT DISTINCT
						OrganizationPersonRoleId_LEA			[OrganizationPersonRoleId]
					   ,gl.RefGradeLevelID						[RefEntryGradeLevelId]
					   ,NULL									[RefPublicSchoolResidence]
					   ,NULL									[RefEnrollmentStatusId]
					   ,NULL									[RefEntryType]
					   ,CASE 
							WHEN e.ExitOrWithdrawalType IS NOT NULL THEN gl.RefGradeLevelId
							ELSE NULL
						END										[RefExitGradeLevel]
					   ,NULL									[RefExitOrWithdrawalStatusId]
					   ,ewt.RefExitOrWithdrawalTypeId			[RefExitOrWithdrawalTypeId]
					   ,NULL									[DisplacedStudentStatus]
					   ,NULL									[RefEndOfTermStatusId]
					   ,NULL									[RefPromotionReasonId]
					   ,NULL									[RefNonPromotionReasonId]
					   ,refssfood.RefFoodServiceEligibilityId	[RefFoodServiceEligibilityId]
					   ,NULL									[FirstEntryDateIntoUSSchool]
					   ,NULL									[RefDirectoryInformationBlockStatusId]
					   ,NULL									[NSLPDirectCertificationIndicator]
					   ,EnrollmentEntryDate						[RecordStartDateTime]
					   ,EnrollmentExitDate						[RecordEndDateTime]
			FROM Staging.Enrollment e
			LEFT JOIN ODS.SourceSystemReferenceData rdg
				ON e.GradeLevel = rdg.InputCode
				AND rdg.TableName = 'RefGradeLevel'
				AND rdg.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefGradeLevel gl
				ON rdg.OutputCode = gl.Code
			LEFT JOIN ODS.RefGradeLevelType glt
				ON gl.RefGradeLevelTypeId = glt.RefGradeLevelTypeId
				AND rdg.TableFilter = glt.code
				AND glt.Code = '000100'
			LEFT JOIN ODS.SourceSystemReferenceData rdewt
				ON e.ExitOrWithdrawalType = rdewt.InputCode
				AND rdewt.TableName = 'RefExitOrWithdrawalType'
				AND rdewt.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefExitOrWithdrawalType ewt
				ON rdewt.OutputCode = ewt.Code
			-- food service
			LEFT JOIN ODS.SourceSystemReferenceData ssfood
				ON ssfood.InputCode = e.FoodServiceEligibility
				AND ssfood.TableName = 'RefFoodServiceEligibility'
				AND ssfood.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefFoodServiceEligibility refssfood
				ON ssfood.OutputCode = refssfood.Code
			WHERE OrganizationPersonRoleId_LEA IS NOT NULL 
		END TRY 

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentEnrollment', NULL, 'S06EC300' 
		END CATCH
		----------------------------------------------------------------------------------
		----Create School K12StudentEnrollment Record for Each Student for Grade Level----
		----------------------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO [ODS].[K12StudentEnrollment]
					   ([OrganizationPersonRoleId]
					   ,[RefEntryGradeLevelId]
					   ,[RefPublicSchoolResidence]
					   ,[RefEnrollmentStatusId]
					   ,[RefEntryType]
					   ,[RefExitGradeLevel]
					   ,[RefExitOrWithdrawalStatusId]
					   ,[RefExitOrWithdrawalTypeId]
					   ,[DisplacedStudentStatus]
					   ,[RefEndOfTermStatusId]
					   ,[RefPromotionReasonId]
					   ,[RefNonPromotionReasonId]
					   ,[RefFoodServiceEligibilityId]
					   ,[FirstEntryDateIntoUSSchool]
					   ,[RefDirectoryInformationBlockStatusId]
					   ,[NSLPDirectCertificationIndicator]
					   ,[RecordStartDateTime]
					   ,[RecordEndDateTime])
			SELECT DISTINCT
						OrganizationPersonRoleId_School			[OrganizationPersonRoleId]
					   ,gl.RefGradeLevelID						[RefEntryGradeLevelId]
					   ,NULL									[RefPublicSchoolResidence]
					   ,NULL									[RefEnrollmentStatusId]
					   ,NULL									[RefEntryType]
					   ,CASE 
							WHEN e.ExitOrWithdrawalType IS NOT NULL THEN gl.RefGradeLevelId
							ELSE NULL
						END										[RefExitGradeLevel]
					   ,NULL									[RefExitOrWithdrawalStatusId]
					   ,ewt.RefExitOrWithdrawalTypeId			[RefExitOrWithdrawalTypeId]
					   ,NULL									[DisplacedStudentStatus]
					   ,NULL									[RefEndOfTermStatusId]
					   ,NULL									[RefPromotionReasonId]
					   ,NULL									[RefNonPromotionReasonId]
					   ,refssfood.RefFoodServiceEligibilityId	[RefFoodServiceEligibilityId]
					   ,NULL									[FirstEntryDateIntoUSSchool]
					   ,NULL									[RefDirectoryInformationBlockStatusId]
					   ,NULL									[NSLPDirectCertificationIndicator]
					   ,EnrollmentEntryDate [RecordStartDateTime]
					   ,EnrollmentExitDate [RecordEndDateTime]
			FROM Staging.Enrollment e
			LEFT JOIN ODS.SourceSystemReferenceData rdg
				ON e.GradeLevel = rdg.InputCode
				AND rdg.TableName = 'RefGradeLevel'
				AND rdg.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefGradeLevel gl
				ON rdg.OutputCode = gl.Code
			LEFT JOIN ODS.RefGradeLevelType glt
				ON gl.RefGradeLevelTypeId = glt.RefGradeLevelTypeId
				AND rdg.TableFilter = glt.code
				AND glt.Code = '000100'
			LEFT JOIN ODS.SourceSystemReferenceData rdewt
				ON e.ExitOrWithdrawalType = rdewt.InputCode
				AND rdewt.TableName = 'RefExitOrWithdrawalType'
				AND rdewt.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefExitOrWithdrawalType ewt
				ON rdewt.OutputCode = ewt.Code
			-- food service
			LEFT JOIN ODS.SourceSystemReferenceData ssfood
				ON ssfood.InputCode = e.FoodServiceEligibility
				AND ssfood.TableName = 'RefFoodServiceEligibility'
				AND ssfood.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefFoodServiceEligibility refssfood
				ON ssfood.OutputCode = refssfood.Code

			LEFT JOIN ODS.OrganizationRelationship orl
				ON orl.OrganizationId = e.OrganizationID_School
			WHERE OrganizationPersonRoleId_School IS NOT NULL 
				AND (orl.Parent_OrganizationId = e.OrganizationID_LEA 
					and e.OrganizationID_School IS NOT NULL)
		END TRY 

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentEnrollment', NULL, 'S06EC310' 
		END CATCH

		----------------------------------------------------------------------------------
		----Create Records for Student Attendance etc
		----------------------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO [ODS].[RoleAttendance]
					([OrganizationPersonRoleId]
					,[NumberOfDaysInAttendance]
					,[NumberOfDaysAbsent]
					,[AttendanceRate])
			SELECT 
				opr.OrganizationPersonRoleID  
				,CASE
				WHEN ISNULL(en.NumberOfSchoolDays, 0) > 0 THEN en.NumberOfSchoolDays - ISNULL(en.[NumberOfDaysAbsent], 0)
				END NumberOfDaysInAttendance
				, en.[NumberOfDaysAbsent]
				,CASE
				WHEN ISNULL(en.NumberOfSchoolDays, 0) > 0 THEN CAST( (en.NumberOfSchoolDays - ISNULL(en.NumberOfDaysAbsent, 0.0))/en.NumberOfSchoolDays AS  Decimal(5,4))
				END AttendanceRate
			FROM ods.OrganizationPersonRole opr
			INNER JOIN staging.Enrollment en ON en.OrganizationID_School = opr.OrganizationId AND en.PersonId = opr.PersonId
			LEFT JOIN [ODS].[RoleAttendance] oa ON oa.OrganizationPersonRoleId = opr.OrganizationPersonRoleId
			WHERE oa.RoleAttendanceId IS NULL
		END TRY 

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.RoleAttendance', NULL, 'S06EC320' 
		END CATCH

		----------------------------------------------------------------------------------
		----Create Records for Student Post Secondary Enrollment
		----------------------------------------------------------------------------------
		BEGIN TRY
			DECLARE @PsEnrolled INT
			DECLARE @psUnenrolled INT
			SELECT @PsEnrolled = [RefPsEnrollmentActionId] 
				FROM [ODS].[RefPsEnrollmentAction] WHERE [Code] = 'Enrolled'
			SELECT @psUnenrolled = [RefPsEnrollmentActionId] 
				FROM [ODS].[RefPsEnrollmentAction] WHERE [Code] = 'NotEnrolled'

			UPDATE sar
			SET [RefPsEnrollmentActionId] = 
						CASE
							WHEN en.PostSecondaryEnrollment = 1  THEN @PsEnrolled
							WHEN en.PostSecondaryEnrollment IS NOT NULL  THEN @psUnenrolled
							ELSE NULL
						END 
				, DiplomaOrCredentialAwardDate = en.DiplomaOrCredentialAwardDate
				, RefHighSchoolDiplomaTypeId = hsd.RefHighSchoolDiplomaTypeId
			FROM [ODS].[K12StudentAcademicRecord] sar
			JOIN [ODS].OrganizationPersonRole opr ON opr.OrganizationPersonRoleID = sar.OrganizationPersonRoleID
			JOIN staging.Enrollment en ON en.OrganizationID_School = opr.OrganizationId AND en.PersonId = opr.PersonId
			LEFT JOIN ODS.SourceSystemReferenceData ssrd
				ON ssrd.InputCode = en.HighSchoolDiplomaType
				AND ssrd.TableName = 'RefHighSchoolDiplomaType'
				AND ssrd.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefHighSchoolDiplomaType hsd
				ON hsd.Code = ssrd.OutputCode


			INSERT INTO [ODS].[K12StudentAcademicRecord]
				(
					[OrganizationPersonRoleId]
					,[RefPsEnrollmentActionId]
					,[DiplomaOrCredentialAwardDate]
					,[RefHighSchoolDiplomaTypeId]
				)
			SELECT 
				opr.OrganizationPersonRoleID  
				,CASE
					WHEN en.PostSecondaryEnrollment = 1  THEN @PsEnrolled
					ELSE @psUnenrolled
				END RefPsEnrollmentActionId
				,en.DiplomaOrCredentialAwardDate
				,hsd.RefHighSchoolDiplomaTypeId
			FROM ods.OrganizationPersonRole opr
			INNER JOIN staging.Enrollment en ON en.OrganizationID_School = opr.OrganizationId AND en.PersonId = opr.PersonId
			LEFT JOIN ODS.SourceSystemReferenceData ssrd
				ON ssrd.InputCode = en.HighSchoolDiplomaType
				AND ssrd.TableName = 'RefHighSchoolDiplomaType'
				AND ssrd.SchoolYear = @SchoolYear
			LEFT JOIN ODS.RefHighSchoolDiplomaType hsd
				ON hsd.Code = ssrd.OutputCode
			LEFT JOIN [ODS].[K12StudentAcademicRecord] aca 
				ON aca.OrganizationPersonRoleId = opr.OrganizationPersonRoleId
			WHERE aca.OrganizationPersonRoleId IS NULL
				AND (en.PostSecondaryEnrollment IS NOT NULL OR en.HighSchoolDiplomaType IS NOT NULL)

		END TRY 

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.RoleAttendance', NULL, 'S06EC320' 
		END CATCH

		----------------------------------------------------------------------------------
		----Create Records for K12StudentCohort
		----------------------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO [ODS].[K12StudentCohort]
					   (
							[OrganizationPersonRoleId]
						   ,[CohortYear]
						   ,[CohortGraduationYear]
						   ,[CohortDescription]
					   )
			SELECT 
				opr.OrganizationPersonRoleID
				,en.CohortYear
				,en.CohortGraduationYear
				,CASE
					WHEN en.CohortDescription = 'Regular diploma' OR en.CohortDescription = 'Alternate Diploma - Removed' THEN en.CohortDescription
					ELSE 'Alternate Diploma'
				 END CohortDescription
			FROM ods.OrganizationPersonRole opr
			INNER JOIN staging.Enrollment en ON en.OrganizationID_School = opr.OrganizationId AND en.PersonId = opr.PersonId
			LEFT JOIN [ODS].[K12StudentCohort] sc 
				ON sc.OrganizationPersonRoleId = opr.OrganizationPersonRoleId
			WHERE sc.OrganizationPersonRoleId IS NULL
				AND en.CohortYear IS NOT NULL

		END TRY 

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.K12StudentCohort', NULL, 'S06EC340' 
		END CATCH

		DROP TABLE #RecordsToDelete_OrganizationPersonRole;
		--Delete when the sesction above is deleted
		--DROP TABLE #RecordsToDelete_PersonProgramParticipation;

		set nocount off;


END