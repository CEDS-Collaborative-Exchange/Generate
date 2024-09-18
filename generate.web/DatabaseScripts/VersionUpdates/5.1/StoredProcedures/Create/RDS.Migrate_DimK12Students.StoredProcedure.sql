CREATE PROCEDURE [RDS].[Migrate_DimK12Students]
	@dataCollectionId AS INT = NULL
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION

		IF NOT EXISTS (SELECT 1 FROM RDS.DimK12Students WHERE DimK12StudentId = -1)
		BEGIN

			SET IDENTITY_INSERT RDS.DimK12Students ON

			INSERT INTO RDS.DimK12Students
			(DimK12StudentId)
			VALUES
			(-1)
	
			SET IDENTITY_INSERT RDS.DimK12Students off
		END


		-- Lookup VALUES

		DECLARE @studentRoleId AS INT
		SELECT @studentRoleId = RoleId
		FROM dbo.[Role] WHERE Name = 'K12 Student'

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

		;WITH DATECTE AS (
              SELECT
                       PersonId
                     , RecordStartDateTime
					 , RecordEndDateTime
                     , ROW_NUMBER() OVER(PARTITION BY PersonId ORDER BY RecordStartDateTime, RecordEndDateTime) AS SequenceNumber
              FROM (
                           SELECT DISTINCT 
                                    PersonId
                                  , RecordStartDateTime
                                  , RecordEndDateTime
                           FROM dbo.PersonDetail
                           WHERE RecordStartDateTime IS NOT NULL

                     ) dates
       )
       , CTE as 
		( 
			SELECT DISTINCT 
				  p.FirstName
				, p.MiddleName
				, p.LastName
				, p.BirthDate
				, s.Code AS SexCode
				, s.Description as SexDescription
				, CASE s.Code 
					WHEN 'Male' THEN 'M'
					WHEN 'Female' THEN 'F'
					ELSE 'UNKNOWN'
				  END AS SexEdFactsCode
				, pi.Identifier
				, ch.Cohort
				,startDate.RecordStartDateTime AS RecordStartDateTime, 
            ISNULL(startDate.RecordEndDateTime, endDate.RecordStartDateTime - 1) AS RecordEndDateTime
			from DATECTE startDate
            LEFT JOIN DATECTE endDate ON startDate.PersonId = endDate.PersonId AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
			inner join dbo.PersonDetail p ON p.PersonId = startDate.PersonId  
											AND startDate.RecordStartDateTime BETWEEN p.RecordStartDateTime AND ISNULL(p.RecordEndDateTime, GETDATE())
			LEFT JOIN dbo.RefSex s
				ON p.RefSexId = s.RefSexId
			JOIN dbo.OrganizationPersonRole r 
				ON p.PersonId = r.PersonId
				AND (@dataCollectionId IS NULL 
					OR r.DataCollectionId = @dataCollectionId)	
				AND r.RoleId = @studentRoleId
			JOIN dbo.OrganizationDetail od
				on r.OrganizationId = od.OrganizationId
				and od.refOrganizationTypeId in (10,11,12) --School, LEA, IEU
			LEFT JOIN (	SELECT DISTINCT 
							  r2.PersonId
							, r2.OrganizationId
							, MAX(c.CohortYear) +  '-' + MAX(c.CohortGraduationYear) AS Cohort
						FROM dbo.OrganizationPersonRole r2
						JOIN dbo.K12StudentEnrollment enr 
							ON r2.OrganizationPersonRoleId = enr.OrganizationPersonRoleId
							AND (@dataCollectionId IS NULL 
								OR enr.DataCollectionId = @dataCollectionId)	
						JOIN dbo.RefGradeLevel grades 
							ON enr.RefEntryGradeLevelId = grades.RefGradeLevelId
						JOIN dbo.K12StudentCohort c 
							ON r2.OrganizationPersonRoleId = c.OrganizationPersonRoleId
						AND (@dataCollectionId IS NULL 
							OR c.DataCollectionId = @dataCollectionId)	
						WHERE grades.code = '09' 
							AND (@dataCollectionId IS NULL 
								OR r2.DataCollectionId = @dataCollectionId)	
						GROUP BY r2.PersonId, r2.OrganizationId) AS ch
				ON ch.PersonId = r.PersonId
				AND ch.OrganizationId = r.OrganizationId
			JOIN dbo.PersonIdentifier pi 
				ON p.PersonId = pi.PersonId
				AND (@dataCollectionId IS NULL 
					OR pi.DataCollectionId = @dataCollectionId)	
			WHERE pi.RefPersonIdentificationSystemId = @stateIdentificationSystemId	
				AND (@dataCollectionId IS NULL 
					OR p.DataCollectionId = @dataCollectionId)	
				AND pi.RefPersonalInformationVerificationId = @stateIssuedId
		)
		MERGE rds.DimK12Students AS trgt
		USING CTE AS src
				ON  trgt.StateStudentIdentifier = src.Identifier
				AND ISNULL(trgt.FirstName, '') = ISNULL(src.FirstName, '')
				AND ISNULL(trgt.LastName, '') = ISNULL(src.LastName, '')
				AND ISNULL(trgt.MiddleName, '') = ISNULL(src.MiddleName, '')
				AND ISNULL(trgt.RecordEndDateTime, '1/1/1900') = ISNULL(src.RecordEndDateTime, '1/1/1900')
				AND ISNULL(trgt.Cohort, '') = ISNULL(src.Cohort, '')
				AND ISNULL(trgt.SexCode, '') = ISNULL(src.SexCode, '')
				AND ISNULL(trgt.Birthdate, '') = ISNULL(src.Birthdate, '')
				AND trgt.RecordStartDateTime = src.RecordStartDateTime
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but NOT in Target
		INSERT (
			  [BirthDate]
			, [FirstName]
			, [LastName]
			, [MiddleName]
			, [StateStudentIdentifier]
			, RecordStartDateTime
			, RecordEndDateTime
			, Cohort
			, SexCode
			, SexDescription
			, SexEdFactsCode
			)
		VALUES (
			  src.Birthdate
			, src.FirstName
			, src.LastName
			, src.MiddleName
			, src.Identifier
			, src.RecordStartDateTime
			, src.RecordEndDateTime
			, src.Cohort
			, src.SexCode
			, src.SexDescription
			, src.SexEdFactscode
			);

		;WITH upd AS (
			SELECT 
				  startd.StateStudentIdentifier
				, startd.RecordStartDateTime
				, min(endd.RecordStartDateTime) - 1 AS RecordEndDateTime
			FROM rds.DimK12Students startd
			JOIN rds.DimK12Students endd
				ON startd.StateStudentIdentifier = endd.StateStudentIdentifier
				AND startd.RecordStartDateTime < endd.RecordStartDateTime
			GROUP BY  startd.StateStudentIdentifier, startd.RecordStartDateTime
		) 
		UPDATE student 
		SET RecordEndDateTime = upd.RecordEndDateTime
		FROM rds.DimK12Students student
		INNER JOIN upd
			ON student.StateStudentIdentifier = upd.StateStudentIdentifier
			AND student.RecordStartDateTime = upd.RecordStartDateTime
		WHERE upd.RecordEndDateTime <> '1900-01-01 00:00:00.000'
			AND student.RecordEndDateTime IS NULL
				
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