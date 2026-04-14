CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_OrganizationCalendarSession]
	@SchoolYear SMALLINT = NULL
AS
    /*************************************************************************************************************
    Date Created:  12/4/2019

    Purpose:
        The purpose of this ETL IS to track sessions for any type of organization so that session-based data IS
		can be properly bound to the session.

    Assumptions:
        

    Account executed under: LOGIN

    Approximate run time:  ~ 5 seconds

    Data Sources:  

    Data Targets:  Generate Database:   dbo.OrganizationCalendar
										dbo.OrganizationCalendarSession

    Return VALUES:
    	 0	= Success
       All Errors are Thrown via Try/Catch Block	
  
    Example Usage: 
      EXEC Staging.[Migrate_StagingToIDS_OrganizationCalendarSession] 2018;
    
    Modification Log:
      #	  Date		    Developer	  Issue#	 Description
      --  ----------  ----------  -------  --------------------------------------------------------------------
      01		  	 
    *************************************************************************************************************/
BEGIN


    SET NOCOUNT ON;
		
	--IF @SchoolYear IS NULL BEGIN
	--	SELECT @SchoolYear = d.Year + 1
	--	FROM rds.DimDateDataMigrationTypes dd 
	--	JOIN rds.DimDates d 
	--		ON dd.DimDateId = d.DimDateId 
	--	JOIN rds.DimDataMigrationTypes b 
	--		ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
	--	WHERE dd.IsSelected = 1 
	--		AND DataMigrationTypeCode = 'ODS'
	--END 

    ---------------------------------------------------
    --- Declare Error Handling Variables           ----
    ---------------------------------------------------
	DECLARE @eStoredProc			VARCHAR(100) = 'Migrate_StagingToIDS_OrganizationCalendarSession'


	---------------------------------------------------
	--- Get organization ID							---
	---------------------------------------------------
		
	BEGIN TRY

		UPDATE Staging.OrganizationCalendarSession
		SET OrganizationId = oi.OrganizationId
		FROM Staging.OrganizationCalendarSession s
		JOIN dbo.OrganizationIdentifier oi
			ON s.OrganizationIdentifier = oi.Identifier
			AND ISNULL(s.DataCollectionId, '') = ISNULL(oi.DataCollectionId, '')
		JOIN dbo.OrganizationDetail od
			ON oi.OrganizationId = od.OrganizationId
			AND ISNULL(od.DataCollectionId, '') = ISNULL(s.DataCollectionId, '')
		JOIN Staging.SourceSystemReferenceData ssrd
			ON s.OrganizationType = ssrd.InputCode
			AND ssrd.SchoolYear = s.CalendarYear
			AND ssrd.TableName = 'RefOrganizationType'
			AND ssrd.TableFilter = '001156'
		JOIN dbo.RefOrganizationType ot
			ON ot.Code = ssrd.OutputCode
		JOIN dbo.RefOrganizationElementType oet
			ON ot.RefOrganizationElementTypeId = oet.RefOrganizationElementTypeId
			AND oet.Code = '001156'
			AND (	
					(ot.Code = 'LEA'
					AND oi.RefOrganizationIdentificationSystemId = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001072')
					AND oi.RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('001072'))
				OR	(ot.Code = 'K12School'
					AND oi.RefOrganizationIdentificationSystemId = [Staging].[GetOrganizationIdentifierSystemId]('SEA', '001073')
					AND oi.RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('001073'))
				OR	(ot.Code = 'PostsecondaryInstitution'
					AND oi.RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('000166')) -- IPEDS Unit ID
				OR	(ot.Code = 'SEA'
					AND oi.RefOrganizationIdentificationSystemId = [Staging].[GetOrganizationIdentifierSystemId]('Federal', '001491')
					AND oi.RefOrganizationIdentifierTypeId = [Staging].[GetOrganizationIdentifierTypeId]('001491'))

				)
	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationCalendarSession', 'OrganizationId', 'S03EC0100'
	END CATCH


	-----------------------------------------------------------------------
	--- Get organization Calendar IDs IF they already exist				---
	-----------------------------------------------------------------------
		
	BEGIN TRY

		UPDATE Staging.OrganizationCalendarSession
		SET OrganizationCalendarId = oc.OrganizationCalendarId
		FROM Staging.OrganizationCalendarSession s
		JOIN dbo.OrganizationCalendar oc
			ON s.OrganizationId = oc.OrganizationId
			AND ISNULL(s.DataCollectionId, '') = ISNULL(oc.DataCollectionId, '')
			AND s.CalendarYear = oc.CalendarYear -- School Year (e.g. 2019 for 2018-19 school year)

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationCalendarSession', 'OrganizationCalendarId', 'S03EC0100'
	END CATCH


	-----------------------------------------------------------------------
	--- Get organization Calendar Session IDs IF they already exist		---
	-----------------------------------------------------------------------
		
	BEGIN TRY

		UPDATE Staging.OrganizationCalendarSession
		SET OrganizationCalendarSessionId = ocs.OrganizationCalendarSessionId
		FROM Staging.OrganizationCalendarSession s
		JOIN dbo.OrganizationCalendar oc
			ON s.OrganizationId = oc.OrganizationId
			AND ISNULL(s.DataCollectionId, '') = ISNULL(oc.DataCollectionId, '')
			AND s.CalendarYear = oc.CalendarYear -- School Year (e.g. 2019 for 2018-19 school year)
		JOIN dbo.OrganizationCalendarSession ocs
			ON oc.OrganizationCalendarId = ocs.OrganizationCalendarId
			AND ISNULL(s.DataCollectionId, '') = ISNULL(ocs.DataCollectionId, '')
			AND ocs.BeginDate = s.BeginDate
			AND ocs.EndDate = s.EndDate
		JOIN Staging.SourceSystemReferenceData ssrd
			ON s.SessionType = ssrd.InputCode
			AND ssrd.TableName = 'RefSessionType'
			AND ssrd.SchoolYear = s.CalendarYear
		JOIN dbo.RefSessionType st
			ON st.Code = ssrd.OutputCode

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationCalendarSession', 'OrganizationCalendarSessionId', 'S03EC0100'
	END CATCH




	-----------------------------------------------------------------------
	--- Get organization Calendar Session IDs IF they already exist		---
	-----------------------------------------------------------------------
		
	BEGIN TRY

		UPDATE Staging.OrganizationCalendarSession
		SET OrganizationCalendarSessionId = ocs.OrganizationCalendarSessionId
		FROM Staging.OrganizationCalendarSession s
		JOIN dbo.OrganizationCalendar oc
			ON s.OrganizationId = oc.OrganizationId
			AND ISNULL(s.DataCollectionId, '') = ISNULL(oc.DataCollectionId, '')
			AND s.CalendarYear = oc.CalendarYear -- School Year (e.g. 2019 for 2018-19 school year)
		JOIN dbo.OrganizationCalendarSession ocs
			ON oc.OrganizationCalendarId = ocs.OrganizationCalendarId
			AND ISNULL(s.DataCollectionId, '') = ISNULL(ocs.DataCollectionId, '')
			AND ocs.BeginDate = s.BeginDate
			AND ocs.EndDate = s.EndDate
		LEFT JOIN Staging.SourceSystemReferenceData ssrd
			ON s.SessionType = ssrd.InputCode
			AND ssrd.TableName = 'RefSessionType'
			AND ssrd.SchoolYear = s.CalendarYear
		LEFT JOIN dbo.RefSessionType st
			ON st.Code = ssrd.OutputCode
		LEFT JOIN Staging.SourceSystemReferenceData ssrd2
			ON s.AcademicTermDesignator = ssrd2.InputCode
			AND ssrd2.SchoolYear = s.CalendarYear
			AND ssrd2.TableName = 'RefAcademicTermDesignator'
		LEFT JOIN dbo.RefAcademicTermDesignator atd
			ON atd.Code = ssrd2.OutputCode


	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.OrganizationCalendarSession', 'OrganizationCalendarSessionId', 'S03EC0100'
	END CATCH



	-----------------------------------------------------------
	--- Create new organization calendars					---
	-----------------------------------------------------------
		
	BEGIN TRY

		INSERT INTO dbo.OrganizationCalendar
			(
			  OrganizationId
			, CalendarCode
			, CalendarDescription
			, CalendarYear
			, DataCollectionId
			)
		SELECT distinct
			  OrganizationId
			, CalendarYear
			, CalendarYear + ' ' + st.Description
			, CalendarYear
			, s.DataCollectionId
		FROM Staging.OrganizationCalendarSession s
		JOIN Staging.SourceSystemReferenceData ssrd
			ON s.SessionType = ssrd.InputCode
			AND ssrd.TableName = 'RefSessionType'
			AND ssrd.SchoolYear = s.CalendarYear
		JOIN dbo.RefSessionType st
			ON st.Code = ssrd.OutputCode
		where s.OrganizationId is not null

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationCalendar', NULL, 'S03EC0100'
	END CATCH



	-----------------------------------------------------------
	--- UPDATE OrganizationCalendarId for new records		---
	-----------------------------------------------------------
		
	BEGIN TRY

		UPDATE Staging.OrganizationCalendarSession
		SET OrganizationCalendarId = oc.OrganizationCalendarId
		FROM Staging.OrganizationCalendarSession s
		JOIN dbo.OrganizationCalendar oc
			ON s.OrganizationId = oc.OrganizationId
			AND ISNULL(s.DataCollectionId, '') = ISNULL(oc.DataCollectionId, '')
			AND oc.CalendarYear = s.CalendarYear

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationCalendar', NULL, 'S03EC0100'
	END CATCH


	-----------------------------------------------------------
	--- Create new organization calendars sessions			---
	-----------------------------------------------------------
		
	BEGIN TRY

		INSERT INTO dbo.OrganizationCalendarSession
			(
			  OrganizationCalendarId
			, BeginDate
			, EndDate
			, RefSessionTypeId
			, DataCollectionId
			)
		SELECT DISTINCT
			  s.OrganizationCalendarId
			, s.BeginDate
			, s.EndDate
			, st.RefSessionTypeId 
			, s.DataCollectionId
		FROM Staging.OrganizationCalendarSession s
		JOIN dbo.OrganizationCalendar oc
			ON s.OrganizationId = oc.OrganizationId
			AND ISNULL(s.DataCollectionId, '') = ISNULL(oc.DataCollectionId, '')
			AND oc.CalendarYear = s.CalendarYear
		LEFT JOIN Staging.SourceSystemReferenceData ssrd
			ON s.SessionType = ssrd.InputCode
			AND ssrd.TableName = 'RefSessionType'
			AND ssrd.SchoolYear = s.CalendarYear
		LEFT JOIN dbo.RefSessionType st
			ON st.Code = ssrd.OutputCode
		LEFT JOIN Staging.SourceSystemReferenceData ssrd2
			ON s.AcademicTermDesignator = ssrd2.InputCode
			AND ssrd2.TableName = 'RefAcademicTermDesignator'
			AND ssrd2.SchoolYear = s.CalendarYear
		LEFT JOIN dbo.RefAcademicTermDesignator atd
			ON atd.Code = ssrd2.OutputCode

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationCalendar', NULL, 'S03EC0100'
	END CATCH


	-------------------------------------------------------------------
	--- UPDATE OrganizationCalendarSession Id for new records		---
	-------------------------------------------------------------------
		
	BEGIN TRY

		UPDATE Staging.OrganizationCalendarSession
		SET OrganizationCalendarSessionId = ocs.OrganizationCalendarSessionId
		FROM Staging.OrganizationCalendarSession s
		JOIN dbo.OrganizationCalendar oc
			ON s.OrganizationId = s.OrganizationId
			AND ISNULL(s.DataCollectionId, '') = ISNULL(oc.DataCollectionId, '')
			AND oc.CalendarYear = s.CalendarYear
		LEFT JOIN Staging.SourceSystemReferenceData ssrd
			ON s.SessionType = ssrd.InputCode
			AND ssrd.TableName = 'RefSessionType'
			AND ssrd.SchoolYear = @SchoolYear
		LEFT JOIN dbo.RefSessionType st
			ON st.Code = ssrd.OutputCode
		LEFT JOIN Staging.SourceSystemReferenceData ssrd2
			ON s.AcademicTermDesignator = ssrd2.InputCode
			AND ssrd2.SchoolYear = s.CalendarYear
			AND ssrd2.TableName = 'RefAcademicTermDesignator'
		LEFT JOIN dbo.RefAcademicTermDesignator atd
			ON atd.Code = ssrd2.OutputCode
		JOIN dbo.OrganizationCalendarSession ocs
			ON oc.OrganizationCalendarId = ocs.OrganizationCalendarId
			AND ISNULL(s.DataCollectionId, '') = ISNULL(ocs.DataCollectionId, '')
			AND ocs.BeginDate = s.BeginDate
			AND ocs.EndDate = s.EndDate
			AND ocs.RefSessionTypeId = st.RefSessionTypeId

	END TRY

	BEGIN CATCH
		EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationCalendar', NULL, 'S03EC0100'
	END CATCH

END