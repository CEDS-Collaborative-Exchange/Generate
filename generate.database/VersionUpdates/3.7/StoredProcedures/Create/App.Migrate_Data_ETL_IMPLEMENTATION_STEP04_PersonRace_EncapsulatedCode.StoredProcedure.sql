---It would be good to just go ahead and include Staff in this process as well to maintain unique staff ID's
---Inform the process for when/if ID's change - how will that be addressed, perhaps not now, but in the future.
-------will the use of PersonMaster come into play?
-------Note: id's can change so long as the end result - report outcome would be the same?
CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP04_PersonRace_EncapsulatedCode]
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

    Data Targets:  Generate Database:   Generate.ODS.PersonDemographicRace

    Return Values:
    	 0	= Success
       All Errors are Thrown via Try/Catch Block	
  
    Example Usage: 
      EXEC App.[Migrate_Data_ETL_IMPLEMENTATION_STEP04_PersonRace];
    
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
		DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP04_PersonRace_EncapsulatedCode'

        ---------------------------------------------------
        --- Declare Temporary Variables                ----
        ---------------------------------------------------
		DECLARE @PersonIdentificationSystemId INT
		DECLARE @PersonalInformationVerificationId INT

		SET @PersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075')
		SET @PersonalInformationVerificationId = App.GetRefPersonalInformationVerificationId('01011')

		------------------------------------------------------------
        --- Insert PersonDemographicRace Records                 ---
        ------------------------------------------------------------
        /*
		  Grab the existing PersonDemographicRaceId for people that already exist
		*/ 
		BEGIN TRY
			UPDATE Staging.PersonRace
			SET PersonDemographicRaceId = pdr.PersonDemographicRaceId
			FROM Staging.PersonRace mr 
			JOIN ODS.PersonIdentifier pid 
				ON pid.Identifier = mr.Student_Identifier_State
				AND pid.RefPersonIdentificationSystemId = @PersonIdentificationSystemId
				AND pid.RefPersonalInformationVerificationId = @PersonalInformationVerificationId
			JOIN ODS.OrganizationPersonRole opr
				ON pid.PersonId = opr.PersonId
			JOIN ODS.OrganizationIdentifier oi
				ON opr.OrganizationId = oi.OrganizationId
				AND oi.Identifier IN (mr.Lea_Identifier_State, mr.School_Identifier_State)
			JOIN ODS.PersonDemographicRace pdr 
				ON pid.PersonID = pdr.PersonId
			JOIN ODS.SourceSystemReferenceData rd
				ON mr.RaceType = rd.InputCode
				AND rd.TableName = 'RefRace'
				AND rd.SchoolYear = @SchoolYear
			JOIN ODS.RefRace r 
				ON rd.OutputCode = r.Code
			WHERE pid.PersonID IS NOT NULL
				AND	r.RefRaceId = pdr.RefRaceId
				AND pdr.RecordStartDateTime = mr.RecordStartDateTime
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonRace', 'PersonDemographicRaceId', 'S04EC100' 
		END CATCH

        ------------------------------------------------------------
        --- Merge Person Race							        ----
        ------------------------------------------------------------
		BEGIN TRY

			;WITH CTE AS 
			( 
				SELECT DISTINCT 
                    spr.PersonDemographicRaceId
					, pi.PersonId
					, rr.RefRaceId
					, spr.RecordStartDateTime
					, spr.RecordEndDateTime
				FROM staging.PersonRace spr
					INNER JOIN ODS.SourceSystemReferenceData ref
						ON spr.RaceType = ref.InputCode
						AND ref.TableName = 'RefRace'
						AND ref.SchoolYear = @SchoolYear
					INNER JOIN ODS.RefRace rr
						ON ref.OutputCode = rr.Code
					INNER JOIN ods.PersonIdentifier pi
						ON spr.Student_Identifier_State = pi.Identifier
						AND pi.RefPersonIdentificationSystemId = @PersonIdentificationSystemId
						AND pi.RefPersonalInformationVerificationId = @PersonalInformationVerificationId
					JOIN ODS.OrganizationPersonRole opr
						ON pi.PersonId = opr.PersonId
					JOIN ODS.OrganizationIdentifier oi
						ON opr.OrganizationId = oi.OrganizationId
						AND oi.Identifier IN (spr.Lea_Identifier_State, spr.School_Identifier_State)
				WHERE ISNULL(spr.RecordStartDateTime,'') <> ''
				AND (spr.RecordEndDateTime is null OR spr.RecordEndDateTime > spr.RecordStartDateTime)
			)
			MERGE ODS.PersonDemographicRace with (HOLDLOCK) AS trgt
			USING CTE AS src
				ON trgt.PersonId = src.PersonId
				AND trgt.RecordStartDateTime = src.RecordStartDateTime
			WHEN MATCHED AND (
				ISNULL(trgt.RefRaceId, '') <> ISNULL(src.RefRaceId, '')
				OR ISNULL(trgt.RecordEndDateTime, '1/1/1900') <> ISNULL(src.RecordEndDateTime, '1/1/1900')
				)
			THEN 
				UPDATE SET 
					trgt.RefRaceId = src.RefRaceId
					, trgt.RecordEndDateTime = src.RecordEndDateTime
			WHEN NOT MATCHED BY TARGET THEN     --- Records Exists IN Source but NOT IN Target
			INSERT (
					PersonId
					, RefRaceId
					, RecordStartDateTime
					, RecordEndDateTime
					)
			VALUES (
					src.PersonId
					, src.RefRaceId
					, src.RecordStartDateTime
					, src.RecordEndDateTime
					);

		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonRace', 'PersonDemographicRaceId', 'S04EC110' 
		END CATCH
 
		BEGIN TRY

			;WITH upd AS
			(
				SELECT pdr.PersonDemographicRaceId, pdr.PersonId, pdr.recordstartdatetime,   
					LEAD (pdr.Recordstartdatetime, 1, 0) OVER (PARTITION BY pdr.PersonId ORDER BY pdr.recordstartdatetime ASC) AS endDate
				FROM ods.PersonDemographicRace pdr
				WHERE RecordEndDateTime is null
			)
			UPDATE pdr
			SET RecordEndDateTime = upd.endDate -1
			FROM ods.PersonDemographicRace pdr
				INNER JOIN upd	
					ON pdr.PersonDemographicRaceId = upd.PersonDemographicRaceId
			WHERE upd.endDate <> '1900-01-01 00:00:00.000'

		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonRace', 'PersonDemographicRaceId', 'S04EC120' 
		END CATCH

 		--------------------------------------------------------------------------------
		---Write the new PersonDemographicRaceId values back to the staging table	----
		--------------------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.PersonRace
			SET PersonDemographicRaceId = pdr.PersonDemographicRaceId
			FROM Staging.PersonRace mr 
			JOIN ODS.PersonIdentifier pid 
				ON pid.Identifier = mr.Student_Identifier_State
				AND pid.RefPersonIdentificationSystemId = @PersonIdentificationSystemId
				AND pid.RefPersonalInformationVerificationId = @PersonalInformationVerificationId
			JOIN ODS.OrganizationPersonRole opr
				ON pid.PersonId = opr.PersonId
			JOIN ODS.OrganizationIdentifier oi
				ON opr.OrganizationId = oi.OrganizationId
				AND oi.Identifier IN (mr.Lea_Identifier_State, mr.School_Identifier_State)
			JOIN ODS.PersonDemographicRace pdr 
				ON pid.PersonID = pdr.PersonId
			JOIN ODS.SourceSystemReferenceData rd
				ON mr.RaceType = rd.InputCode
				AND rd.TableName = 'RefRace'
				AND rd.SchoolYear = @SchoolYear
			JOIN ODS.RefRace r 
				ON rd.OutputCode = r.Code
			WHERE pid.PersonID IS NOT NULL
				AND	r.RefRaceId = pdr.RefRaceId
				AND pdr.RecordStartDateTime = mr.RecordStartDateTime
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonRace', 'PersonDemographicRaceId', 'S04EC130' 
		END CATCH

    END;