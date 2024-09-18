



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


		insert into rds.DimStudents
		(
			StudentPersonId,
			FirstName,
			MiddleName,
			LastName,
			BirthDate,
			StateStudentIdentifier,
			Cohort
		)
		select distinct p.PersonId, p.FirstName, p.MiddleName, p.LastName, p.BirthDate, pi.Identifier, ch.Cohort
		from ods.PersonDetail p
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
		left join rds.DimStudents s on pi.Identifier = s.StateStudentIdentifier
		where pi.RefPersonIdentificationSystemId = @stateIdentificationSystemId
			and pi.RefPersonalInformationVerificationId = @stateIssuedId
			and s.DimStudentId IS NULL

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


