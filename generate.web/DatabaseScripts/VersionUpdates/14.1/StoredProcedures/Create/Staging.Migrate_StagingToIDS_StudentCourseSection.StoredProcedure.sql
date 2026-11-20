CREATE PROCEDURE [Staging].[Migrate_StagingToIDS_StudentCourseSection]
	@SchoolYear SMALLINT = NULL
AS
  /*************************************************************************************************************
    Date Created:  2/12/2018

    Purpose:
        The purpose student's Course\Section data 

    Account executed under: LOGIN

    Approximate run time:  ~ 5 seconds

    Data Sources: 

    Data Targets:  Generate Database:   Generate

    Return VALUES:
         0    = Success
  
    Example Usage: 
      EXEC Staging.[Migrate_StagingToIDS_StudentCourseSection] 2019;
    
    Modification Log:
      #      Date          Issue#   Description
      --  ----------  -------  --------------------------------------------------------------------
      01               
    *************************************************************************************************************/
BEGIN
		set nocount on;

		--SELECT @SchoolYear = d.SchoolYear
			--FROM rds.DimSchoolYearDataMigrationTypes dd 
			--JOIN rds.DimSchoolYears d 
			--	ON dd.DimSchoolYearId = d.DimSchoolYearId 
			--JOIN rds.DimDataMigrationTypes b 
			--	ON b.DimDataMigrationTypeId = dd.DataMigrationTypeId 
			--WHERE dd.IsSelected = 1 
			--	AND DataMigrationTypeCode = 'ODS'

        ---------------------------------------------------
        --- Declare Error Handling Variables           ----
        ---------------------------------------------------
		DECLARE @eStoredProc VARCHAR(100) = 'Migrate_StagingToIDS_StudentCourseSection'
		DECLARE @RefPersonIdentificationSystemId INT = Staging.GetRefPersonIdentificationSystemId('State', '001075')
		DECLARE @RefPersonalInformationVerificationId INT = Staging.GetRefPersonalInformationVerificationId('01011')
		DECLARE @RefCourseOrgTypeId INT = Staging.GetOrganizationTypeId('Course', '001156')
		DECLARE @RefCourseSectionOrgTypeId INT = Staging.GetOrganizationTypeId('CourseSection', '001156')
		DECLARE @RefCourseOrgIdentifierId INT = Staging.GetOrganizationIdentifierTypeId('000056')
		DECLARE @RefCourseOrgSystemId INT = Staging.GetOrganizationIdentifierSystemId('SCED', '000056')

		-----------------------------------------------------
        --- Update DataCollectionId in Staging.PersonRace ---
        -----------------------------------------------------
		BEGIN TRY
			UPDATE e
			SET e.DataCollectionId = dc.DataCollectionId
			FROM Staging.K12StudentCourseSection e
			JOIN dbo.DataCollection dc
				ON e.DataCollectionName = dc.DataCollectionName
			WHERE e.DataCollectionId IS NULL
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12StudentCourseSection', 'DataCollectionId', 'S04EC001'
		END CATCH


		DECLARE @LEA_OrganizationId INT
		   ,@SCHOOL_OrganizationId INT
		   ,@LocationId INT
		   ,@SpecialEducationProgram_OrganizationId INT
		   ,@LEA_Identifier_State VARCHAR(100)
		   ,@LEA_Identifier_NCES VARCHAR(100)
		   ,@RecordStartDate DATETIME
		   ,@RecordEndDate DATETIME
		   ,@UpdateDateTime DATETIME
		   ,@ID INT

		SET @RecordStartDate = Staging.GetFiscalYearStartDate(@SchoolYear);
		
		SET @RecordEndDate = Staging.GetFiscalYearEndDate(@SchoolYear);

		SET @UpdateDateTime = GETDATE()

		-------------------------------------------------------
		---Associate the PersonId with the temporary table ----
		-------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.K12StudentCourseSection
			SET PersonId = pid.PersonId
			FROM Staging.K12StudentCourseSection sc
			JOIN dbo.PersonIdentifier pid 
				ON pid.Identifier = sc.Student_Identifier_State
				AND ISNULL(pid.DataCollectionId, '') = ISNULL(sc.DataCollectionId, '')
			WHERE pid.RefPersonIdentificationSystemId = @RefPersonIdentificationSystemId
				AND pid.RefPersonalInformationVerificationId = @RefPersonalInformationVerificationId
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12StudentCourseSection', 'PersonId', 'S14EC100' 
		END CATCH
		
		--------------------------------------------------------------------
		---Associate the LEA OrganizationId with the temporary table -------
		--------------------------------------------------------------------
		BEGIN TRY

			UPDATE Staging.K12StudentCourseSection
			SET OrganizationID_LEA = orgid.OrganizationId
			FROM Staging.K12StudentCourseSection e
			JOIN dbo.OrganizationIdentifier orgid 
				ON orgid.Identifier = e.LEA_Identifier_State
				AND ISNULL(orgid.DataCollectionId, '') = ISNULL(e.DataCollectionId, '')
			WHERE orgid.RefOrganizationIdentifierTypeId = Staging.GetOrganizationIdentifierTypeId('001072')
				AND orgid.RefOrganizationIdentificationSystemId = Staging.GetOrganizationIdentifierSystemId('SEA', '001072')

		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12StudentCourseSection', 'OrganizationID_LEA', 'S14EC110' 
		END CATCH

		--------------------------------------------------------------------
		---Associate the School OrganizationId with the temporary table ----
		--------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.K12StudentCourseSection
			SET OrganizationID_School = orgid.OrganizationId
			FROM Staging.K12StudentCourseSection e
			JOIN dbo.OrganizationIdentifier orgid 
				ON e.School_Identifier_State = orgid.Identifier
				AND ISNULL(orgid.DataCollectionId, '') = ISNULL(e.DataCollectionId, '')
			WHERE orgid.RefOrganizationIdentifierTypeId = Staging.GetOrganizationIdentifierTypeId('001073')
				AND orgid.RefOrganizationIdentificationSystemId = Staging.GetOrganizationIdentifierSystemId('SEA', '001073')
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12StudentCourseSection', 'OrganizationID_School', 'S14EC120' 
		END CATCH

		--------------------------------------------------------------------
		---Associate the Course OrganizationId with the temporary table ----
		--------------------------------------------------------------------
		BEGIN TRY
			-- One record per SCED code AND K12 school
			UPDATE Staging.K12StudentCourseSection
			SET OrganizationID_Course = orgid.OrganizationId
			FROM Staging.K12StudentCourseSection e
			JOIN dbo.OrganizationIdentifier orgid 
				ON e.ScedCourseCode = orgid.Identifier
				AND ISNULL(e.DataCollectionId, '') = ISNULL(orgid.DataCollectionId, '')
			JOIN dbo.OrganizationRelationship ore 
				ON orgid.OrganizationId = ore.OrganizationId 
				AND ISNULL(orgid.DataCollectionId, '') = ISNULL(ore.DataCollectionId, '')
				AND ore.Parent_OrganizationId = e.OrganizationID_School -- Parent org IS always going to be a school, find the proper course for that school.
			WHERE orgid.RefOrganizationIdentifierTypeId = @RefCourseOrgIdentifierId -- Course Identiifer
				AND orgid.RefOrganizationIdentificationSystemId = @RefCourseOrgSystemId -- SCED Course Code
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12StudentCourseSection', 'OrganizationID_Course', 'S14EC130' 
		END CATCH
		
		--INSERT Course INTO dbo.Organization--
		DECLARE @NewCourses TABLE (
			  OrganizationId INT
			, OrganizationID_School INT
			, ScedCourseCode VARCHAR(100)
			, CourseGradeLevel VARCHAR(100)
			, CourseLevelCharacteristic VARCHAR(100)
			, DataCollectionId INT
			, RecordStartDateTime DATETIME NULL
			, RecordEndDateTime DATETIME NULL
		)

		BEGIN TRY
			WITH DistinctCourses AS (
				SELECT DISTINCT
					  k.OrganizationID_School
					, k.ScedCourseCode
					, k.CourseGradeLevel
					, k.CourseLevelCharacteristic
					, k.DataCollectionId
					, k.EntryDate
					, k.ExitDate
				FROM Staging.K12StudentCourseSection k
				WHERE k.OrganizationID_Course IS NULL
			)
			MERGE dbo.Organization AS TARGET
			USING DistinctCourses AS SOURCE 
				ON 1 = 0 -- new courses are prefiltered out IN DistinctCourses CTE
				AND ISNULL(SOURCE.DataCollectionId, '') = ISNULL(TARGET.DataCollectionId, '')
			--When no records are matched, INSERT
			--the incoming records FROM source
			--table to target table
			WHEN NOT MATCHED BY TARGET THEN 
				INSERT (DataCollectionId) VALUES (Source.DataCollectionId) 
			OUTPUT 
				  INSERTED.OrganizationId
				, SOURCE.OrganizationID_School
				, SOURCE.ScedCourseCode
				, SOURCE.CourseGradeLevel
				, SOURCE.CourseLevelCharacteristic
				, SOURCE.DataCollectionId
				, SOURCE.EntryDate
				, SOURCE.ExitDate
			INTO @NewCourses;
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Organization', NULL, 'S14EC0140'
		END CATCH


		BEGIN TRY
			-- UPDATE organization IDs IN the staging table
			UPDATE Staging.K12StudentCourseSection 
			SET OrganizationID_Course = norg.OrganizationId
			FROM Staging.K12StudentCourseSection o
			JOIN @NewCourses norg
				ON o.OrganizationID_School = norg.OrganizationID_School
				AND o.ScedCourseCode = norg.ScedCourseCode
				AND isnull(o.CourseGradeLevel,'') = isnull(norg.CourseGradeLevel,'')
				AND o.CourseLevelCharacteristic = norg.CourseLevelCharacteristic
				AND ISNULL(o.DataCollectionId, '') = ISNULL(norg.DataCollectionId, '')
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12StudentCourseSection', 'OrganizationID_Course', 'S14EC0150'
		END CATCH

		-- Delete the next statement IF it's determined it IS unnecessary.  I don't believe IS IS needed -- courses live forever for historical purposes.  If there IS a new course code, it IS considered a new course organization.  

		--BEGIN TRY
		--	--UPDATE Course names by END dating the 
		--	--current OrganizationDetail record AND creating a new one
		--	UPDATE dbo.OrganizationDetail
		--	SET RecordEndDateTime = @UpdateDateTime
		--	FROM Staging.K12StudentCourseSection o
		--	JOIN dbo.OrganizationDetail od
		--		ON o.OrganizationID_Course = od.OrganizationId
		--		AND o.ScedCourseCode <> od.[Name]
		--		AND od.RecordEndDateTime IS NULL
		--END TRY

		--BEGIN CATCH
		--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', 'RecordEndDateTime', 'S14EC0160'
		--END CATCH

		-----------------------------------------------------------
		---Create new course organization records            ------
		-----------------------------------------------------------

		BEGIN TRY
			INSERT INTO dbo.OrganizationDetail (
				  OrganizationId
				, Name
				, DataCollectionId
				, RefOrganizationTypeId
				, RecordStartDateTime
				, RecordEndDateTIme
				)
			SELECT 
				  o.OrganizationID_Course
				, o.ScedCourseCode
				, o.DataCollectionId
				, @RefCourseOrgTypeId
				, nc.RecordStartDateTime
				, nc.RecordEndDateTime
			FROM Staging.K12StudentCourseSection o
			JOIN @NewCourses nc
				ON o.OrganizationID_Course = nc.OrganizationId
				AND ISNULL(o.DataCollectionId, '') = ISNULL(nc.DataCollectionId, '')
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S14EC0170'
		END CATCH


		-----------------------------------------------------------
		---Create new course organization identifier records ------
		-----------------------------------------------------------

		BEGIN TRY
			INSERT INTO dbo.OrganizationIdentifier
			SELECT 
				  o.ScedCourseCode
				, @RefCourseOrgSystemId -- SCED Course Code						
				, o.OrganizationID_Course
				, @RefCourseOrgIdentifierId -- Course Identiifer
				, nc.RecordStartDateTime
				, nc.RecordEndDateTime
				, o.DataCollectionId
			FROM Staging.K12StudentCourseSection o
			JOIN @NewCourses nc
				ON o.OrganizationID_Course = nc.OrganizationId
				AND ISNULL(o.DataCollectionId, '') = ISNULL(nc.DataCollectionId, '')
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationIdentifier', NULL, 'S14EC0170'
		END CATCH
		
		-----------------------------------------------------------
		---Create Relationship b/w k12Schools and Courses    ------
		-----------------------------------------------------------

		BEGIN TRY		
		INSERT INTO [dbo].[OrganizationRelationship]
			([Parent_OrganizationId]
			,[OrganizationId]
			,[RefOrganizationRelationshipId]
			,[DataCollectionId])
		SELECT DISTINCT
			 opt.OrganizationID_School [Parent_OrganizationId]
			,opt.OrganizationID_Course [OrganizationId]
			,NULL [RefOrganizationRelationshipId]
			,opt.DataCollectionId
		FROM Staging.K12StudentCourseSection opt
		LEFT JOIN dbo.OrganizationRelationship ore
			ON opt.OrganizationID_Course = ore.OrganizationId
			AND opt.OrganizationID_School = ore.Parent_OrganizationId
		WHERE ore.Parent_OrganizationId IS NULL
			AND opt.OrganizationID_Course IS NOT NULL
			AND opt.OrganizationID_School IS NOT NULL
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationRelationship', NULL, 'S14EC0170'
		END CATCH

		------------------------------------------------------------------------------
		---Get organization IDs for existing course sections using Org Relationsip ---
		------------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.K12StudentCourseSection
			SET OrganizationID_CourseSection = od.OrganizationId
			FROM Staging.K12StudentCourseSection kcs
			JOIN dbo.OrganizationRelationship ore
				ON ore.Parent_OrganizationId = kcs.OrganizationID_School
				AND ISNULL(ore.DataCollectionId, '') = ISNULL(kcs.DataCollectionId, '')
			JOIN dbo.OrganizationIdentifier oi
				ON ore.OrganizationId = oi.OrganizationId
				AND ISNULL(ore.DataCollectionId, '') = ISNULL(oi.DataCollectionId, '')
			JOIN dbo.OrganizationDetail od
				ON oi.OrganizationId = od.OrganizationId	
				AND ISNULL(oi.DataCollectionId, '') = ISNULL(od.DataCollectionId, '')
				AND od.RefOrganizationTypeId = @RefCourseSectionOrgTypeId
			WHERE oi.RefOrganizationIdentifierTypeId = @RefCourseOrgIdentifierId -- Course Identiifer
				AND oi.RefOrganizationIdentificationSystemId = @RefCourseOrgSystemId -- SCED Course Code
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S14EC0175'
		END CATCH

		------------------------------------------------------------------------------------------------
		---Create new organization records for course sections, child organizations of the course ------
		------------------------------------------------------------------------------------------------

		DECLARE @NewCourseSections TABLE (
			  OrganizationId INT
			, ScedCourseCode VARCHAR(100)
			, OrganizationID_Course INT
			, CourseGradeLevel VARCHAR(100)
			, CourseLevelCharacteristic VARCHAR(100)
			, DataCollectionId INT
			, RecordStartDateTime DATETIME NULL
			, RecordEndDateTime DATETIME NULL
		)

		BEGIN TRY
			WITH DistinctCourseSections AS (
				SELECT DISTINCT
					  kcs.OrganizationID_Course
					, kcs.ScedCourseCode
					, kcs.CourseGradeLevel
					, kcs.CourseLevelCharacteristic
					, kcs.DataCollectionId
					, kcs.EntryDate
					, kcs.ExitDate
				FROM Staging.K12StudentCourseSection kcs
				WHERE kcs.OrganizationID_CourseSection IS NULL
			)
			MERGE dbo.Organization AS TARGET
			USING DistinctCourseSections AS SOURCE 
				ON 1 = 0 -- new course sections are prefiltered out IN DistinctCourseSections CTE
			WHEN NOT MATCHED THEN 
				INSERT (DataCollectionId) VALUES (Source.DataCollectionId) 
			OUTPUT 
				  INSERTED.OrganizationId
				, SOURCE.ScedCourseCode
				, SOURCE.OrganizationID_Course
				, SOURCE.CourseGradeLevel
				, SOURCE.CourseLevelCharacteristic
				, SOURCE.DataCollectionId
				, SOURCE.EntryDate
				, SOURCE.ExitDate
			INTO @NewCourseSections;
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S14EC0180'
		END CATCH


		----------------------------------------------------------------------------
		---UPDATE staging table organization IDs for new course sections      ------
		----------------------------------------------------------------------------

		BEGIN TRY
			UPDATE Staging.K12StudentCourseSection 
			SET OrganizationID_CourseSection = nsorg.OrganizationId
			FROM Staging.K12StudentCourseSection o
			JOIN @NewCourseSections nsorg
				ON o.OrganizationID_Course = nsorg.OrganizationID_Course
				AND o.ScedCourseCode = nsorg.ScedCourseCode
				AND isnull(o.CourseGradeLevel,'') = isnull(nsorg.CourseGradeLevel,'')
				AND o.CourseLevelCharacteristic = nsorg.CourseLevelCharacteristic
				AND ISNULL(o.DataCollectionId, '') = ISNULL(nsorg.DataCollectionId, '')
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S14EC0175'
		END CATCH

		-------------------------------------------------------------------------------------------
		---Manage the OrganizationPersonRole Records for each Student to Course relationship ------
		-------------------------------------------------------------------------------------------

		BEGIN TRY
			INSERT INTO [dbo].[OrganizationPersonRole]
					   ([OrganizationId]
					   ,[PersonId]
					   ,[RoleId]
					   ,[EntryDate]
					   ,[ExitDate]
					   ,[DataCollectionId])
			SELECT DISTINCT
						e.OrganizationID_CourseSection [OrganizationId]
					   ,e.PersonID [PersonId]
					   ,Staging.GetRoleId('K12 Student') [RoleId]
					   ,e.EntryDate [EntryDate]
					   ,e.ExitDate [ExitDate]
					   ,e.DataCollectionId [DataCollectionId]
			FROM Staging.K12StudentCourseSection e
			LEFT JOIN dbo.OrganizationPersonRole opr -- Make sure we don't add them to the course section twice. 
				ON e.PersonID = opr.PersonId
				AND e.EntryDate = opr.EntryDate
				AND e.OrganizationID_CourseSection = opr.OrganizationId
				AND ISNULL(e.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
				AND opr.RoleId = Staging.GetRoleId('K12 Student')
			WHERE opr.PersonId IS NULL
				AND e.OrganizationID_CourseSection IS NOT NULL
				AND e.PersonID IS NOT NULL
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationPersonRole', NULL, 'S14EC0190' 
		END CATCH

		BEGIN TRY
			UPDATE Staging.K12StudentCourseSection
			SET OrganizationPersonRoleId_CourseSection = opr.OrganizationPersonRoleId
			FROM Staging.K12StudentCourseSection e
			JOIN dbo.OrganizationPersonRole opr 
				ON e.PersonID = opr.PersonId 
				AND ISNULL(e.DataCollectionId, '') = ISNULL(opr.DataCollectionId, '')
			WHERE e.OrganizationID_CourseSection = opr.OrganizationId
				AND opr.RoleId = Staging.GetRoleId('K12 Student')
				AND opr.EntryDate = e.EntryDate
		END TRY

		BEGIN CATCH 
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.K12StudentCourseSection', 'OrganizationPersonRoleId_Course', 'S14EC0200' 
		END CATCH
		
		-----------------------------------------------------------
		---Create new CourseSection organization records     ------
		-----------------------------------------------------------

		BEGIN TRY
			INSERT INTO dbo.OrganizationDetail (
				  OrganizationId
				, Name
				, DataCollectionId
				, RefOrganizationTypeId
				, RecordStartDateTime
				, RecordEndDateTime
				)
			SELECT DISTINCT
				  o.OrganizationID_CourseSection
				, o.CourseLevelCharacteristic
				, o.DataCollectionId
				, @RefCourseSectionOrgTypeId
				, o.EntryDate
				, o.ExitDate
			FROM Staging.K12StudentCourseSection o
			WHERE OrganizationID_CourseSection IS NOT NULL
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationDetail', NULL, 'S14EC0170'
		END CATCH

		------------------------------------------------------------------
		---Create new CourseSection organization identifier records ------
		------------------------------------------------------------------

		BEGIN TRY
			INSERT INTO dbo.OrganizationIdentifier
			SELECT DISTINCT
				  o.CourseLevelCharacteristic
				, @RefCourseSectionOrgTypeId -- Course Characteristic				
				, o.OrganizationID_CourseSection
				, @RefCourseOrgIdentifierId -- Course Identiifer
				, o.EntryDate
				, o.ExitDate
				, o.DataCollectionId
			FROM Staging.K12StudentCourseSection o
			WHERE OrganizationID_CourseSection IS NOT NULL
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationIdentifier', NULL, 'S14EC0170'
		END CATCH

		-----------------------------------------------------------
		---Create Relationship b/w Courses and CourseSection ------
		-----------------------------------------------------------

		BEGIN TRY		
		INSERT INTO [dbo].[OrganizationRelationship]
			([Parent_OrganizationId]
			,[OrganizationId]
			,[RefOrganizationRelationshipId]
			,[DataCollectionId])
		SELECT DISTINCT
			 opt.OrganizationID_Course [Parent_OrganizationId]
			,opt.OrganizationID_CourseSection [OrganizationId]
			,NULL [RefOrganizationRelationshipId]
			,opt.DataCollectionId
		FROM Staging.K12StudentCourseSection opt
		LEFT JOIN dbo.OrganizationRelationship ore
			ON opt.OrganizationID_CourseSection = ore.OrganizationId
			AND opt.OrganizationID_Course = ore.Parent_OrganizationId
		WHERE ore.Parent_OrganizationId IS NULL
			AND opt.OrganizationID_CourseSection IS NOT NULL
			AND opt.OrganizationID_Course IS NOT NULL
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.OrganizationRelationship', NULL, 'S14EC0170'
		END CATCH

		-----------------------------------------------------------------------
		------ Create Course records for new course organization records ------
		-----------------------------------------------------------------------

		BEGIN TRY
			INSERT INTO dbo.Course
				(
				  OrganizationId
				, Description
				, RefCourseLevelCharacteristicsId
				, RefCourseApplicableEducationLevelId
				, DataCollectionId
				) 
			SELECT DISTINCT
				  cs.OrganizationID_Course
				, cs.ScedCourseCode
				, clc.RefCourseLevelCharacteristicId
				, lipt.RefCourseApplicableEducationLevelId
				, cs.DataCollectionId
			FROM Staging.K12StudentCourseSection cs
			LEFT JOIN dbo.Course c
				ON cs.OrganizationID_Course = c.OrganizationId
				and ISNULL(cs.DataCollectionId, '') = ISNULL(c.DataCollectionId, '')
			LEFT JOIN [Staging].[SourceSystemReferenceData] lisd 
				ON lisd.InputCode = isnull(cs.CourseGradeLevel,'')
				AND lisd.TableName = 'RefCourseApplicableEducationLevel'
				--AND lisd.SchoolYear = @SchoolYear
			LEFT JOIN [dbo].RefCourseApplicableEducationLevel lipt 
				ON lipt.Code = lisd.OutputCode
			LEFT JOIN [Staging].[SourceSystemReferenceData] ssrd 
				ON ssrd.InputCode = cs.CourseLevelCharacteristic
				AND ssrd.TableName = 'RefCourseLevelCharacteristic'
				--AND ssrd.SchoolYear = @SchoolYear
			LEFT JOIN [dbo].RefCourseLevelCharacteristic clc 
				ON clc.Code = ssrd.OutputCode
			WHERE c.OrganizationId IS NULL and cs.OrganizationID_Course IS NOT NULL 
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.Course', NULL, 'S14EC0200'
		END CATCH		


		---------------------------------------------------------------------------
		------ Create K12 Course records for new course organization records ------
		---------------------------------------------------------------------------

		BEGIN TRY
			INSERT INTO dbo.K12Course
				(
				  CourseId
				, SCEDCourseCode
				, DataCollectionId
				) 
			SELECT DISTINCT
				  c.CourseId
				, cs.ScedCourseCode
				, cs.DataCollectionId
			FROM Staging.K12StudentCourseSection cs
			LEFT JOIN dbo.Course c
				ON cs.OrganizationID_Course = c.OrganizationID
			LEFT JOIN dbo.K12Course kc
				ON kc.CourseId = c.CourseId
			WHERE c.OrganizationId IS NULL and cs.OrganizationID_Course IS NOT NULL
		END TRY

		BEGIN CATCH
			EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.K12Course', NULL, 'S14EC0200'
		END CATCH


		---------------------------------------------------------------------------
		------ Create CourseSection records for new course section records -----
		---------------------------------------------------------------------------

		--BEGIN TRY
		--	INSERT INTO dbo.CourseSection
		--		(
		--		 OrganizationId
		--		,CourseId
		--		,OrganizationCalendarSessionId --(academic term designator for SY)
		--		,DataCollectionId
		--		) 
		--	SELECT DISTINCT
		--		  cs.OrganizationID_CourseSection
		--		, cs.OrganizationID_Course
		--		, NULL
		--		, cs.DataCollectionId
		--	FROM Staging.K12StudentCourseSection cs
		--	LEFT JOIN dbo.CourseSection c
		--		ON cs.OrganizationID_Course = c.CourseId
		--			and cs.OrganizationID_CourseSection = c.OrganizationId
		--	WHERE c.OrganizationId IS NULL and cs.OrganizationID_Course IS NOT NULL
		--END TRY

		--BEGIN CATCH
		--	EXEC Staging.Migrate_Data_Validation_Logging @eStoredProc, 'dbo.CourseSection', NULL, 'S14EC0200'
		--END CATCH


		SET nocount off;


END
