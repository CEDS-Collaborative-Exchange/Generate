CREATE PROCEDURE [RDS].[Migrate_DimStudents]
AS
BEGIN

	SET NOCOUNT ON;

	begin try
		begin transaction
	

		if not exists (select 1 from RDS.DimStudents where DimStudentId = -1)
		begin

			set identity_insert RDS.DimStudents on

			insert into RDS.DimStudents
			(DimStudentId)
			values
			(-1)
	
			set identity_insert RDS.DimStudents off
		end


		-- Lookup Values

		declare @studentRoleId as int
		select @studentRoleId = RoleId
		from ods.[Role] where Name = 'K12 Student'

		declare @studentIdentifierTypeId as int
		select @studentIdentifierTypeId = RefPersonIdentifierTypeId
		from ods.RefPersonIdentifierType
		where [Code] = '001075'

		declare @schoolIdentificationSystemId as int
		select @schoolIdentificationSystemId = RefPersonIdentificationSystemId
		from ods.RefPersonIdentificationSystem
		where [Code] = 'School' and RefPersonIdentifierTypeId = @studentIdentifierTypeId

		declare @stateIdentificationSystemId as int
		select @stateIdentificationSystemId = RefPersonIdentificationSystemId
		from ods.RefPersonIdentificationSystem
		where [Code] = 'State' and RefPersonIdentifierTypeId = @studentIdentifierTypeId

		declare @stateIssuedId as int
		select @stateIssuedId = RefPersonalInformationVerificationId
		from ods.RefPersonalInformationVerification
		where [Code] = '01011'

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
                           FROM ods.PersonDetail
                           WHERE RecordStartDateTime IS NOT NULL

                     ) dates
       )
       , CTE as 
		( 
			select distinct p.PersonId, p.FirstName, p.MiddleName, p.LastName, p.BirthDate, pi.Identifier, ch.Cohort,
			 startDate.RecordStartDateTime AS RecordStartDateTime,
            ISNULL(startDate.RecordEndDateTime, endDate.RecordStartDateTime - 1) AS RecordEndDateTime
			from DATECTE startDate
            LEFT JOIN DATECTE endDate ON startDate.PersonId = endDate.PersonId AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
			inner join ods.PersonDetail p ON p.PersonId = startDate.PersonId  
											AND startDate.RecordStartDateTime BETWEEN p.RecordStartDateTime AND ISNULL(p.RecordEndDateTime, GETDATE())
			inner join ods.OrganizationPersonRole r on p.PersonId = r.PersonId
				and r.RoleId = @studentRoleId
			left join (select distinct r2.PersonId, MAX(c.CohortYear) +  '-' + MAX(c.CohortGraduationYear) as Cohort
				from ods.OrganizationPersonRole r2
					inner join ods.K12StudentEnrollment enr on r2.OrganizationPersonRoleId = enr.OrganizationPersonRoleId
					inner join ods.RefGradeLevel grades on enr.RefEntryGradeLevelId = grades.RefGradeLevelId
					inner join ods.K12StudentCohort c on r2.OrganizationPersonRoleId = c.OrganizationPersonRoleId
				where grades.code = '09' 
				group by r2.PersonId) as ch
				on ch.PersonId = r.PersonId
			inner join ods.PersonIdentifier pi on p.PersonId = pi.PersonId
			where pi.RefPersonIdentificationSystemId = @stateIdentificationSystemId	and pi.RefPersonalInformationVerificationId = @stateIssuedId
		)
		MERGE rds.DimStudents as trgt
		USING CTE as src
				ON  trgt.StateStudentIdentifier = src.Identifier				
				AND trgt.RecordStartDateTime = src.RecordStartDateTime
		WHEN MATCHED THEN 
			Update SET trgt.Birthdate = src.Birthdate,
			 trgt.FirstName = src.FirstName,
			 trgt.LastName = src.LastName,
			 trgt.MiddleName = src.MiddleName,
			 trgt.RecordEndDateTime = src.RecordEndDateTime,
			 trgt.Cohort = src.Cohort 
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but not in Target
		INSERT([BirthDate],[FirstName],[LastName],[MiddleName],[StateStudentIdentifier],RecordStartDateTime, RecordEndDateTime, Cohort)
		Values(src.Birthdate, src.FirstName, src.LastName, src.MiddleName, src.Identifier, src.RecordStartDateTime, src.RecordEndDateTime, src.Cohort);


		;WITH upd AS(
				SELECT DimStudentId, StateStudentIdentifier, RecordStartDateTime, 
				LEAD(RecordStartDateTime, 1, 0) OVER (PARTITION BY StateStudentIdentifier ORDER BY RecordStartDateTime ASC) AS endDate 
			FROM rds.DimStudents  
			WHERE RecordEndDateTime is null and DimStudentId <> -1
		) 
		UPDATE student SET RecordEndDateTime = upd.endDate -1 
		FROM rds.DimStudents student
		inner join upd	on student.DimStudentId = upd.DimStudentId
		WHERE upd.endDate <> '1900-01-01 00:00:00.000'


		
		commit transaction

	end try
	begin catch

		IF @@TRANCOUNT > 0
		begin
			rollback transaction
		end

		declare @msg as nvarchar(max)
		set @msg = ERROR_MESSAGE()

		declare @sev as int
		set @sev = ERROR_SEVERITY()

		RAISERROR(@msg, @sev, 1)

	end catch


	SET NOCOUNT OFF;

END