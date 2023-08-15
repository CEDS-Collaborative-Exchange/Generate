CREATE PROCEDURE [RDS].[Migrate_DimSchools_Personnel]
	@personnelDates as PersonnelDateTableType READONLY,
	@useChildCountDate as bit
AS
BEGIN

	declare @k12TeacherRoleId as int
	declare @schoolOrganizationTypeId as int
	select @k12TeacherRoleId = RoleId from ods.[Role] where Name = 'K12 Personnel'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'

		-- School Identifer
	declare @schoolIdentifierTypeId as int
	select @schoolIdentifierTypeId = RefOrganizationIdentifierTypeId
	from ods.RefOrganizationIdentifierType
	where [Code] = '001073'
	
	--School State Identifer
	declare @schoolSEAIdentificationSystemId as int
	select @schoolSEAIdentificationSystemId = RefOrganizationIdentificationSystemId
	from ods.RefOrganizationIdentificationSystem
	where [Code] = 'SEA'
	and RefOrganizationIdentifierTypeId = @schoolIdentifierTypeId

	select 
		s.DimPersonnelId,
		s.PersonId,
		s.DimCountDateId,
		sch.DimSchoolId
	from @personnelDates s
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12TeacherRoleId
	inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
		and o.RefOrganizationTypeId = @schoolOrganizationTypeId
		and s.SubmissionYearDate between ISNULL(o.RecordStartDateTime, s.SubmissionYearDate) and ISNULL(o.RecordEndDateTime, GETDATE())
	inner join ods.OrganizationIdentifier oi on o.OrganizationId = oi.OrganizationId
		and oi.RefOrganizationIdentificationSystemId = @schoolSEAIdentificationSystemId 
	inner join rds.DimSchools sch on sch.SchoolStateIdentifier = oi.Identifier and sch.RecordEndDateTime IS NULL
	where r.EntryDate <=
		case
			when @useChildCountDate = 0 then s.SubmissionYearEndDate
			else s.SubmissionYearDate
		end 
	and (
		r.ExitDate >=
			case
				when @useChildCountDate = 0 then s.SubmissionYearStartDate
				else s.SubmissionYearDate
			end 
	or r.ExitDate is null)

END