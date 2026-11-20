CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_PsStudentEnrollment]
	--@SchoolYear SMALLINT = NULL
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
		EXEC Staging.[Migrate_StagingToIDS_PsStudentEnrollment] 2018;
    
	Modification Log:
		#	  Date		  Issue#   Description
		--  ----------  -------  --------------------------------------------------------------------
		01		  	 
	*************************************************************************************************************/
BEGIN
	
		---------------------------------------------------
        --- Declare Error Handling Variables           ----
        ---------------------------------------------------
		DECLARE @eStoredProc			VARCHAR(100) = 'Migrate_StagingToIDS_PsStudentEnrollment'

	    ---------------------------------------------------
        --- Update DataCollectionId in Staging.K12Enrollment  ----Added
        ---------------------------------------------------
		BEGIN TRY
		
		UPDATE pe
		SET DataCollectionId = dc.DataCollectionId
		FROM [Staging].[PsStudentEnrollment] pe
		JOIN dbo.DataCollection dc
			ON pe.DataCollectionName = dc.DataCollectionName

		END TRY	

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PsStudentEnrollment', 'DataCollectionId', 'S03EC090'
		END CATCH

		DECLARE @RefPersonIdentificationSystemId int,@RefPersonalInformationVerificationId int
		SET @RefPersonIdentificationSystemId = Staging.GetRefPersonIdentificationSystemId('State', '001075')
		SET @RefPersonalInformationVerificationId = Staging.GetRefPersonalInformationVerificationId('01011')

		BEGIN TRY
			UPDATE Staging.PsStudentEnrollment
			SET PersonId = pid.PersonId
			FROM Staging.PsStudentEnrollment e
			JOIN dbo.PersonIdentifier pid 
				ON e.Student_Identifier_State = pid.Identifier
				AND ISNULL(e.DataCollectionId, '') = ISNULL(pid.DataCollectionId, '')
			WHERE pid.RefPersonIdentificationSystemId = @RefPersonIdentificationSystemId
			AND pid.RefPersonalInformationVerificationId = @RefPersonalInformationVerificationId

		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12Enrollment', 'PersonId', 'S03EC100' 
		END CATCH
		

		-------------------------------------------------------------
		---Associate the PS Institution with the temporary table ----
		-------------------------------------------------------------

		DECLARE @RefOrganizationIdentifierTypeId int
		SET @RefOrganizationIdentifierTypeId = Staging.GetOrganizationIdentifierTypeId('000166')


		BEGIN TRY
			UPDATE Staging.PsStudentEnrollment
			SET OrganizationId_PsInstitution = orgid.OrganizationId
			FROM Staging.PsStudentEnrollment e
			JOIN dbo.OrganizationIdentifier orgid 
				ON e.InstitutionIpedsUnitId = orgid.Identifier
				AND ISNULL(orgid.DataCollectionId, '') = ISNULL(e.DataCollectionId, '')
			WHERE orgid.RefOrganizationIdentifierTypeId = @RefOrganizationIdentifierTypeId
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PsStudentEnrollment', 'OrganizationID_School', 'S06EC120' 
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
              PersonId INT
			, Student_Identifier_State VARCHAR(100)
			, InsitutitionIpedsUnitId VARCHAR(100)
			, DataCollectionId INT
          );

		BEGIN TRY
			WITH distinctStudents AS (
				SELECT DISTINCT
					  PersonId
					, Student_Identifier_State
					, InstitutionIpedsUnitId 
					, DataCollectionId
				FROM Staging.PsStudentEnrollment e
			)
			MERGE INTO dbo.Person TARGET
			USING distinctStudents AS distinctIDs
				ON TARGET.PersonId = distinctIDs.PersonId
			WHEN NOT MATCHED THEN 
				INSERT ( PersonMasterId
					   , DataCollectionId)  
				VALUES ( NULL
					   , distinctIDs.DataCollectionid)   
			OUTPUT INSERTED.PersonId
				  ,distinctIDs.Student_Identifier_State
				  ,distinctIDs.InstitutionIpedsUnitId
				  ,distinctIDs.DataCollectionId
			INTO @student_person_xwalk (PersonId, Student_Identifier_State, InsitutitionIpedsUnitId, DataCollectionid);
		END TRY 

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Person', NULL, 'S03EC110' 
		END CATCH

		BEGIN TRY

		UPDATE Staging.PsStudentEnrollment
			SET PersonId = xwalk.PersonId
			FROM Staging.PsStudentEnrollment k
			JOIN @student_person_xwalk xwalk
				ON k.Student_Identifier_State = xwalk.Student_Identifier_State
				AND InstitutionIpedsUnitId = xwalk.InsitutitionIpedsUnitId
				AND ISNULL(k.DataCollectionId, '') = ISNULL(xwalk.DataCollectionId, '')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PsStudentEnrollment', 'PersonId', 'S03EC120' 
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
			FROM Staging.PsStudentEnrollment p
			LEFT JOIN dbo.PersonIdentifier pid 
				ON pid.Identifier = p.Student_Identifier_State
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
				, s.RefSexId
				, ISNULL(sp.HispanicLatinoEthnicity, 0)
				, NULL
				, NULL
				, NULL
				, NULL
				, NULL
				, @PersonalIdVerificationId 
				, NULL
				, NULL
				, sp.EntryDate
				, sp.ExitDate
				, sp.DataCollectionId
			FROM Staging.PsStudentEnrollment sp
			LEFT JOIN [Staging].[SourceSystemReferenceData] ref
				ON sp.Sex = ref.InputCode
				AND ref.TableName = 'RefSex'
				AND ref.SchoolYear = sp.SchoolYear
			LEFT JOIN dbo.RefSex s
				ON ref.OutputCode = s.Code
			LEFT JOIN dbo.PersonDetail pd
				ON sp.PersonId = pd.PersonId
				AND sp.EntryDate = pd.RecordStartDateTime
				AND ISNULL(sp.DataCollectionId, '') = ISNULL(pd.DataCollectionId, '')
			WHERE pd.PersonId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.PersonDetail', NULL, 'S03EC150' 
		END CATCH

		------------------------------------------------------------
		--- Check for existing PS Institution Enrollment data ------
		------------------------------------------------------------
		DECLARE @GetRoleId INT
	    SET @GetRoleId = Staging.GetRoleId('Postsecondary Student')

		BEGIN TRY
			INSERT INTO [dbo].OrganizationPersonRole
						( [OrganizationId]
						, [PersonId]
						, [RoleId]
						, [EntryDate]
						, [ExitDate]
						, [DataCollectionId])
			SELECT DISTINCT
						  e.OrganizationID_PsInstitution [OrganizationId]
						, e.PersonID [PersonId]
						, Staging.GetRoleId('Postsecondary Student') [RoleId]
						, ISNULL(NULL,e.EntryDate) [EntryDate]
						, ISNULL(NULL,e.ExitDate)  [ExitDate]
						, e.DataCollectionId
			FROM Staging.PsStudentEnrollment e
			LEFT JOIN dbo.OrganizationPersonRole opr 
				ON e.PersonID = opr.PersonId
				AND ISNULL(e.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND e.EntryDate = opr.EntryDate
				AND e.OrganizationID_PsInstitution = opr.OrganizationId
				AND opr.RoleId = @GetRoleId
			WHERE opr.PersonId IS NULL
				AND e.OrganizationID_PsInstitution IS NOT NULL
				AND e.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S06EC130' 
		END CATCH

		BEGIN TRY
			UPDATE Staging.PsStudentEnrollment
			SET OrganizationPersonRoleId = opr.OrganizationPersonRoleId
			FROM Staging.PsStudentEnrollment e
			JOIN dbo.OrganizationPersonRole opr 
				ON e.PersonID = opr.PersonId 
				AND ISNULL(e.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
			WHERE e.OrganizationId_PsInstitution = opr.OrganizationId
				AND opr.RoleId = @GetRoleId
				AND opr.EntryDate = e.EntryDate
				AND opr.ExitDate = e.ExitDate
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PsStudentEnrollment', 'OrganizationPersonRoleId_PsInstitution', 'S06EC140' 
		END CATCH
		-----------------------------------------------------------------------------------------
		----Create PsStudentEnrollment Record for Each Student for students who have exited  ----
		-----------------------------------------------------------------------------------------
		BEGIN TRY
			INSERT INTO [dbo].[PsStudentEnrollment]
					   ( [OrganizationPersonRoleId]
					   , [RefPSExitOrWithdrawalTypeId]
					   , [EntryDateIntoPostsecondary]
					   , [DataCollectionId]
					   )
			SELECT DISTINCT
						 e.OrganizationPersonRoleId					[OrganizationPersonRoleId]
					   , pewt.RefPSExitOrWithdrawalTypeId			[RefPSExitOrWithdrawalTypeId]
					   , e.EntryDateIntoPostsecondary				[EntryDateIntoPostsecondary]
					   , e.DataCollectionId							[DataCollectionId]
			FROM Staging.PsStudentEnrollment e
			LEFT JOIN [Staging].[SourceSystemReferenceData] ssrd
				ON e.PostsecondaryExitOrWithdrawalType = ssrd.InputCode
				AND ssrd.TableName = 'RefPsExitOrWithdrawalType'
				AND ssrd.SchoolYear = e.SchoolYear
			LEFT JOIN dbo.RefPsExitOrWithdrawalType pewt
				ON ssrd.OutputCode = pewt.Code
			WHERE e.OrganizationPersonRoleId IS NOT NULL 
		END TRY 

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12StudentEnrollment', NULL, 'S06EC300' 
		END CATCH


		SET nocount off;


END
