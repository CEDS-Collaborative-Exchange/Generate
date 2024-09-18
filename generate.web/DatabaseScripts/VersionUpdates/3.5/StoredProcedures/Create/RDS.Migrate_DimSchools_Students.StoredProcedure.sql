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

	select distinct
		s.DimStudentId,
		s.PersonId,
		s.DimCountDateId,
		ISNULL(sch.DimSchoolId, -1) as DimSchoolId,
		ISNULL(lea.DimLeaID, ISNULL(lea1.DimLeaID, -1)) as DimLeaID
	from @studentDates s
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId
	left outer join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
		and o.RefOrganizationTypeId = @schoolOrganizationTypeId
	left outer join ods.OrganizationIdentifier ois on o.OrganizationId = ois.OrganizationId
		and ois.RefOrganizationIdentificationSystemId = 
			(select RefOrganizationIdentificationSystemId 
			 from ods.RefOrganizationIdentificationSystem ois 
			 join ods.RefOrganizationIdentifierType ot 
				on ois.RefOrganizationIdentifierTypeId = ot.RefOrganizationIdentifierTypeId 
			 where ois.Code = 'School' and ot.Code = '000827')
	left outer join rds.DimSchools sch on sch.SchoolStateIdentifier = ois.Identifier and sch.RecordEndDateTime IS NULL
	left outer join ods.OrganizationDetail leaDetail on leaDetail.OrganizationId = r.OrganizationId
		and leaDetail.RefOrganizationTypeId = @leaOrganizationTypeId
	left outer join ods.OrganizationIdentifier oil on leaDetail.OrganizationId = oil.OrganizationId
		and oil.RefOrganizationIdentificationSystemId = 
			(select RefOrganizationIdentificationSystemId 
				from ods.RefOrganizationIdentificationSystem ois 
				join ods.RefOrganizationIdentifierType ot 
				on ois.RefOrganizationIdentifierTypeId = ot.RefOrganizationIdentifierTypeId 
				where ois.Code = 'LEA' and ot.Code = '000827')
	left join 
		(
			SELECT l1.OrganizationId as OrganizationId, r.OrganizationId as schOrganizationID, oil2.Identifier from ods.OrganizationRelationship r
				inner join ods.Organizationdetail l1 on l1.OrganizationId = r.Parent_OrganizationId and l1.RefOrganizationTypeId = @leaOrganizationTypeId
				inner join ods.OrganizationIdentifier oil2 on l1.OrganizationId = oil2.OrganizationId
					and oil2.RefOrganizationIdentificationSystemId = 
						(select RefOrganizationIdentificationSystemId 
						 from ods.RefOrganizationIdentificationSystem ois 
						 join ods.RefOrganizationIdentifierType ot 
							on ois.RefOrganizationIdentifierTypeId = ot.RefOrganizationIdentifierTypeId 
						 where ois.Code = 'LEA' and ot.Code = '000827')
				
		) l on l.schOrganizationID = o.OrganizationId

	left outer join rds.DimLeas lea on lea.LeaStateIdentifier = oil.Identifier and lea.RecordEndDateTime IS NULL
	left outer join rds.DimLeas lea1 on lea1.LeaStateIdentifier = l.Identifier and lea1.RecordEndDateTime IS NULL
	
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
	and (DimSchoolId > -1 or ((case when @useChildCountDate = 1 then ISNULL(lea.DimLeaID, ISNULL(lea1.DimLeaID, -1)) else lea1.DimLeaID end) > -1))
	  
END
