CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_PersonRace]
	AS
    /*************************************************************************************************************
    Date Created:  2/12/2018

    Purpose:
        The purpose of this ETL is to maintain the unique list of Student & Staff Identifiers assigned by the state
		in the dbo.

    Assumptions:

    Account executed under: LOGIN

    Approximate run time:  ~ 5 seconds

    Data Sources:  

    Data Targets:  Generate Database:   Generate.dbo.PersonDemographicRace

    Return Values:
    	 0	= Success
       All Errors are Thrown via Try/Catch Block	
  
    Example Usage: 
      EXEC App.[Migrate_StagingToIDS_PersonRace];
    
    Modification Log:
      #	  Date		    Developer	  Issue#	 Description
      --  ----------  ----------  -------  --------------------------------------------------------------------
      01		  	 
    *************************************************************************************************************/
    BEGIN

        SET NOCOUNT ON;
		
		
        ---------------------------------------------------
        --- Declare Error Handling Variables           ----
        ---------------------------------------------------
		DECLARE @eStoredProc varchar(100) = 'Migrate_StagingToIDS_PersonRace'

        ---------------------------------------------------
        --- Declare Temporary Variables                ----
        ---------------------------------------------------
        DECLARE @RecordStartDate DATETIME, @RefPersonIdentificationSystemId INT, @RefPersonalInformationVerificationId INT
		
		SET @RefPersonIdentificationSystemId=Staging.GetRefPersonIdentificationSystemId('State', '001075')
		SET @RefPersonalInformationVerificationId=Staging.GetRefPersonalInformationVerificationId('01011')
	
		DECLARE @LeaOrganizationIdentificationSystemId INT = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001072')
		DECLARE @LeaOrganizationIdentificationTypeId INT = [Staging].[GetOrganizationIdentifierTypeId]('001072')
		DECLARE @K12OrganizationIdentificationSystemId INT = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001073')
		DECLARE @K12OrganizationIdentificationTypeId INT = [Staging].[GetOrganizationIdentifierTypeId]('001073')
		DECLARE @IeuOrganizationIdentificationSystemId INT = [Staging].[GetOrganizationIdentifierSystemId]('IEU', '001156')
		DECLARE @IeuOrganizationIdentificationTypeId INT = [Staging].[GetOrganizationIdentifierTypeId]('001156')
		DECLARE @PscOrganizationIdentificationTypeId INT = [Staging].[GetOrganizationIdentifierTypeId]('000166')

		 --SET the year to pull by using GETYEAR - a certain number so that it looks back IN time but no so far back
		 --that pulling the data gets too large.  This will keep it dynamic.  So DECLARE a variable AND use the date.

		
		-----------------------------------------------------
        --- Update DataCollectionId in Staging.PersonRace ---
        -----------------------------------------------------
		BEGIN TRY

			UPDATE e
			SET e.DataCollectionId = dc.DataCollectionId
			FROM Staging.PersonRace e
			JOIN dbo.DataCollection dc
				ON e.DataCollectionName = dc.DataCollectionName
			WHERE e.DataCollectionId IS NULL

		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonRace', 'DataCollectionId', 'S04EC010'
		END CATCH
		 ---------------------------------------------------
    --- Get the parent organizationId              ----
    ---------------------------------------------------

	BEGIN TRY
		UPDATE Staging.PersonRace
		SET OrganizationId = oi.OrganizationId
		FROM Staging.PersonRace pr
		INNER LOOP JOIN dbo.OrganizationIdentifier oi
			ON pr.OrganizationIdentifier = oi.Identifier
			AND ISNULL(pr.DataCollectionId, '') = ISNULL(oi.DataCollectionId, '')
		INNER LOOP JOIN dbo.OrganizationDetail od
			ON oi.OrganizationId = od.OrganizationId
		INNER LOOP JOIN Staging.SourceSystemReferenceData ssrd 
			ON pr.OrganizationType = ssrd.InputCode
			AND ssrd.TableName = 'RefOrganizationType'
			AND ssrd.TableFilter = '001156'
			AND pr.SchoolYear = ssrd.SchoolYear
		INNER LOOP JOIN dbo.RefOrganizationType ot
				ON ssrd.OutputCode = ot.Code
		WHERE od.RefOrganizationTypeId = ot.RefOrganizationTypeId
	END TRY

	BEGIN CATCH 
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationProgramType', 'OrganizationId', 'S02EC0100'
	END CATCH

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
			INNER JOIN dbo.PersonIdentifier pid 
				ON pid.Identifier = mr.Student_Identifier_State
				AND ISNULL(pid.DataCollectionId, '') = ISNULL(mr.DataCollectionId, '')
				AND pid.RefPersonIdentificationSystemId = @RefPersonIdentificationSystemId
				AND pid.RefPersonalInformationVerificationId = @RefPersonalInformationVerificationId
			INNER JOIN dbo.PersonDemographicRace pdr 
				ON pid.PersonID = pdr.PersonId
			INNER LOOP JOIN dbo.OrganizationPersonRole opr
				ON opr.OrganizationId = mr.OrganizationId
				AND ISNULL(opr.DataCollectionId, '') = ISNULL(mr.DataCollectionId, '')
				AND opr.PersonId = pdr.PersonId
			INNER LOOP JOIN [Staging].[SourceSystemReferenceData] rd
				ON mr.RaceType = rd.InputCode
				AND rd.TableName = 'RefRace'
				AND rd.SchoolYear = mr.SchoolYear
			INNER LOOP JOIN dbo.RefRace r 
				ON rd.OutputCode = r.Code
			LEFT LOOP JOIN dbo.PsStudentAcademicRecord psar
				ON opr.OrganizationPersonRoleId = psar.OrganizationPersonRoleId
			LEFT LOOP JOIN Staging.SourceSystemReferenceData psarm
				ON mr.AcademicTermDesignator = psarm.InputCode
				AND psarm.TableName = 'RefAcademicTermDesignator'
				AND mr.SchoolYear = psarm.SchoolYear
			LEFT LOOP JOIN dbo.RefAcademicTermDesignator atd
				ON psarm.OutputCode = atd.Code
			WHERE pid.PersonID IS NOT NULL
				AND	r.RefRaceId = pdr.RefRaceId
				AND pdr.RecordStartDateTime = mr.RecordStartDateTime
				AND (mr.AcademicTermDesignator IS NULL 
					OR atd.Code IS NOT NULL)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonRace', 'PersonDemographicRaceId', 'S04EC100' 
		END CATCH

        ------------------------------------------------------------
        --- Merge Person Race							        ----
        ------------------------------------------------------------
		BEGIN TRY

			;WITH CTE AS 
			( 
				SELECT DISTINCT 
                    mr.PersonDemographicRaceId
					, pid.PersonId
					, r.RefRaceId
					, mr.RecordStartDateTime
					, mr.RecordEndDateTime
					, mr.DataCollectionId
				FROM staging.PersonRace mr
			INNER LOOP JOIN dbo.PersonIdentifier pid 
				ON pid.Identifier = mr.Student_Identifier_State
				AND ISNULL(pid.DataCollectionId, '') = ISNULL(mr.DataCollectionId, '')
				AND pid.RefPersonIdentificationSystemId = @RefPersonIdentificationSystemId
				AND pid.RefPersonalInformationVerificationId = @RefPersonalInformationVerificationId
			INNER LOOP JOIN dbo.OrganizationPersonRole opr
				ON opr.OrganizationId = mr.OrganizationId
				AND ISNULL(opr.DataCollectionId, '') = ISNULL(mr.DataCollectionId, '')
				AND opr.PersonId = pid.PersonId
			LEFT LOOP JOIN dbo.PsStudentAcademicRecord psar
				ON opr.OrganizationPersonRoleId = psar.OrganizationPersonRoleId
			LEFT LOOP JOIN Staging.SourceSystemReferenceData psarm
				ON mr.AcademicTermDesignator = psarm.InputCode
				AND psarm.TableName = 'RefAcademicTermDesignator'
				AND mr.SchoolYear = psarm.SchoolYear
			LEFT LOOP JOIN dbo.RefAcademicTermDesignator atd
				ON psarm.OutputCode = atd.Code
			INNER LOOP JOIN [Staging].[SourceSystemReferenceData] rd
				ON mr.RaceType = rd.InputCode
				AND rd.TableName = 'RefRace'
				AND rd.SchoolYear = mr.SchoolYear
			INNER LOOP JOIN dbo.RefRace r 
				ON rd.OutputCode = r.Code
			WHERE mr.PersonDemographicRaceId IS NULL
				AND ISNULL(mr.RecordStartDateTime,'') <> ''
				AND (mr.RecordEndDateTime is null OR mr.RecordEndDateTime > mr.RecordStartDateTime)
			)
			MERGE dbo.PersonDemographicRace with (HOLDLOCK) AS trgt
			USING CTE AS src
				ON trgt.PersonId = src.PersonId
				AND trgt.RecordStartDateTime = src.RecordStartDateTime
				AND ISNULL(trgt.DataCollectionId, '') = ISNULL(src.DataCollectionId, '')
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
					, DataCollectionId
					)
			VALUES (
					src.PersonId
					, src.RefRaceId
					, src.RecordStartDateTime
					, src.RecordEndDateTime
					, src.DataCollectionId
					);

		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonRace', 'PersonDemographicRaceId', 'S04EC110' 
		END CATCH
 
		BEGIN TRY

			;WITH upd AS
			(
				SELECT pdr.PersonDemographicRaceId, pdr.PersonId, pdr.recordstartdatetime,   
					LEAD (pdr.Recordstartdatetime, 1, 0) OVER (PARTITION BY pdr.PersonId ORDER BY pdr.recordstartdatetime ASC) AS endDate
				FROM dbo.PersonDemographicRace pdr
				WHERE RecordEndDateTime is null
			)
			UPDATE pdr
			SET RecordEndDateTime = upd.endDate -1
			FROM dbo.PersonDemographicRace pdr
				INNER JOIN upd	
					ON pdr.PersonDemographicRaceId = upd.PersonDemographicRaceId
			WHERE upd.endDate <> '1900-01-01 00:00:00.000'

		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonRace', 'PersonDemographicRaceId', 'S04EC120' 
		END CATCH

 		--------------------------------------------------------------------------------
		---Write the new PersonDemographicRaceId values back to the staging table	----
		--------------------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.PersonRace
			SET PersonDemographicRaceId = pdr.PersonDemographicRaceId
			FROM Staging.PersonRace mr 
			JOIN dbo.PersonIdentifier pid 
				ON pid.Identifier = mr.Student_Identifier_State
				AND ISNULL(pid.DataCollectionId, '') = ISNULL(mr.DataCollectionId, '')
				AND pid.RefPersonIdentificationSystemId = @RefPersonIdentificationSystemId
				AND pid.RefPersonalInformationVerificationId = @RefPersonalInformationVerificationId
			INNER LOOP JOIN dbo.PersonDemographicRace pdr 
				ON pid.PersonID = pdr.PersonId
			INNER LOOP JOIN dbo.OrganizationPersonRole opr
				ON opr.OrganizationId = mr.OrganizationId
				AND ISNULL(opr.DataCollectionId, '') = ISNULL(mr.DataCollectionId, '')
				AND opr.PersonId = pdr.PersonId
			INNER LOOP JOIN [Staging].[SourceSystemReferenceData] rd
				ON mr.RaceType = rd.InputCode
				AND rd.TableName = 'RefRace'
				AND rd.SchoolYear = mr.SchoolYear
			INNER LOOP JOIN dbo.RefRace r 
				ON rd.OutputCode = r.Code
			LEFT LOOP JOIN dbo.PsStudentAcademicRecord psar
				ON opr.OrganizationPersonRoleId = psar.OrganizationPersonRoleId
			LEFT LOOP JOIN Staging.SourceSystemReferenceData psarm
				ON mr.AcademicTermDesignator = psarm.InputCode
				AND psarm.TableName = 'RefAcademicTermDesignator'
				AND mr.SchoolYear = psarm.SchoolYear
			LEFT LOOP JOIN dbo.RefAcademicTermDesignator atd
				ON psarm.OutputCode = atd.Code
			WHERE pid.PersonID IS NOT NULL
				AND	r.RefRaceId = pdr.RefRaceId
				AND pdr.RecordStartDateTime = mr.RecordStartDateTime
				AND (mr.AcademicTermDesignator IS NULL 
					OR atd.Code IS NOT NULL)
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.PersonRace', 'PersonDemographicRaceId', 'S04EC130' 
		END CATCH


    END;