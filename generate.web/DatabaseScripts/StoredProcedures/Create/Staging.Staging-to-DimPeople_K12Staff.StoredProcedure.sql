CREATE PROCEDURE [Staging].[Staging-To-DimPeople_K12Staff]
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

		CREATE TABLE #k12Staff (
			FirstName										NVARCHAR(75) NULL
			, MiddleName									NVARCHAR(75) NULL
			, LastOrSurname									NVARCHAR(75) NULL
			, BirthDate										DATE NULL
			, K12StaffStaffMemberIdentifierState			NVARCHAR(40) NULL
			, IsActiveK12Staff 								BIT NULL
			, PositionTitle									NVARCHAR(200) NULL
			, RecordStartDateTime							DATE NULL
			, RecordEndDateTime								DATE NULL
		)
		
		INSERT INTO #k12Staff (
			FirstName
			, MiddleName
			, LastOrSurname
			, BirthDate
			, K12StaffStaffMemberIdentifierState
			, IsActiveK12Staff
			, PositionTitle
			, RecordStartDateTime
			, RecordEndDateTime
		)		
		SELECT DISTINCT
			FirstName
			, MiddleName
			, LastOrSurname
			, BirthDate
			, StaffMemberIdentifierState
			, 1
			, PositionTitle
			, RecordStartDateTime
			, RecordEndDateTime
		FROM Staging.K12StaffAssignment sa

		MERGE rds.DimPeople AS trgt
		USING #K12Staff AS src
				ON  trgt.K12StaffStaffMemberIdentifierState = src.K12StaffStaffMemberIdentifierState
				AND ISNULL(trgt.FirstName, '') = ISNULL(src.FirstName, '')
				AND ISNULL(trgt.LastOrSurname, '') = ISNULL(src.LastOrSurname, '')
				AND ISNULL(trgt.MiddleName, '') = ISNULL(src.MiddleName, '')
				AND ISNULL(trgt.BirthDate, '1900-01-01') = ISNULL(src.BirthDate, '1900-01-01')
				AND trgt.IsActiveK12Staff = 1
				AND trgt.RecordStartDateTime = src.RecordStartDateTime
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but NOT in Target
		INSERT (
			FirstName
			, MiddleName
			, LastOrSurname
			, BirthDate
			, K12StaffStaffMemberIdentifierState
			, IsActiveK12Staff
			, PositionTitle
			, RecordStartDateTime
			, RecordEndDateTime
		)
		VALUES (
			src.FirstName
			, src.MiddleName
			, src.LastOrSurname
			, src.Birthdate
			, src.K12StaffStaffMemberIdentifierState
			, src.IsActiveK12Staff
			, src.PositionTitle
			, src.RecordStartDateTime
			, src.RecordEndDateTime
		);

		--End date previous records
		UPDATE RDS.DimPeople
        SET RecordEndDateTime = NULL
        WHERE IsActiveK12Staff = 1

		;WITH upd AS (
			SELECT 
				  startd.K12StaffStaffMemberIdentifierState
				, startd.RecordStartDateTime
				, dateadd(day, -1, min(endd.RecordStartDateTime)) AS RecordEndDateTime
			FROM rds.DimPeople startd
			JOIN rds.DimPeople endd
				ON startd.K12StaffStaffMemberIdentifierState = endd.K12StaffStaffMemberIdentifierState
				AND startd.RecordStartDateTime < endd.RecordStartDateTime
			GROUP BY  startd.K12StaffStaffMemberIdentifierState, startd.RecordStartDateTime
		) 
		UPDATE staff 
		SET RecordEndDateTime = upd.RecordEndDateTime
		FROM rds.DimPeople staff
		INNER JOIN upd
			ON staff.K12StaffStaffMemberIdentifierState = upd.K12StaffStaffMemberIdentifierState
			AND staff.RecordStartDateTime = upd.RecordStartDateTime
		WHERE upd.RecordEndDateTime <> '1900-01-01 00:00:00.000'
			AND staff.RecordEndDateTime IS NULL

		-- Populate DimPeople_Current with active K12 staff records
		-- Populate DimPeople_Current with active K12 staff records

		-- Insert new current K12 staff records into DimPeople_Current
		INSERT INTO RDS.DimPeople_Current (
			FirstName,
			MiddleName,
			LastOrSurname,
			BirthDate,
			PositionTitle,
			K12StaffStaffMemberIdentifierState,
			IsActiveK12Staff
		)
		SELECT 
			rdp.FirstName,
			rdp.MiddleName,
			rdp.LastOrSurname,
			rdp.BirthDate,
			rdp.PositionTitle,
			rdp.K12StaffStaffMemberIdentifierState,
			rdp.IsActiveK12Staff
		FROM RDS.DimPeople rdp
		LEFT JOIN RDS.DimPeople_Current rdpc
			ON rdp.K12StaffStaffMemberIdentifierState = rdpc.K12StaffStaffMemberIdentifierState
			AND rdp.BirthDate = rdpc.BirthDate
		WHERE rdp.IsActiveK12Staff = 1 
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
			rdpc.PositionTitle = rdp.PositionTitle,
			rdpc.IsActiveK12Staff = rdp.IsActiveK12Staff
		FROM RDS.DimPeople_Current rdpc
		INNER JOIN RDS.DimPeople rdp
			ON rdpc.K12StaffStaffMemberIdentifierState = rdp.K12StaffStaffMemberIdentifierState
			AND rdpc.BirthDate = rdp.BirthDate
		WHERE rdp.IsActiveK12Staff = 1
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