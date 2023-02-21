



CREATE PROCEDURE [RDS].[Migrate_DimSchools_Students]
	@studentDates as StudentDateTableType READONLY,
	@useChildCountDate as bit
AS
BEGIN

	if @useChildCountDate = null
	begin
		set @useChildCountDate = 1
	end

	declare @k12StudentRoleId as int
	declare @schoolOrganizationTypeId as int, @leaOrganizationElementTypeId as int, @leaOrganizationTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	
	select @leaOrganizationElementTypeId = RefOrganizationElementTypeId from ods.RefOrganizationElementType where Code = '001156'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'
	select @leaOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'LEA' and RefOrganizationElementTypeId = @leaOrganizationElementTypeId

	select 
		s.DimStudentId,
		s.PersonId,
		s.DimCountDateId,
		sch.DimSchoolId,
		lea.DimLeaID
	from @studentDates s
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId
	inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
		and o.RefOrganizationTypeId = @schoolOrganizationTypeId
	
	--inner join ods.OrganizationDetail l on l.OrganizationId = r.OrganizationId
	--	and l.RefOrganizationTypeId = @leaOrganizationTypeId
	
	left join 
		(
			SELECT l1.OrganizationId as OrganizationId, r.OrganizationId as schOrganizationID from ods.OrganizationRelationship r
				inner join ods.Organizationdetail l1 on l1.OrganizationId = r.Parent_OrganizationId and l1.RefOrganizationTypeId = @leaOrganizationTypeId
				
		) l on l.schOrganizationID = o.OrganizationId
	
	inner join rds.DimSchools sch on sch.SchoolOrganizationId = o.OrganizationId
	left outer join rds.DimLeas lea on lea.LeaOrganizationId = l.OrganizationId
	
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

