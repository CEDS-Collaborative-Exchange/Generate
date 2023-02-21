CREATE PROCEDURE [RDS].[Migrate_DimPsStudents]
	@dataCollectionId AS INT = NULL
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION

		IF NOT EXISTS (SELECT 1 FROM RDS.DimPsStudents WHERE DimPsStudentId = -1)
		BEGIN

			SET IDENTITY_INSERT RDS.DimPsStudents ON

			INSERT INTO RDS.DimPsStudents
			(DimPsStudentId, RecordStartDateTime)
			VALUES
			(-1, '01/01/1900')
	
			SET IDENTITY_INSERT RDS.DimPsStudents off
		END


		-- Lookup VALUES

		DECLARE @studentRoleId AS INT
		SELECT @studentRoleId = RoleId
		FROM dbo.[Role] WHERE Name = 'Postsecondary Student'

		DECLARE @studentIdentifierTypeId AS INT
		SELECT @studentIdentifierTypeId = RefPersonIdentifierTypeId
		FROM dbo.RefPersonIdentifierType
		WHERE [Code] = '001075'

		DECLARE @schoolIdentificationSystemId AS INT
		SELECT @schoolIdentificationSystemId = RefPersonIdentificationSystemId
		FROM dbo.RefPersonIdentificationSystem
		WHERE [Code] = 'School' AND RefPersonIdentifierTypeId = @studentIdentifierTypeId

		DECLARE @stateIdentificationSystemId AS INT
		SELECT @stateIdentificationSystemId = RefPersonIdentificationSystemId
		FROM dbo.RefPersonIdentificationSystem
		WHERE [Code] = 'State' AND RefPersonIdentifierTypeId = @studentIdentifierTypeId

		DECLARE @stateIssuedId AS INT
		SELECT @stateIssuedId = RefPersonalInformationVerificationId
		FROM dbo.RefPersonalInformationVerification
		WHERE [Code] = '01011'

		;WITH CTE AS 
		( 
			SELECT DISTINCT 
				  p.FirstName
				, p.MiddleName
				, p.LastName
				, p.BirthDate
				, s.Code
				, s.Description
				, pi.Identifier
				, p.RecordStartDateTime
			FROM dbo.PersonDetail p
			JOIN dbo.OrganizationPersonRole r 
				ON p.PersonId = r.PersonId
				AND (@dataCollectionId IS NULL 
					OR r.DataCollectionId = @dataCollectionId)	
				AND r.RoleId = @studentRoleId
			JOIN dbo.PersonIdentifier pi 
				ON p.PersonId = pi.PersonId
				AND (@dataCollectionId IS NULL 
					OR pi.DataCollectionId = @dataCollectionId)	
			JOIN dbo.RefSex s
				ON s.RefSexId = p.RefSexId 
			WHERE pi.RefPersonIdentificationSystemId = @stateIdentificationSystemId	
				AND (@dataCollectionId IS NULL 
					OR p.DataCollectionId = @dataCollectionId)	
				AND pi.RefPersonalInformationVerificationId = @stateIssuedId
		)
		MERGE rds.DimPsStudents AS trgt
		USING CTE AS src
				ON  trgt.StudentIdentifierState = src.Identifier
				AND trgt.RecordStartDateTime = src.RecordStartDateTime
				AND trgt.SexCode = src.Code
				and trgt.BirthDate = src.BirthDate
		--WHEN MATCHED AND (
		--		ISNULL(trgt.Birthdate, '1/1/1900') <> ISNULL(src.Birthdate, '1/1/1900')
		--		OR ISNULL(trgt.FirstName, '') <> ISNULL(src.FirstName, '')
		--		OR ISNULL(trgt.LastName, '') <> ISNULL(src.LastName, '')
		--		OR ISNULL(trgt.MiddleName, '') <> ISNULL(src.MiddleName, '')
		--		OR ISNULL(trgt.SexCode, '') <> ISNULL(src.Code, '')
		--		)
		--		THEN 
		--	UPDATE SET 
		--		  trgt.Birthdate = src.Birthdate
		--		, trgt.FirstName = src.FirstName
		--		, trgt.LastName = src.LastName
		--		, trgt.MiddleName = src.MiddleName
		--		, trgt.SexCode = src.Code
		--		, trgt.SexDescription = src.Description
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists IN Source but NOT IN Target
		INSERT (
			  [BirthDate]
			, [FirstName]
			, [LastName]
			, [MiddleName]
			, [SexCode]
			, [SexDescription]
			, [StudentIdentifierState]
			, RecordStartDateTime
			)
		VALUES (
			  src.Birthdate
			, src.FirstName
			, src.LastName
			, src.MiddleName
			, src.Code
			, src.Description
			, src.Identifier
			, src.RecordStartDateTime
			);

		UPDATE student 
		SET RecordEndDateTime = NULL
		FROM rds.DimPsStudents student

		;WITH upd AS(
		SELECT 
			startd.StudentIdentifierState
			, startd.RecordStartDateTime
			, min(endd.RecordStartDateTime) - 1 AS RecordEndDateTime
		FROM rds.DimPsStudents startd
		JOIN rds.DimPsStudents endd
		ON startd.StudentIdentifierState = endd.StudentIdentifierState
		AND startd.RecordStartDateTime < endd.RecordStartDateTime
		GROUP BY  startd.StudentIdentifierState, startd.RecordStartDateTime
		) 

		UPDATE student 
		SET RecordEndDateTime = upd.RecordEndDateTime
		FROM rds.DimPsStudents student
		INNER JOIN upd	
			ON student.StudentIdentifierState = upd.StudentIdentifierState
			AND student.RecordStartDateTime = upd.RecordStartDateTime
		
		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION
		END

		DECLARE @msg AS NVARCHAR(MAX)
		SET @msg = ERROR_MESSAGE()

		DECLARE @sev AS INT
		SET @sev = ERROR_SEVERITY()

		RAISERROR(@msg, @sev, 1)

	END CATCH


	SET NOCOUNT OFF;

END