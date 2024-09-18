-- =============================================
-- Author:		Andy Tsovma
-- Create date: 10/18/2018
-- Description:	Migrate cohort statuses
-- =============================================
CREATE PROCEDURE [RDS].[Migrate_DimCohortStatuses]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN

/*****************************
For Debugging 
*****************************/
--declare @studentDates as rds.StudentDateTableType
--declare @migrationType varchar(3) = 'rds'

----select the appropriate date variable, 8=17-18, 9=18-19, 10=19-20, etc...
--declare @selectedDate int = 9

----variable for the file spec, uncomment the appropriate one 
--declare     @factTypeCode as varchar(50) = 'gradrate'

--insert into @studentDates
--(
--     DimStudentId,
--     PersonId,
--     DimCountDateId,
--     SubmissionYearDate,
--     [Year],
--     SubmissionYearStartDate,
--     SubmissionYearEndDate
--)
--exec rds.Migrate_DimDates_Students @factTypeCode, @migrationType, @selectedDate
/*****************************
End of Debugging code 
*****************************/

	declare @COH as table ( DimStudentId integer, PersonId integer, CohortYear varchar(10), CohortDescription varchar(30), DiplomaOrCredentialAwardDate datetime)

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


	insert into @COH (DimStudentId, PersonId, CohortYear, CohortDescription, DiplomaOrCredentialAwardDate)
	select distinct ch.DimStudentId, p.PersonId, ch.CohortYear, ch.CohortDescription, a.DiplomaOrCredentialAwardDate
	--, ch.Cohort, p.FirstName, p.MiddleName, p.LastName,
	from ods.PersonDetail p
	inner join ods.OrganizationPersonRole r 
		on p.PersonId = r.PersonId 
		and r.RoleId = @studentRoleId
	inner join ods.K12StudentAcademicRecord a 
		on a.OrganizationPersonRoleId=r.OrganizationPersonRoleId
	left join (
		select distinct 
			s.DimStudentId, 
			r2.PersonId, 
			MAX(c.CohortYear) as CohortYear, 
			MAX(c.CohortYear) +  '-' + MAX(c.CohortGraduationYear) as Cohort, 
			c.CohortDescription
		from ods.OrganizationPersonRole r2
			inner join ods.K12StudentEnrollment enr on r2.OrganizationPersonRoleId = enr.OrganizationPersonRoleId
			inner join ods.RefGradeLevel grades on enr.RefEntryGradeLevelId = grades.RefGradeLevelId
			inner join ods.K12StudentCohort c on r2.OrganizationPersonRoleId = c.OrganizationPersonRoleId
			inner join @studentDates s on s.PersonId = r2.PersonId
		where grades.code = '09' 
		and r2.EntryDate <= s.SubmissionYearEndDate and (r2.ExitDate >= s.SubmissionYearStartDate or r2.ExitDate is null)
		group by s.DimStudentId, r2.PersonId, c.CohortDescription) as ch
		on ch.PersonId = r.PersonId
	inner join ods.PersonIdentifier pi 
		on p.PersonId = pi.PersonId
	where pi.RefPersonIdentificationSystemId = @stateIdentificationSystemId
	and pi.RefPersonalInformationVerificationId = @stateIssuedId
	and ch.Cohort is not null

	-- delete duplicate entries
	;WITH CTE AS(
	SELECT DimStudentId, PersonId, CohortYear, CohortDescription, DiplomaOrCredentialAwardDate, 
       RN = ROW_NUMBER()OVER(PARTITION BY PersonId ORDER BY PersonId)
	FROM @COH
	)
	DELETE FROM CTE WHERE RN > 1

	-- generate output
	select c.* , 
	case when c.CohortDescription is null then 'MISSING'
		else 
			case when c.CohortDescription = 'Regular Diploma' and YEAR(c.DiplomaOrCredentialAwardDate) = c.CohortYear then 'COHYES'
				 when c.CohortDescription = 'Regular Diploma' and YEAR(c.DiplomaOrCredentialAwardDate) <> c.CohortYear then 'COHNO'
				 when c.CohortDescription = 'Alternate Diploma' and YEAR(c.DiplomaOrCredentialAwardDate) = c.CohortYear  then 'COHALTDPL'
				 when c.CohortDescription = 'Alternate Diploma' and YEAR(c.DiplomaOrCredentialAwardDate) <> c.CohortYear  then 'COHNO'
				 when c.CohortDescription = 'Alternate Diploma - Removed' and YEAR(c.DiplomaOrCredentialAwardDate) = c.CohortYear then 'COHALTDPL'
				 when c.CohortDescription = 'Alternate Diploma - Removed' and YEAR(c.DiplomaOrCredentialAwardDate) <> c.CohortYear then 'COHREM'
				 else 'MISSING'
			end
		end as CohortStatus
	from @COH c

END