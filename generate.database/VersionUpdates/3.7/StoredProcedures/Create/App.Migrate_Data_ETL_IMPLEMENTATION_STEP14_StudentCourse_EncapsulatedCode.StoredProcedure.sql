CREATE PROCEDURE [App].[Migrate_Data_ETL_IMPLEMENTATION_STEP14_StudentCourse_EncapsulatedCode]
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
		DECLARE @eStoredProc			varchar(100) = 'Migrate_Data_ETL_IMPLEMENTATION_STEP14_StudentCourse_EncapsulatedCode'

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

		SET @RecordStartDate = App.GetFiscalYearStartDate(@SchoolYear);
		
		SET @RecordEndDate = App.GetFiscalYearEndDate(@SchoolYear);

		SET @UpdateDateTime = GETDATE()

		-------------------------------------------------------
		---Associate the PersonId with the temporary table ----
		-------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.StudentCourse
			SET PersonId = pid.PersonId
			FROM Staging.StudentCourse sc
			JOIN ODS.PersonIdentifier pid ON pid.Identifier = sc.Student_Identifier_State
			WHERE pid.RefPersonIdentificationSystemId = App.GetRefPersonIdentificationSystemId('State', '001075')
			AND pid.RefPersonalInformationVerificationId = App.GetRefPersonalInformationVerificationId('01011')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StudentCourse', 'PersonId', 'S14EC100' 
		END CATCH
		
		--------------------------------------------------------------------
		---Associate the LEA OrganizationId with the temporary table -------
		--------------------------------------------------------------------
		--BEGIN TRY
		--	UPDATE Staging.StudentCourse
		--	SET OrganizationID_LEA = orgid.OrganizationId
		--	FROM Staging.Enrollment e
		--	JOIN ODS.OrganizationIdentifier orgid ON orgid.Identifier = e.LEA_Identifier_State
		--	WHERE orgid.RefOrganizationIdentifierTypeId = App.GetOrganizationIdentifierTypeId('001072')
		--	AND orgid.RefOrganizationIdentificationSystemId = App.GetOrganizationIdentifierSystemId('SEA', '001072')
		--END TRY

		--BEGIN CATCH 
		--	EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StudentCourse', 'OrganizationID_LEA', 'S14EC110' 
		--END CATCH

		--------------------------------------------------------------------
		---Associate the School OrganizationId with the temporary table ----
		--------------------------------------------------------------------
		--BEGIN TRY
		--	UPDATE Staging.StudentCourse
		--	SET OrganizationID_School = orgid.OrganizationId
		--	FROM Staging.StudentCourse e
		--	JOIN ODS.OrganizationIdentifier orgid ON e.School_Identifier_State = orgid.Identifier
		--	WHERE orgid.RefOrganizationIdentifierTypeId = App.GetOrganizationIdentifierTypeId('001073')
		--	AND orgid.RefOrganizationIdentificationSystemId = App.GetOrganizationIdentifierSystemId('SEA', '001073')
		--END TRY

		--BEGIN CATCH 
		--	EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StudentCourse', 'OrganizationID_School', 'S14EC120' 
		--END CATCH

		--------------------------------------------------------------------
		---Associate the Course OrganizationId with the temporary table ----
		--------------------------------------------------------------------
		BEGIN TRY
			UPDATE Staging.StudentCourse
			SET OrganizationID_Course = orgid.OrganizationId
			FROM Staging.StudentCourse e
			JOIN ODS.OrganizationIdentifier orgid ON e.CourseCode = orgid.Identifier
			WHERE orgid.RefOrganizationIdentifierTypeId = App.GetOrganizationIdentifierTypeId('000056')
			AND orgid.RefOrganizationIdentificationSystemId = App.GetOrganizationIdentifierSystemId('State', '000056')
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StudentCourse', 'OrganizationID_Course', 'S14EC130' 
		END CATCH
		
		--Insert Course into ODS.Organization--
		DECLARE @NewCourse TABLE (
			  OrganizationId INT
			, SourceId INT
		)

		BEGIN TRY
			MERGE ODS.Organization AS TARGET
			USING Staging.StudentCourse AS SOURCE 
				ON TARGET.OrganizationId = SOURCE.OrganizationID_Course
			--When no records are matched, insert
			--the incoming records from source
			--table to target table
			WHEN NOT MATCHED BY TARGET THEN 
				INSERT DEFAULT VALUES
			OUTPUT 
				  INSERTED.OrganizationId AS OrganizationId
				, SOURCE.Id
			INTO @NewCourse;
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Organization', NULL, 'S14EC0140'
		END CATCH

		BEGIN TRY
			-- Update organization IDs in the staging table
			UPDATE Staging.StudentCourse 
			SET OrganizationID_Course = norg.OrganizationId
			FROM Staging.StudentCourse o
			JOIN @NewCourse norg
				ON o.Id = norg.SourceId
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StudentCourse', 'OrganizationID_Course', 'S14EC0150'
		END CATCH

		BEGIN TRY
			--Update Course names by end dating the 
			--current OrganizationDetail record and creating a new one
			UPDATE ods.OrganizationDetail
			SET RecordEndDateTime = @UpdateDateTime
			FROM Staging.StudentCourse o
			JOIN ods.OrganizationDetail od
				ON o.OrganizationID_Course = od.OrganizationId
				AND o.CourseCode <> od.[Name]
				AND od.RecordEndDateTime IS NULL
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ods.OrganizationDetail', 'RecordEndDateTime', 'S14EC0160'
		END CATCH

		BEGIN TRY
			INSERT INTO ods.OrganizationDetail
			SELECT 
				  o.OrganizationID_Course
				, LEFT(o.CourseCode, 60)
				, App.GetOrganizationTypeId('Course', '001156')
				, NULL
				, @UpdateDateTime
				, NULL
			FROM Staging.StudentCourse o
			JOIN ods.OrganizationDetail od
				ON o.OrganizationID_Course = od.OrganizationId
				AND o.CourseCode <> od.[Name]
				AND od.RecordEndDateTime = @UpdateDateTime
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ods.OrganizationDetail', NULL, 'S14EC0170'
		END CATCH

		BEGIN TRY
			MERGE ODS.OrganizationDetail AS TARGET
			USING Staging.StudentCourse AS SOURCE 
				ON TARGET.OrganizationId = SOURCE.OrganizationID_Course
			--When no records are matched, insert
			--the incoming records from source
			--table to target table
			WHEN NOT MATCHED THEN 
				INSERT (OrganizationId, [Name], RefOrganizationTypeId,RecordStartDateTime) 
				VALUES (
					  SOURCE.OrganizationID_Course
					, LEFT(SOURCE.CourseCode, 60)
					, App.GetOrganizationTypeId('Course', '001156')
					, @RecordStartDate);
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationDetail', NULL, 'S14EC0180'
		END CATCH

		-------------------------------------------------------------------------------------------
		---Manage the OrganizationPersonRole Records for each Student to Course relationship ------
		-------------------------------------------------------------------------------------------

		BEGIN TRY
			INSERT INTO [ODS].[OrganizationPersonRole]
					   ([OrganizationId]
					   ,[PersonId]
					   ,[RoleId]
					   ,[EntryDate]
					   ,[ExitDate])
			SELECT DISTINCT
						e.OrganizationID_Course [OrganizationId]
					   ,e.PersonID [PersonId]
					   ,App.GetRoleId('K12 Student') [RoleId]
					   ,@RecordStartDate [EntryDate]
					   ,@RecordEndDate [ExitDate]
			FROM Staging.StudentCourse e
			LEFT JOIN ODS.OrganizationPersonRole opr 
				ON e.PersonID = opr.PersonId
				--AND e.EnrollmentEntryDate = opr.EntryDate
				--AND ISNULL(e.EnrollmentExitDate, '1900-01-01') = ISNULL(opr.ExitDate, '1900-01-01')
				AND e.OrganizationID_Course = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student')
			WHERE opr.PersonId IS NULL
				AND e.OrganizationID_Course IS NOT NULL
				AND e.PersonID IS NOT NULL
				--AND e.EnrollmentEntryDate >= App.GetFiscalYearStartDate(@SchoolYear)
				--AND (e.EnrollmentExitDate IS NULL OR e.EnrollmentExitDate <= App.GetFiscalYearEndDate(@SchoolYear))
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.OrganizationPersonRole', NULL, 'S14EC0190' 
		END CATCH

		BEGIN TRY
			UPDATE Staging.StudentCourse
			SET OrganizationPersonRoleId_Course = opr.OrganizationPersonRoleId
			FROM Staging.StudentCourse e
			JOIN ODS.OrganizationPersonRole opr 
				ON e.PersonID = opr.PersonId 
			WHERE e.OrganizationID_Course = opr.OrganizationId
				AND opr.RoleId = App.GetRoleId('K12 Student')
				--AND EntryDate = e.EnrollmentEntryDate
		END TRY

		BEGIN CATCH 
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'Staging.StudentCourse', 'OrganizationPersonRoleId_Course', 'S14EC0200' 
		END CATCH
		

		/*
			[App].[Migrate_Data_ETL_IMPLEMENTATION_STEP14_StudentCourse_EncapsulatedCode] @SchoolYear=2018
		*/
		
		-- create Course records for new organizations
		BEGIN TRY
			MERGE ODS.Course AS TARGET
			USING Staging.StudentCourse AS SOURCE 
				ON TARGET.OrganizationId = SOURCE.OrganizationID_Course
			--When no records are matched, insert
			--the incoming records from source
			--table to target table
			WHEN NOT MATCHED THEN 
				INSERT (OrganizationId, Description) 
				VALUES (
					  SOURCE.OrganizationID_Course
					, LEFT(SOURCE.CourseCode, 60));
		END TRY

		BEGIN CATCH
			EXEC App.Migrate_Data_Validation_Logging @eStoredProc, 'ODS.Course', NULL, 'S14EC0200'
		END CATCH

		UPDATE ODS.Course
		SET ODS.Course.RefCourseApplicableEducationLevelId=lipt.RefCourseApplicableEducationLevelId
		FROM ODS.Course
		INNER JOIN Staging.StudentCourse sc ON sc.OrganizationID_Course=ODS.Course.OrganizationId
		LEFT JOIN ODS.SourceSystemReferenceData lisd 
			ON lisd.InputCode = sc.CourseGradeLevel
			   AND lisd.TableName = 'RefCourseApplicableEducationLevel'
			   AND lisd.SchoolYear = @SchoolYear
		LEFT JOIN [ODS].RefCourseApplicableEducationLevel lipt ON lipt.Code = lisd.OutputCode
		WHERE ODS.Course.RefCourseApplicableEducationLevelId IS NULL

		set nocount off;


END
