---It would be good to just go ahead and include Staff in this process as well to maintain unique staff ID's
---Inform the process for when/if ID's change - how will that be addressed, perhaps not now, but in the future.
-------will the use of PersonMaster come into play?
-------Note: id's can change so long as the end result - report outcome would be the same?
CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP03_Person_EncapsulatedCode]
	@SchoolYear SMALLINT = NULL
AS
    /*************************************************************************************************************
    Date Created:  2/12/2018

    Purpose:
        The purpose of this ETL is to maintain the unique list of Student & Staff Identifiers assigned by the state
		in the ODS.

    Assumptions:
        

    Account executed under: LOGIN

    Approximate run time:  ~ 5 seconds

    Data Sources:  

    Data Targets:  Generate Database:   Generate.ODS.Person
										Generate.ODS.PersonDetail
										Generate.ODS.PersonIdentifier

    Return Values:
    	 0	= Success
       All Errors are Thrown via Try/Catch Block	
  
    Example Usage: 
      EXEC App.[Migrate_Data_ETL_IMPLEMENTATION_STEP03_Person_EncapsulatedCode] 2018;
    
    Modification Log:
      #	  Date		    Developer	  Issue#	 Description
      --  ----------  ----------  -------  --------------------------------------------------------------------
      01		  	 
    *************************************************************************************************************/
    BEGIN

        SET NOCOUNT ON;
		
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
		DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP03_Person_EncapsulatedCode'

        ---------------------------------------------------
        --- Declare Common Use Variables		       ----
        ---------------------------------------------------
		DECLARE @PersonIdentificationSystemId INT
		DECLARE @PersonalInformationVerificationId INT

		SET @PersonalInformationVerificationId = App.GetRefPersonalInformationVerificationId('01011')

		------------------------------------------------------------
        --- Insert Person Records                                ---
        ------------------------------------------------------------
        /*
		  Grab the existing PersonId for people that already exist.
		*/ 

		BEGIN TRY
			UPDATE Staging.Person
			SET PersonId = pid.PersonId
			FROM Staging.Person sp
			JOIN ods.PersonIdentifier pid
				ON sp.Identifier = pid.Identifier
			WHERE ((sp.[Role] = 'K12 Student'
					AND pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075' /* Student Identification System */))
				OR (sp.[Role] = 'K12 Personnel'
					AND pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001074' /* Staff Member Identification System */)))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Person', 'PersonId', 'S03EC100'
		END CATCH

		/*
         Insert one row for each distinct student identifier value (could be many records for one student). 
          
          Use the MERGE and OUTPUT statements so that we can insert and also get back the values we 
          want for our crosswalk table. The MERGE statement will only perform INSERTs due to the 'ON 1 = 0' clause.
        */
		
        DECLARE
          @student_person_xwalk TABLE (
              PersonId INT
			, SourceId INT
          );

		BEGIN TRY
			MERGE INTO ODS.Person TARGET
			USING Staging.Person AS distinctIDs
				ON TARGET.PersonId = distinctIDs.PersonId
			WHEN NOT MATCHED THEN 
				INSERT (PersonMasterId)
				VALUES (NULL)
			OUTPUT INSERTED.PersonId
				  ,distinctIDs.Id AS SourceId
			INTO @student_person_xwalk (PersonId, SourceId);
		END TRY 

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Person', NULL, 'S03EC110'
		END CATCH

		BEGIN TRY

			UPDATE Staging.Person
			SET PersonId = xwalk.PersonId
			FROM Staging.Person p
			JOIN @student_person_xwalk xwalk
				ON p.Id = xwalk.SourceId

		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.Person', 'PersonId', 'S03EC120'
		END CATCH

        ------------------------------------------------------------
        --- Insert PersonIdentifier Records -- Students         ----
        ------------------------------------------------------------
		SET @PersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075' /* Student Identification System */)

		BEGIN TRY    
			INSERT ODS.PersonIdentifier
				(PersonId, Identifier, RefPersonIdentificationSystemId, RefPersonalInformationVerificationId)
			SELECT DISTINCT
				PersonId = p.PersonId
				, Identifier = p.Identifier
				, RefPersonIdentificationSystemId = @PersonIdentificationSystemId
				, RefPersonalInformationVerificationId = @PersonalInformationVerificationId
			FROM Staging.Person p
			LEFT JOIN ODS.PersonIdentifier pid 
				ON pid.PersonId = p.PersonId 
				AND pid.Identifier = p.Identifier
				AND pid.RefPersonIdentificationSystemId = @PersonIdentificationSystemId
				AND PID.RefPersonalInformationVerificationId = @PersonalInformationVerificationId
			WHERE [Role] = 'K12 Student'
			AND  pid.PersonId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonIdentifier', NULL, 'S03EC130' 
		END CATCH

        ------------------------------------------------------------
        --- Insert PersonIdentifier Records -- Personnel        ----
        ------------------------------------------------------------
		SET @PersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001074' /* Staff Member Identification System */)

		BEGIN TRY

			INSERT ODS.PersonIdentifier
				(PersonId, Identifier, RefPersonIdentificationSystemId, RefPersonalInformationVerificationId)
			SELECT DISTINCT
				PersonId = p.PersonId
				, Identifier = p.Identifier
				, RefPersonIdentificationSystemId = @PersonIdentificationSystemId
				, RefPersonalInformationVerificationId = @PersonalInformationVerificationId
			FROM Staging.Person p
			LEFT JOIN ODS.PersonIdentifier pid 
				ON pid.PersonId = p.PersonId 
				AND pid.Identifier = p.Identifier
				AND pid.RefPersonIdentificationSystemId = @PersonIdentificationSystemId
				AND PID.RefPersonalInformationVerificationId = @PersonalInformationVerificationId
			WHERE [Role] = 'K12 Personnel'
			AND  pid.PersonId IS NULL
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonIdentifier', NULL, 'S03EC140'
		END CATCH

        ------------------------------------------------------------
        --- Merge Person Details		     			        ----
        ------------------------------------------------------------
		--Student
		SET @PersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075' /* Student Identification System */)
		BEGIN TRY

			;WITH CTE AS 
			( 
				SELECT DISTINCT 
                    sp.PersonId
                    , sp.FirstName
                    , sp.LastName
                    , sp.MiddleName
                    , sp.BirthDate
					, rs.RefSexId
					, sp.HispanicLatinoEthnicity
					, sp.RecordStartDateTime
					, sp.RecordEndDateTime
				FROM staging.Person sp
					INNER JOIN ODS.SourceSystemReferenceData ref
						ON sp.Sex = ref.InputCode
						AND ref.TableName = 'RefSex'
						AND ref.SchoolYear = @SchoolYear
					INNER JOIN ODS.RefSex rs
						ON ref.OutputCode = rs.Code
					INNER JOIN ods.PersonIdentifier pi
						ON sp.Identifier = pi.Identifier
						AND pi.RefPersonIdentificationSystemId = @PersonIdentificationSystemId
						AND pi.RefPersonalInformationVerificationId = @PersonalInformationVerificationId
				WHERE ISNULL(sp.RecordStartDateTime,'') <> ''
				AND (sp.RecordEndDateTime is null 
					OR sp.RecordEndDateTime > sp.RecordStartDateTime)
				GROUP BY sp.PersonId, sp.FirstName, sp.MiddleName, sp.LastName, sp.BirthDate, rs.RefSexId
						,sp.HispanicLatinoEthnicity, sp.RecordStartDateTime, sp.RecordEndDateTime
			)
			MERGE ODS.PersonDetail AS trgt
			USING CTE AS src
					ON  trgt.PersonId = src.PersonId
					AND trgt.RecordStartDateTime = src.RecordStartDateTime
			WHEN MATCHED AND (
					ISNULL(trgt.FirstName, '') <> ISNULL(src.FirstName, '')
					OR ISNULL(trgt.LastName, '') <> ISNULL(src.LastName, '')
					OR ISNULL(trgt.MiddleName, '') <> ISNULL(src.MiddleName, '')
					OR ISNULL(trgt.Birthdate, '1/1/1900') <> ISNULL(src.Birthdate, '1/1/1900')
					OR ISNULL(trgt.RefSexId, '') <> ISNULL(src.RefSexId, '')
					OR ISNULL(trgt.HispanicLatinoEthnicity, '') <> ISNULL(src.HispanicLatinoEthnicity, '')
					OR ISNULL(trgt.RecordEndDateTime, '1/1/1900') <> ISNULL(src.RecordEndDateTime, '1/1/1900')
					)
				THEN 
					UPDATE SET 
						trgt.Birthdate = src.Birthdate
						, trgt.FirstName = src.FirstName
						, trgt.LastName = src.LastName
						, trgt.MiddleName = src.MiddleName
						, trgt.RefSexId = src.RefSexId
						, trgt.HispanicLatinoEthnicity = src.HispanicLatinoEthnicity
						, trgt.RecordEndDateTime = src.RecordEndDateTime
			WHEN NOT MATCHED BY TARGET THEN     --- Records Exists IN Source but NOT IN Target
			INSERT (
					PersonId
					, FirstName
					, LastName
					, MiddleName
					, BirthDate
					, RefSexId
					, HispanicLatinoEthnicity
					, RecordStartDateTime
					, RecordEndDateTime
					)
			VALUES (
					src.PersonId
					, src.FirstName
					, src.LastName
					, src.MiddleName
					, src.Birthdate
					, src.RefSexId
					, src.HispanicLatinoEthnicity
					, src.RecordStartDateTime
					, src.RecordEndDateTime
					);

		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonDetail', NULL, 'S03EC150' 
		END CATCH
 
		--End date the records that were inserted above
		BEGIN TRY
			;WITH upd AS
			(
				SELECT pd.PersonDetailId, pi.Identifier, pd.recordstartdatetime,   
					LEAD (pd.Recordstartdatetime, 1, 0) OVER (PARTITION BY pi.Identifier ORDER BY pd.recordstartdatetime ASC) AS endDate
				FROM ods.PersonDetail pd
					INNER JOIN ods.PersonIdentifier pi
						ON pd.personid = pi.personid
				WHERE RecordEndDateTime is null
			)
			UPDATE pd
			SET RecordEndDateTime = upd.endDate -1
			FROM ods.PersonDetail pd
				INNER JOIN upd	
					ON pd.PersonDetailId = upd.PersonDetailId
			WHERE upd.endDate <> '1900-01-01 00:00:00.000'

		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonDetail', NULL, 'S03EC160' 
		END CATCH
 
		--Personnel
		SET @PersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001074' /* Staff Member Identification System */)
		BEGIN TRY

			;WITH CTE AS 
			( 
				SELECT DISTINCT 
                    sp.PersonId
                    , sp.FirstName
                    , sp.MiddleName
                    , sp.LastName
                    , sp.BirthDate
					, rs.RefSexId
                    , sp.HispanicLatinoEthnicity
					, sp.RecordStartDateTime
					, sp.RecordEndDateTime
				FROM staging.Person sp
					INNER JOIN ODS.SourceSystemReferenceData ref
						ON sp.Sex = ref.InputCode
						AND ref.TableName = 'RefSex'
						AND ref.SchoolYear = @SchoolYear
					INNER JOIN ODS.RefSex rs
						ON ref.OutputCode = rs.Code
					INNER JOIN ods.PersonIdentifier pi
						ON sp.Identifier = pi.Identifier
						AND pi.RefPersonIdentificationSystemId = @PersonIdentificationSystemId
						AND pi.RefPersonalInformationVerificationId = @PersonalInformationVerificationId
				WHERE ISNULL(sp.RecordStartDateTime,'') <> ''
				AND (sp.RecordEndDateTime is null 
				OR sp.RecordEndDateTime > sp.RecordStartDateTime)
			)
			MERGE ODS.PersonDetail AS trgt
			USING CTE AS src
					ON  trgt.PersonId = src.PersonId
					AND trgt.RecordStartDateTime = src.RecordStartDateTime
			WHEN MATCHED AND (
					ISNULL(trgt.FirstName, '') <> ISNULL(src.FirstName, '')
					OR ISNULL(trgt.MiddleName, '') <> ISNULL(src.MiddleName, '')
					OR ISNULL(trgt.LastName, '') <> ISNULL(src.LastName, '')
					OR ISNULL(trgt.Birthdate, '1/1/1900') <> ISNULL(src.Birthdate, '1/1/1900')
					OR ISNULL(trgt.RefSexId, '') <> ISNULL(src.RefSexId, '')
					OR ISNULL(trgt.HispanicLatinoEthnicity, '') <> ISNULL(src.HispanicLatinoEthnicity, '')
					OR ISNULL(trgt.RecordEndDateTime, '1/1/1900') <> ISNULL(src.RecordEndDateTime, '1/1/1900')
					)
				THEN 
					UPDATE SET 
						trgt.Birthdate = src.Birthdate
						, trgt.FirstName = src.FirstName
						, trgt.MiddleName = src.MiddleName
						, trgt.LastName = src.LastName
						, trgt.RefSexId = src.RefSexId
						, trgt.HispanicLatinoEthnicity = src.HispanicLatinoEthnicity
						, trgt.RecordEndDateTime = src.RecordEndDateTime
			WHEN NOT MATCHED BY TARGET THEN     --- Records Exists IN Source but NOT IN Target
			INSERT (
					PersonId
					, FirstName
					, LastName
					, MiddleName
					, BirthDate
					, RefSexId
					, HispanicLatinoEthnicity
					, RecordStartDateTime
					, RecordEndDateTime
					)
			VALUES (
					src.PersonId
					, src.FirstName
					, src.LastName
					, src.MiddleName
					, src.Birthdate
					, src.RefSexId
					, src.HispanicLatinoEthnicity
					, src.RecordStartDateTime
					, src.RecordEndDateTime
					);

		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonDetail', NULL, 'S03EC170' 
		END CATCH
 
		BEGIN TRY 

			--End date the records that were inserted above
			;WITH upd AS
			(
				SELECT pd.PersonDetailId, pi.Identifier, pd.recordstartdatetime,   
					LEAD (pd.Recordstartdatetime, 1, 0) OVER (PARTITION BY pi.Identifier ORDER BY pd.recordstartdatetime ASC) AS endDate
				FROM ods.PersonDetail pd
					INNER JOIN ods.PersonIdentifier pi
						ON pd.personid = pi.personid
				WHERE RecordEndDateTime is null
			)
			UPDATE pd
			SET RecordEndDateTime = upd.endDate -1
			FROM ods.PersonDetail pd
				INNER JOIN upd	
					ON pd.PersonDetailId = upd.PersonDetailId
			WHERE upd.endDate <> '1900-01-01 00:00:00.000'

		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.PersonDetail', NULL, 'S03EC180' 
		END CATCH
 
    END;