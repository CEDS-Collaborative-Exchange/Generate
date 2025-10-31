CREATE PROCEDURE [Staging].[Staging-To-DimPeople_K12Students]
	@dataCollectionId INT = NULL
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY

		IF NOT EXISTS (SELECT 1 FROM RDS.DimPeople WHERE DimPersonId = -1)
		BEGIN

			SET IDENTITY_INSERT RDS.DimPeople ON

			INSERT INTO RDS.DimPeople
			(DimPersonId)
			VALUES
			(-1)
	
			SET IDENTITY_INSERT RDS.DimPeople off
		END

		-- Ensure -1 record exists in DimPeople_Current
		IF NOT EXISTS (SELECT 1 FROM RDS.DimPeople_Current WHERE DimPersonId = -1)
		BEGIN

			SET IDENTITY_INSERT RDS.DimPeople_Current ON

			INSERT INTO RDS.DimPeople_Current
			(DimPersonId)
			VALUES
			(-1)
	
			SET IDENTITY_INSERT RDS.DimPeople_Current off
		END

		CREATE TABLE #k12Students (
			FirstName										NVARCHAR(75) NULL
			, MiddleName									NVARCHAR(75) NULL
			, LastOrSurname									NVARCHAR(75) NULL
			, BirthDate										DATE NULL
			, K12StudentStudentIdentifierState				NVARCHAR(40) NULL
			, IsActiveK12Student							BIT NULL
			, RecordStartDateTime							DATE NULL
			, RecordEndDateTime								DATE NULL
		)
		
		INSERT INTO #k12Students (
			FirstName
			, MiddleName
			, LastOrSurname
			, BirthDate
			, K12StudentStudentIdentifierState
			, IsActiveK12Student
			, RecordStartDateTime
			, RecordEndDateTime
		)		
		SELECT DISTINCT
			FirstName
			, MiddleName
			, LastOrSurname
			, BirthDate
			, StudentIdentifierState
			, 1
			, e.EnrollmentEntryDate
			, e.EnrollmentExitDate
		FROM Staging.K12Enrollment e

		MERGE rds.DimPeople AS trgt
		USING #k12Students AS src
				ON  trgt.K12StudentStudentIdentifierState = src.K12StudentStudentIdentifierState
				AND ISNULL(trgt.FirstName, '') = ISNULL(src.FirstName, '')
				AND ISNULL(trgt.LastOrSurname, '') = ISNULL(src.LastOrSurname, '')
				AND ISNULL(trgt.MiddleName, '') = ISNULL(src.MiddleName, '')
				AND ISNULL(trgt.BirthDate, '1900-01-01') = ISNULL(src.BirthDate, '1900-01-01')
				AND trgt.IsActiveK12Student = 1
				AND trgt.RecordStartDateTime = src.RecordStartDateTime
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but NOT in Target
		INSERT (
			FirstName
			, MiddleName
			, LastOrSurname
			, BirthDate
			, K12StudentStudentIdentifierState
			, IsActiveK12Student
			, RecordStartDateTime
			, RecordEndDateTime
		)
		VALUES (
			src.FirstName
			, src.MiddleName
			, src.LastOrSurname
			, src.Birthdate
			, src.K12StudentStudentIdentifierState
			, src.IsActiveK12Student
			, src.RecordStartDateTime
			, src.RecordEndDateTime
		);

		--End date previous records
		UPDATE RDS.DimPeople
        SET RecordEndDateTime = NULL
        WHERE IsActiveK12Student = 1

		;WITH upd AS (
			SELECT 
				  startd.K12StudentStudentIdentifierState
				, startd.RecordStartDateTime
				, dateadd(day, -1, min(endd.RecordStartDateTime)) AS RecordEndDateTime
			FROM rds.DimPeople startd
			JOIN rds.DimPeople endd
				ON startd.K12StudentStudentIdentifierState = endd.K12StudentStudentIdentifierState
				AND startd.RecordStartDateTime < endd.RecordStartDateTime
			GROUP BY  startd.K12StudentStudentIdentifierState, startd.RecordStartDateTime
		) 
		UPDATE student 
		SET RecordEndDateTime = upd.RecordEndDateTime
		FROM rds.DimPeople student
		INNER JOIN upd
			ON student.K12StudentStudentIdentifierState = upd.K12StudentStudentIdentifierState
			AND student.RecordStartDateTime = upd.RecordStartDateTime
		WHERE upd.RecordEndDateTime <> '1900-01-01 00:00:00.000'
			AND student.RecordEndDateTime IS NULL

		-- Populate DimPeople_Current with active K12 student records

		-- Insert current K12 student records into DimPeople_Current
		-- Insert new current K12 student records into DimPeople_Current
		INSERT INTO RDS.DimPeople_Current (
			FirstName,
			MiddleName,
			LastOrSurname,
			BirthDate,
			K12StudentStudentIdentifierState,
			IsActiveK12Student
		)
		SELECT 
			rdp.FirstName,
			rdp.MiddleName,
			rdp.LastOrSurname,
			rdp.BirthDate,
			rdp.K12StudentStudentIdentifierState,
			rdp.IsActiveK12Student
		FROM RDS.DimPeople rdp
		LEFT JOIN RDS.DimPeople_Current rdpc
			ON rdp.K12StudentStudentIdentifierState = rdpc.K12StudentStudentIdentifierState
			AND rdp.BirthDate = rdpc.BirthDate
		WHERE rdp.IsActiveK12Student = 1 
		AND rdpc.DimPersonId IS NULL  -- Only new active records
		AND rdp.RecordEndDateTime IS NULL  -- Only current/active records
		AND rdp.DimPersonId <> -1

		-- Update existing records in DimPeople_Current
		UPDATE rdpc
		SET 
			rdpc.FirstName = rdp.FirstName,
			rdpc.MiddleName = rdp.MiddleName,
			rdpc.LastOrSurname = rdp.LastOrSurname,
			rdpc.BirthDate = rdp.BirthDate,
			rdpc.IsActiveK12Student = rdp.IsActiveK12Student
		FROM RDS.DimPeople_Current rdpc
		INNER JOIN RDS.DimPeople rdp
			ON rdpc.K12StudentStudentIdentifierState = rdp.K12StudentStudentIdentifierState
			AND rdpc.BirthDate = rdp.BirthDate
		WHERE rdp.IsActiveK12Student = 1
		AND rdp.RecordEndDateTime IS NULL  -- Only current/active records
		AND rdp.DimPersonId <> -1

	END TRY
	BEGIN CATCH

		DECLARE @msg AS NVARCHAR(MAX)
		SET @msg = ERROR_MESSAGE()

		DECLARE @sev AS INT
		SET @sev = ERROR_SEVERITY()

		RAISERROR(@msg, @sev, 1)

	END CATCH

	SET NOCOUNT OFF;

END