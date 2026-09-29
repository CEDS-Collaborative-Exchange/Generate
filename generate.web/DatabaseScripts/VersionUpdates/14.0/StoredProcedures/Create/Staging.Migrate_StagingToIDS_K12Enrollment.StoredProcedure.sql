CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_K12Enrollment]
AS
	/*************************************************************************************************************
	Date Created:  7/9/2018

	Purpose:
		The purpose of this ETL is to load the Person and Enrollment data 

	Assumptions:
        
	Account executed under: LOGIN

	Approximate run time:  ~ 5 seconds

	Data Sources: 

	Data Targets:  Generate Database:   Generate

	Return Values:
    		0	= Success
  
	Example Usage: 
		EXEC Staging.[Migrate_StagingToIDS_K12Enrollment] 2018;
    
	Modification Log:
		#	  Date		  Issue#   Description
		--  ----------  -------  --------------------------------------------------------------------
		01		  	 
	*************************************************************************************************************/
BEGIN

	
		---TODO: Additional Items to add IN the future - exit/withdraw reason--

        ---------------------------------------------------
        --- Declare Error Handling Variables           ----
        ---------------------------------------------------
		DECLARE @eStoredProc			VARCHAR(100) = 'Migrate_StagingToIDS_K12Enrollment'

		---------------------------------------------------------
        --- Update DataCollectionId in Staging.K12Enrollment  ---
        ---------------------------------------------------------
		BEGIN TRY

			UPDATE e
			SET e.DataCollectionId = dc.DataCollectionId
			FROM Staging.K12Enrollment e
			JOIN dbo.DataCollection dc
				ON e.DataCollectionName = dc.DataCollectionName

		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Enrollment', 'DataCollectionId', 'S03EC090'
		END CATCH

		DECLARE @RefPersonIdentificationSystemId int,@RefPersonalInformationVerificationId int, @k12StudentRoleId int
		SET @RefPersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001075')
		SET @RefPersonalInformationVerificationId = Staging.GetRefPersonalInformationVerificationId('01011')
		SET @k12StudentRoleId = Staging.GetRoleId('K12 Student')

		BEGIN TRY
			UPDATE Staging.K12Enrollment
			SET PersonId = pid.PersonId
			FROM Staging.K12Enrollment ke
			JOIN dbo.PersonIdentifier pid
				ON ke.Student_Identifier_State = pid.Identifier
				AND ISNULL(pid.DataCollectionId, '') = ISNULL(ke.DataCollectionId, '')
			JOIN dbo.OrganizationPersonRole opr
				ON pid.PersonId = opr.OrganizationId
			JOIN dbo.OrganizationIdentifier oi
				ON opr.OrganizationId = oi.OrganizationId
				AND oi.Identifier = ISNULL(ke.School_Identifier_State, ke.LEA_Identifier_State)
			WHERE pid.RefPersonIdentificationSystemId = @RefPersonIdentificationSystemId
			AND pid.RefPersonalInformationVerificationId = @RefPersonalInformationVerificationId
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Enrollment', 'PersonId', 'S03EC100' 
		END CATCH
		
		--------------------------------------------------------------------
		---Associate the LEA OrganizationId with the temporary table -------
		--------------------------------------------------------------------
		DECLARE @RefOrganizationIdentifierTypeId int,@RefOrganizationIdentificationSystemId int
		SET @RefOrganizationIdentifierTypeId = Staging.GetOrganizationIdentifierTypeId('001072')
		SET @RefOrganizationIdentificationSystemId = Staging.GetOrganizationIdentifierSystemId('SEA', '001072')

		BEGIN TRY
			UPDATE Staging.K12Enrollment
			SET OrganizationID_LEA = orgid.OrganizationId
			FROM Staging.K12Enrollment e
			JOIN dbo.OrganizationIdentifier orgid ON e.LEA_Identifier_State = orgid.Identifier
			AND ISNULL(orgid.DataCollectionId, '') = ISNULL(e.DataCollectionId, '')   
			WHERE orgid.RefOrganizationIdentifierTypeId = @RefOrganizationIdentifierTypeId
			AND orgid.RefOrganizationIdentificationSystemId = @RefOrganizationIdentificationSystemId
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Enrollment', 'OrganizationID_LEA', 'S06EC110' 
		END CATCH

		--------------------------------------------------------------------
		---Associate the School OrganizationId with the temporary table ----
		--------------------------------------------------------------------

		DECLARE @RefOrganizationIdentifierTypeId_School int,@RefOrganizationIdentificationSystemId_School int
		SET @RefOrganizationIdentifierTypeId_School = Staging.GetOrganizationIdentifierTypeId('001073')
		SET @RefOrganizationIdentificationSystemId_School = Staging.GetOrganizationIdentifierSystemId('SEA', '001073')


		BEGIN TRY
			UPDATE Staging.K12Enrollment
			SET OrganizationID_School = orgid.OrganizationId
			FROM Staging.K12Enrollment e
			JOIN dbo.OrganizationIdentifier orgid ON e.School_Identifier_State = orgid.Identifier
			AND ISNULL(orgid.DataCollectionId, '') = ISNULL(e.DataCollectionId, '')     
			WHERE orgid.RefOrganizationIdentifierTypeId = @RefOrganizationIdentifierTypeId_School
			AND orgid.RefOrganizationIdentificationSystemId = @RefOrganizationIdentificationSystemId_School
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Enrollment', 'OrganizationID_School', 'S06EC120' 
		END CATCH

		/*
          INSERT one row for each DISTINCT student
          identifier value (could be many records for
          one student). 
          
          Use the MERGE AND OUTPUT statements so that we 
          can INSERT AND also get back the VALUES we 
          want for our crosswalk table. The MERGE statement
          will only perform INSERTs due to the 'ON 1 = 0' clause.
        */
		
         DECLARE
          @student_person_xwalk TABLE (
			  SourceId INT
            , PersonId INT
          );

		BEGIN TRY
			WITH distinctStudents AS (
				SELECT DISTINCT
					  Id
					, PersonId
					, DataCollectionId
				FROM Staging.K12Enrollment
			)
			MERGE INTO dbo.Person TARGET
			USING distinctStudents AS distinctIDs
				ON TARGET.PersonId = distinctIDs.PersonId
			WHEN NOT MATCHED THEN 
				INSERT ( PersonMasterId
					   , DataCollectionId)  
				VALUES ( NULL
					   , distinctIDs.DataCollectionid)   
			OUTPUT distinctIds.Id
				 , INSERTED.PersonId
			INTO @student_person_xwalk (SourceId, PersonId);
		END TRY 

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Person', NULL, 'S03EC110' 
		END CATCH

		BEGIN TRY

		UPDATE Staging.K12Enrollment
			SET PersonId = xwalk.PersonId
			FROM Staging.K12Enrollment k
			JOIN @student_person_xwalk xwalk
				ON k.Id = xwalk.SourceId
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Enrollment', 'PersonId', 'S03EC120' 
		END CATCH

        ------------------------------------------------------------
        --- INSERT PersonIdentifier Records -- K12 Students         ----
        ------------------------------------------------------------
		DECLARE @PersonIdentificationSystemId INT
		DECLARE @PersonalInformationVerificationId INT

		SET @PersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001075' /* Student Identification System */)
		SET @PersonalInformationVerificationId = Staging.GetRefPersonalInformationVerificationId('01011')

		BEGIN TRY    
			INSERT dbo.PersonIdentifier
				(
				  PersonId
				, Identifier
				, RefPersonIdentificationSystemId
				, RefPersonalInformationVerificationId
				, DataCollectionId
				)
			SELECT DISTINCT
				p.PersonId
			   ,p.Student_Identifier_State AS Identifier
			   ,@PersonIdentificationSystemId AS RefPersonIdentificationSystemId
			   ,@PersonalInformationVerificationId AS RefPersonalInformationVerificationId
			   ,p.DataCollectionId
			FROM Staging.K12Enrollment p
			LEFT JOIN dbo.PersonIdentifier pid 
				ON pid.PersonId = p.PersonId 
				AND pid.Identifier = p.Student_Identifier_State
				AND pid.RefPersonIdentificationSystemId = @PersonIdentificationSystemId
				AND PID.RefPersonalInformationVerificationId = @PersonalInformationVerificationId
				AND ISNULL(pid.DataCollectionId, '') = ISNULL(p.DataCollectionId, '')
			WHERE pid.PersonId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonIdentifier', NULL, 'S03EC130' 
		END CATCH

        ------------------------------------------------------------
        --- Merge Person Details					        ----
        ------------------------------------------------------------
		DECLARE @PersonalIdVerificationId INT
		SET @PersonalIdVerificationId = Staging.GetRefPersonalInformationVerificationId('01011')


		BEGIN TRY
			INSERT INTO dbo.PersonDetail 
			SELECT 
				  sp.PersonId
				, LEFT(sp.FirstName, 35)
				, LEFT(sp.MiddleName, 35)
				, ISNULL(LEFT(sp.LastName, 35),'MISSING') 
				, NULL
				, NULL
				, sp.Birthdate
				, NULL
				, ISNULL(sp.HispanicLatinoEthnicity, 0)
				, NULL
				, NULL
				, NULL
				, NULL
				, NULL
				, @PersonalIdVerificationId 
				, NULL
				, NULL
				, Staging.GetFiscalYearStartDate(sp.SchoolYear) 
				, NULL
				, sp.DataCollectionId
			FROM Staging.K12Enrollment sp
			LEFT JOIN dbo.PersonDetail pd
				ON sp.PersonId = pd.PersonId
				AND ISNULL(sp.DataCollectionId, '') = ISNULL(pd.DataCollectionId, '')
			WHERE pd.PersonId IS NULL
			  
		  UPDATE dbo.PersonDetail
		  SET RefSexId = s.RefSexId
		  FROM Staging.K12Enrollment p
		  JOIN dbo.PersonDetail pd
				ON p.PersonId = pd.PersonId
				AND ISNULL(p.DataCollectionId, '') = ISNULL(pd.DataCollectionId, '')
		  JOIN [Staging].[SourceSystemReferenceData] ref
				ON p.Sex = ref.InputCode
				AND ref.TableName = 'RefSex'
				AND ref.SchoolYear = p.SchoolYear
		  JOIN dbo.RefSex s
				ON ref.OutputCode = s.Code
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonDetail', NULL, 'S03EC150' 
		END CATCH


		----------------------------------------------------------------------------------------
		---Manage the OrganizationPersonRole Records for each Student to LEA relationship ------
		----------------------------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO [dbo].[OrganizationPersonRole]
						([OrganizationId]
						,[PersonId]
						,[RoleId]
						,[EntryDate]
						,[ExitDate]
						,[DataCollectionId])
			SELECT DISTINCT
						e.OrganizationID_LEA [OrganizationId]
						,e.PersonID [PersonId]
						,@k12StudentRoleId [RoleId]
						,EnrollmentEntryDate [EntryDate]
						,EnrollmentExitDate [ExitDate]
						,e.DataCollectionId
			FROM Staging.K12Enrollment e
			LEFT JOIN dbo.OrganizationPersonRole opr 
				ON e.PersonID = opr.PersonId
				AND ISNULL(e.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')  
				AND e.EnrollmentEntryDate = opr.EntryDate
				AND ISNULL(e.EnrollmentExitDate, '1900-01-01') = ISNULL(opr.ExitDate, '1900-01-01')
				AND e.OrganizationID_LEA = opr.OrganizationId
				AND opr.RoleId = @k12StudentRoleId
			WHERE opr.PersonId IS NULL
				AND e.OrganizationID_LEA IS NOT NULL
				AND e.PersonID IS NOT NULL
				--AND e.EnrollmentEntryDate >= Staging.GetFiscalYearStartDate(e.SchoolYear)
				--AND (e.EnrollmentExitDate IS NULL OR e.EnrollmentExitDate <= Staging.GetFiscalYearEndDate(e.SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S06EC130' 
		END CATCH

		BEGIN TRY
			UPDATE Staging.K12Enrollment
			SET OrganizationPersonRoleId_LEA = opr.OrganizationPersonRoleId
			FROM Staging.K12Enrollment e
			JOIN dbo.OrganizationPersonRole opr 
				ON  e.PersonID = opr.PersonId 
				AND ISNULL(e.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '') 
			WHERE e.OrganizationID_LEA = opr.OrganizationId
				AND opr.RoleId = @k12StudentRoleId
				AND EntryDate = e.EnrollmentEntryDate
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Enrollment', 'OrganizationPersonRoleId_LEA', 'S06EC140' 
		END CATCH

		-------------------------------------------------------------------------------------------
		---Manage the OrganizationPersonRole Records for each Student to School relationship ------
		-------------------------------------------------------------------------------------------

		BEGIN TRY
			INSERT INTO [dbo].[OrganizationPersonRole]
					   ([OrganizationId]
					   ,[PersonId]
					   ,[RoleId]
					   ,[EntryDate]
					   ,[ExitDate]
					   ,DataCollectionId)
			SELECT DISTINCT
						e.OrganizationID_School [OrganizationId]
					   ,e.PersonID [PersonId]
					   ,@k12StudentRoleId [RoleId]
					   ,EnrollmentEntryDate [EntryDate]
					   ,EnrollmentExitDate [ExitDate]
					   ,e.DataCollectionId
			FROM Staging.K12Enrollment e
			LEFT JOIN dbo.OrganizationPersonRole opr 
				ON  e.PersonID = opr.PersonId
				AND ISNULL(e.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')  
				AND e.EnrollmentEntryDate = opr.EntryDate
				AND ISNULL(e.EnrollmentExitDate, '1900-01-01') = ISNULL(opr.ExitDate, '1900-01-01')
				AND e.OrganizationID_School = opr.OrganizationId
				AND opr.RoleId = @k12StudentRoleId
			WHERE opr.PersonId IS NULL
				AND e.OrganizationID_School IS NOT NULL
				AND e.PersonID IS NOT NULL
				--AND e.EnrollmentEntryDate >= Staging.GetFiscalYearStartDate(e.SchoolYear)
				--AND (e.EnrollmentExitDate IS NULL OR e.EnrollmentExitDate <= Staging.GetFiscalYearEndDate(e.SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S06EC150' 
		END CATCH

		BEGIN TRY
			UPDATE Staging.K12Enrollment
			SET OrganizationPersonRoleId_School = opr.OrganizationPersonRoleId
			FROM Staging.K12Enrollment e
			JOIN dbo.OrganizationPersonRole opr 
				ON e.PersonID = opr.PersonId 
				AND ISNULL(e.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')  
			WHERE e.OrganizationID_School = opr.OrganizationId
				AND opr.RoleId = @k12StudentRoleId
				AND EntryDate = e.EnrollmentEntryDate
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Enrollment', 'OrganizationPersonRoleId_School', 'S06EC160' 
		END CATCH
		

		--------------------------------------------------------------------------------------
		-------Delete any OrganizationPersonRole Records NOT found IN the staging table ------
		--------------------------------------------------------------------------------------

		--CREATE TABLE #RecordsToDelete_OrganizationPersonRole
		--	(OrganizationPersonRoleId INT
		--	,DataCollectionId INT) 

		----LEA
		--BEGIN TRY
		--	INSERT INTO #RecordsToDelete_OrganizationPersonRole
		--		(OrganizationPersonRoleId)
		--	SELECT DISTINCT 
		--		  OrganizationPersonRoleId
		--		, orgd.DataCollectionId 
		--		, orgd.DataCollectionId 
		--	FROM dbo.OrganizationPersonRole opr
		--	JOIN dbo.OrganizationDetail orgd 
		--		ON opr.OrganizationId = orgd.OrganizationId
		--		AND ISNULL(opr.DataCollectionId, '') = ISNULL(orgd.DataCollectionId, '')
		--	JOIN Staging.K12Enrollment e 
		--		ON opr.OrganizationPersonRoleId = e.OrganizationPersonRoleId_LEA
		--		AND  ISNULL(opr.DataCollectionId, '') = ISNULL(e.DataCollectionid, '')
		--	WHERE e.Id IS NULL
		--		AND opr.RoleId = @k12StudentRoleId
		--		AND orgd.RefOrganizationTypeId = Staging.GetOrganizationTypeId('LEA', '001156')
		--		AND opr.EntryDate IS NOT NULL
		--		AND opr.EntryDate >= Staging.GetFiscalYearStartDate(e.SchoolYear)
		--END TRY

		--BEGIN CATCH 
		--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '#RecordsToDelete_OrganizationPersonRole', NULL, 'S06EC170' 
		--END CATCH


		----School
		--BEGIN TRY
		--	INSERT INTO #RecordsToDelete_OrganizationPersonRole
		--		(OrganizationPersonRoleId
		--		,DataCollectionId)  
		--	SELECT DISTINCT OrganizationPersonRoleId, e.DataCollectionId
		--	FROM dbo.OrganizationPersonRole opr
		--	JOIN dbo.OrganizationDetail orgd 
		--		ON opr.OrganizationId = orgd.OrganizationId
		--		AND ISNULL(opr.DataCollectionId, '') = ISNULL(orgd.DataCollectionId, '')
		--	JOIN Staging.K12Enrollment e 
		--		ON opr.OrganizationPersonRoleId = e.OrganizationPersonRoleId_School
		--		AND ISNULL(opr.DataCollectionId, '') = ISNULL(e.DataCollectionId, '')
		--	WHERE e.Id IS NULL
		--		AND opr.RoleId = @k12StudentRoleId
		--		AND orgd.RefOrganizationTypeId = Staging.GetOrganizationTypeId('K12School', '001156')
		--		AND opr.EntryDate IS NOT NULL
		--		AND opr.EntryDate >= Staging.GetFiscalYearStartDate(e.SchoolYear)
		--END TRY

		--BEGIN CATCH 
		--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, '#RecordsToDelete_OrganizationPersonRole', NULL, 'S06EC180' 
		--END CATCH

		----Verify this IS IN the Program ETL AND THEN DELETE
		----CREATE TABLE #RecordsToDelete_PersonProgramParticipation
		----	(PersonProgramParticipationId INT)


		----INSERT INTO #RecordsToDelete_PersonProgramParticipation
		----	(PersonProgramParticipationId)
		----SELECT DISTINCT PersonProgramParticipationId
		----FROM dbo.PersonProgramParticipation ppp
		----JOIN #RecordsToDelete_OrganizationPersonRole rtdopr 
		----	ON ppp.OrganizationPersonRoleId = rtdopr.OrganizationPersonRoleId


		-----------------------------------------------------------------------------
		----Remove any records that are NOT IN the Current ODS for this School Year--
		-----------------------------------------------------------------------------
		--/*dbo.K12StudentDiscipline*/
		--BEGIN TRY
		--	DELETE opr FROM dbo.K12StudentDiscipline opr JOIN #RecordsToDelete_OrganizationPersonRole rtdopr ON opr.OrganizationPersonRoleId = rtdopr.OrganizationPersonRoleId
		--END TRY
		
		--BEGIN CATCH
		--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentDiscipline', NULL, 'S06EC200' 
		--END CATCH

		--/*dbo.K12StudentEnrollment*/
		--BEGIN TRY
		--	DELETE opr FROM dbo.K12StudentEnrollment opr JOIN #RecordsToDelete_OrganizationPersonRole rtdopr ON opr.OrganizationPersonRoleId = rtdopr.OrganizationPersonRoleId
		--END TRY

		--BEGIN CATCH
		--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentEnrollment', NULL, 'S06EC210' 
		--END CATCH
			
		--/*dbo.OrganizationPersonRole*/
		--BEGIN TRY
		--	DELETE opr FROM dbo.OrganizationPersonRole opr Join #RecordsToDelete_OrganizationPersonRole rtdopr ON opr.OrganizationPersonRoleId = rtdopr.OrganizationPersonRoleId
		--END TRY 

		--BEGIN CATCH
		--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S06EC220' 
		--END CATCH

		----------------------------------------------------------------------------------
		----Create LEA K12StudentEnrollment Record for Each Student for Grade Level----
		----------------------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO [dbo].[K12StudentEnrollment]
					   ([OrganizationPersonRoleId]
					   ,[RefEntryGradeLevelId]
					   ,[RefPublicSchoolResidence]
					   ,[RefEnrollmentStatusId]
					   ,[RefEntryType]
					   ,[RefExitGradeLevelId]
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
					   ,[RecordEndDateTime]
					   ,[DataCollectionId])   
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
					   ,e.DataCollectionId						[DataCollectionId]   
			FROM Staging.K12Enrollment e
			LEFT JOIN [Staging].[SourceSystemReferenceData] rdg
				ON e.GradeLevel = rdg.InputCode
				AND rdg.TableName = 'RefGradeLevel'
				AND rdg.SchoolYear = e.SchoolYear
				AND rdg.TableFilter = '000100'
			LEFT JOIN dbo.RefGradeLevel gl --GradeLevel is mandatory for Student/Org Identifiers
				ON rdg.OutputCode = gl.Code
			LEFT JOIN dbo.RefGradeLevelType glt
				ON gl.RefGradeLevelTypeId = glt.RefGradeLevelTypeId
				AND rdg.TableFilter = glt.code
				AND glt.Code = '000100'
			LEFT JOIN [Staging].[SourceSystemReferenceData] rdewt
				ON e.ExitOrWithdrawalType = rdewt.InputCode
				AND rdewt.TableName = 'RefExitOrWithdrawalType'
				AND rdewt.SchoolYear = e.SchoolYear
			LEFT JOIN dbo.RefExitOrWithdrawalType ewt
				ON rdewt.OutputCode = ewt.Code
			-- food service
			LEFT JOIN [Staging].[SourceSystemReferenceData] ssfood
				ON ssfood.InputCode = e.FoodServiceEligibility
				AND ssfood.TableName = 'RefFoodServiceEligibility'
				AND ssfood.SchoolYear = e.SchoolYear
			LEFT JOIN dbo.RefFoodServiceEligibility refssfood
				ON ssfood.OutputCode = refssfood.Code
			WHERE OrganizationPersonRoleId_LEA IS NOT NULL 
		END TRY 

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentEnrollment', NULL, 'S06EC300' 
		END CATCH

		------------------------------------------------------------------------------------------------
		---Manage the OrganizationPersonRoleRelationship Records for each School to LEA relationship ---
		------------------------------------------------------------------------------------------------
		DECLARE @NewOrganizationPersonRoleRelationships TABLE (
			  Id INT
			, OrganizationPersonRoleRelationshipId INT
		)
				
		BEGIN TRY
		  MERGE [dbo].[OrganizationPersonRoleRelationship] AS TARGET
		  USING Staging.K12Enrollment AS SOURCE
			ON TARGET.OrganizationPersonRoleId = SOURCE.OrganizationPersonRoleId_School
			AND TARGET.OrganizationPersonRoleId_Parent = SOURCE.OrganizationPersonRoleId_Lea
			AND TARGET.RecordStartDateTime = SOURCE.EnrollmentEntryDate
		  WHEN MATCHED THEN UPDATE SET [RecordEndDateTime] = SOURCE.EnrollmentExitDate
		  WHEN NOT MATCHED 
			AND SOURCE.OrganizationPersonRoleId_School IS NOT NULL
			AND SOURCE.OrganizationPersonRoleId_Lea IS NOT NULL
			THEN INSERT (
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
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRoleRelationship', NULL, 'S06EC230'
		END CATCH


		BEGIN TRY 
		  UPDATE enr
		  SET OrganizationPersonRoleRelationshipId = noprr.OrganizationPersonRoleRelationshipId
		  FROM Staging.K12Enrollment enr 
		  JOIN @NewOrganizationPersonRoleRelationships noprr
			ON enr.Id = noprr.Id
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Enrollment', 'OrganizationPersonRoleRelationshipId', 'S06EC240' 
		END CATCH

		BEGIN TRY
				UPDATE r SET r.RecordEndDateTime = s.RecordStartDateTime - 1
				FROM dbo.OrganizationPersonRoleRelationship r				
				JOIN (
							SELECT 								  
								 OrganizationPersonRoleId
								,OrganizationPersonRoleId_Parent
								, MAX(OrganizationPersonRoleRelationshipId) AS OrganizationPersonRoleRelationshipId
								, MAX(RecordStartDateTime) AS RecordStartDateTime
							FROM dbo.OrganizationPersonRoleRelationship oprr
							WHERE RecordEndDateTime IS NULL 								
							GROUP BY oprr.OrganizationPersonRoleId,oprr.OrganizationPersonRoleId_Parent
				) s ON  r.OrganizationPersonRoleId = s.OrganizationPersonRoleId
					AND r.OrganizationPersonRoleId_Parent = s.OrganizationPersonRoleId
					AND r.OrganizationPersonRoleRelationshipId <> s.OrganizationPersonRoleRelationshipId
					AND r.RecordEndDateTime IS NULL

		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRoleRelationship', NULL, 'S06EC240'
		END CATCH

		----------------------------------------------------------------------------------
		----Create School K12StudentEnrollment Record for Each Student for Grade Level----
		----------------------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO [dbo].[K12StudentEnrollment]
					   ([OrganizationPersonRoleId]
					   ,[RefEntryGradeLevelId]
					   ,[RefPublicSchoolResidence]
					   ,[RefEnrollmentStatusId]
					   ,[RefEntryType]
					   ,[RefExitGradeLevelId]
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
					   ,[RecordEndDateTime]
					   ,[DataCollectionId])  
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
					   ,EnrollmentEntryDate						[RecordStartDateTime]
					   ,EnrollmentExitDate						[RecordEndDateTime]
					   ,e.DataCollectionId						[DataCollectionId]   
			FROM Staging.K12Enrollment e
			LEFT JOIN [Staging].[SourceSystemReferenceData] rdg
				ON e.GradeLevel = rdg.InputCode
				AND rdg.TableName = 'RefGradeLevel'
				AND rdg.SchoolYear = e.SchoolYear
			LEFT JOIN dbo.RefGradeLevel gl
				ON rdg.OutputCode = gl.Code
			LEFT JOIN dbo.RefGradeLevelType glt
				ON gl.RefGradeLevelTypeId = glt.RefGradeLevelTypeId
				AND rdg.TableFilter = glt.code
				AND glt.Code = '000100'
			LEFT JOIN [Staging].[SourceSystemReferenceData] rdewt
				ON e.ExitOrWithdrawalType = rdewt.InputCode
				AND rdewt.TableName = 'RefExitOrWithdrawalType'
				AND rdewt.SchoolYear = e.SchoolYear
			LEFT JOIN dbo.RefExitOrWithdrawalType ewt
				ON rdewt.OutputCode = ewt.Code
			-- food service
			LEFT JOIN [Staging].[SourceSystemReferenceData] ssfood
				ON ssfood.InputCode = e.FoodServiceEligibility
				AND ssfood.TableName = 'RefFoodServiceEligibility'
				AND ssfood.SchoolYear = e.SchoolYear
			LEFT JOIN dbo.RefFoodServiceEligibility refssfood
				ON ssfood.OutputCode = refssfood.Code

			LEFT JOIN dbo.OrganizationRelationship orl
				ON orl.OrganizationId = e.OrganizationID_School
			WHERE OrganizationPersonRoleId_School IS NOT NULL 
				AND (orl.Parent_OrganizationId = e.OrganizationID_LEA 
					AND e.OrganizationID_School IS NOT NULL)
		END TRY 

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentEnrollment', NULL, 'S06EC310' 
		END CATCH

		----------------------------------------------------------------------------------
		----Create Records for Student Academic Record to store projected graduation date
		----------------------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO [dbo].[K12StudentAcademicRecord]
				(
				  [OrganizationPersonRoleId]
				, [ProjectedGraduationDate]
				, [DataCollectionId]
				)
			SELECT 
				  opr.OrganizationPersonRoleID  
				, CAST(SUBSTRING(en.ProjectedGraduationDate, 1, 4) + SUBSTRING(en.ProjectedGraduationDate, 6, 2) + '01' AS DATETIME)
				, en.DataCollectionId
			FROM dbo.OrganizationPersonRole opr
			JOIN Staging.K12Enrollment en 
				ON en.OrganizationPersonRoleId_School = opr.OrganizationPersonRoleId
			LEFT JOIN dbo.K12StudentAcademicRecord ar
				ON en.OrganizationPersonRoleId_School = ar.OrganizationPersonRoleId
			WHERE ar.OrganizationPersonRoleId IS NULL
		END TRY 

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.RoleAttendance', NULL, 'S06EC320' 
		END CATCH


		----------------------------------------------------------------------------------
		----Create Records for Student Attendance etc
		----------------------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO [dbo].[RoleAttendance]
					([OrganizationPersonRoleId]
					,[NumberOfDaysInAttendance]
					,[NumberOfDaysAbsent]
					,[AttendanceRate]
					,[DataCollectionId])  
			SELECT 
				opr.OrganizationPersonRoleID  
				,CASE
				WHEN ISNULL(en.NumberOfSchoolDays, 0) > 0 THEN en.NumberOfSchoolDays - ISNULL(en.[NumberOfDaysAbsent], 0)
				END NumberOfDaysInAttendance
				, en.[NumberOfDaysAbsent]
				,CASE
				WHEN ISNULL(en.NumberOfSchoolDays, 0) > 0 THEN CAST( (en.NumberOfSchoolDays - ISNULL(en.NumberOfDaysAbsent, 0.0))/en.NumberOfSchoolDays AS  Decimal(5,4))
				END AttendanceRate
				,en.datacollectionid  
			FROM dbo.OrganizationPersonRole opr
			JOIN Staging.K12Enrollment en ON en.OrganizationID_School = opr.OrganizationId AND en.PersonId = opr.PersonId
			LEFT JOIN [dbo].[RoleAttendance] oa ON oa.OrganizationPersonRoleId = opr.OrganizationPersonRoleId
			WHERE oa.RoleAttendanceId IS NULL
		END TRY 

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.RoleAttendance', NULL, 'S06EC320' 
		END CATCH

		----------------------------------------------------------------------------------
		----Create Records for Student Post Secondary Enrollment
		----------------------------------------------------------------------------------
		BEGIN TRY
			DECLARE @PsEnrolled INT
			DECLARE @psUnenrolled INT
			SELECT @PsEnrolled = [RefPsEnrollmentActionId] 
				FROM [dbo].[RefPsEnrollmentAction] WHERE [Code] = 'Enrolled'
			SELECT @psUnenrolled = [RefPsEnrollmentActionId] 
				FROM [dbo].[RefPsEnrollmentAction] WHERE [Code] = 'NotEnrolled'

			UPDATE sar
			SET [RefPsEnrollmentActionId] = 
						CASE
							WHEN en.PostSecondaryEnrollment = 1  THEN @PsEnrolled
							WHEN en.PostSecondaryEnrollment IS NOT NULL  THEN @psUnenrolled
							ELSE NULL
						END 
				, ProjectedGraduationDate = en.ProjectedGraduationDate
				, DiplomaOrCredentialAwardDate = en.DiplomaOrCredentialAwardDate
				, RefHighSchoolDiplomaTypeId = hsd.RefHighSchoolDiplomaTypeId
			FROM [dbo].[K12StudentAcademicRecord] sar
			JOIN [dbo].OrganizationPersonRole opr ON opr.OrganizationPersonRoleID = sar.OrganizationPersonRoleID
			JOIN Staging.K12Enrollment en ON en.OrganizationID_School = opr.OrganizationId AND en.PersonId = opr.PersonId
			LEFT JOIN [Staging].[SourceSystemReferenceData] ssrd
				ON ssrd.InputCode = en.HighSchoolDiplomaType
				AND ssrd.TableName = 'RefHighSchoolDiplomaType'
				AND ssrd.SchoolYear = en.SchoolYear
			LEFT JOIN dbo.RefHighSchoolDiplomaType hsd
				ON hsd.Code = ssrd.OutputCode


			INSERT INTO [dbo].[K12StudentAcademicRecord]
				(
					[OrganizationPersonRoleId]
					,[RefPsEnrollmentActionId]
					,[ProjectedGraduationDate]
					,[DiplomaOrCredentialAwardDate]
					,[RefHighSchoolDiplomaTypeId]
					,[DataCollectionId] 
				)
			SELECT 
				opr.OrganizationPersonRoleID  
				,CASE
					WHEN en.PostSecondaryEnrollment = 1  THEN @PsEnrolled
					ELSE @psUnenrolled
				END RefPsEnrollmentActionId
				,en.ProjectedGraduationDate
				,en.DiplomaOrCredentialAwardDate
				,hsd.RefHighSchoolDiplomaTypeId
				,en.DataCollectionId -- added
			FROM dbo.OrganizationPersonRole opr
			JOIN Staging.K12Enrollment en ON en.OrganizationID_School = opr.OrganizationId AND en.PersonId = opr.PersonId
			LEFT JOIN [Staging].[SourceSystemReferenceData] ssrd
				ON ssrd.InputCode = en.HighSchoolDiplomaType
				AND ssrd.TableName = 'RefHighSchoolDiplomaType'
				AND ssrd.SchoolYear = en.SchoolYear
			LEFT JOIN dbo.RefHighSchoolDiplomaType hsd
				ON hsd.Code = ssrd.OutputCode
			LEFT JOIN [dbo].[K12StudentAcademicRecord] aca 
				ON aca.OrganizationPersonRoleId = opr.OrganizationPersonRoleId
				AND ISNULL(aca.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '') 
			WHERE aca.OrganizationPersonRoleId IS NULL
				--AND (en.PostSecondaryEnrollment IS NOT NULL OR en.HighSchoolDiplomaType IS NOT NULL)

		END TRY 

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.RoleAttendance', NULL, 'S06EC320' 
		END CATCH

		----------------------------------------------------------------------------------
		----Create Records for K12StudentCohort
		----------------------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO [dbo].[K12StudentCohort]
					   (
							[OrganizationPersonRoleId]
						   ,[CohortYear]
						   ,[CohortGraduationYear]
						   ,[CohortDescription]
						   ,[DataCollectionId] 
					   )
			SELECT 
				opr.OrganizationPersonRoleID
				,en.CohortYear
				,en.CohortGraduationYear
				,CASE
					WHEN en.CohortDescription = 'Regular diploma' OR en.CohortDescription = 'Alternate Diploma - Removed' THEN en.CohortDescription
					ELSE 'Alternate Diploma'
				 END CohortDescription
				 ,en.DataCollectionId 
			FROM dbo.OrganizationPersonRole opr
			JOIN Staging.K12Enrollment en 
				ON en.OrganizationID_School = opr.OrganizationId 
				AND en.PersonId = opr.PersonId
				AND ISNULL(opr.DataCollectionId, '') = ISNULL(en.DataCollectionId, '')
			LEFT JOIN [dbo].[K12StudentCohort] sc 
				ON sc.OrganizationPersonRoleId = opr.OrganizationPersonRoleId
				AND ISNULL(sc.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '') 
			WHERE sc.OrganizationPersonRoleId IS NULL
				--AND en.CohortYear IS NOT NULL

		END TRY 

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentCohort', NULL, 'S06EC340' 
		END CATCH

				BEGIN TRY
			INSERT INTO [dbo].[K12StudentCohort]
					   (
							[OrganizationPersonRoleId]
						   ,[CohortYear]
						   ,[CohortGraduationYear]
						   ,[CohortDescription]
						   ,[DataCollectionId] 
					   )
			SELECT 
				opr.OrganizationPersonRoleID
				,en.CohortYear
				,en.CohortGraduationYear
				,CASE
					WHEN en.CohortDescription = 'Regular diploma' OR en.CohortDescription = 'Alternate Diploma - Removed' THEN en.CohortDescription
					ELSE 'Alternate Diploma'
				 END CohortDescription
				 ,en.DataCollectionId 
			FROM dbo.OrganizationPersonRole opr
			JOIN Staging.K12Enrollment en 
				ON en.OrganizationID_LEA = opr.OrganizationId
				AND en.PersonId = opr.PersonId
				AND ISNULL(opr.DataCollectionId, '') = ISNULL(en.DataCollectionId, '')
			LEFT JOIN [dbo].[K12StudentCohort] sc 
				ON sc.OrganizationPersonRoleId = opr.OrganizationPersonRoleId
				AND ISNULL(sc.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '') 
			WHERE sc.OrganizationPersonRoleId IS NULL
				--AND en.CohortYear IS NOT NULL

		END TRY 

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentCohort', NULL, 'S06EC340' 
		END CATCH

		--DROP TABLE #RecordsToDelete_OrganizationPersonRole;
		--Delete WHEN the sesction above IS deleted
		--DROP TABLE #RecordsToDelete_PersonProgramParticipation;

		SET nocount off;

END



