CREATE FUNCTION [RDS].[Get_StudentOrganizations]
(
	@studentDates as StudentDateTableType READONLY,
	@useCutOffDate as bit
)
RETURNS @OrganizationData TABLE 
(
	DimStudentId int,
	PersonId int,
	DimCountDateId int,
	DimSchoolId int,
	DimLeaId int,
	OrganizationId int,
	LeaOrganizationId int
	unique clustered (DimStudentId, DimSchoolId, DimCountDateId, DimLeaId, OrganizationId)
)
AS
BEGIN

	declare @leaOrganizationData TABLE 
	(
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimLeaId int,
		LeaOrganizationId int
		unique clustered (DimStudentId, PersonId, DimCountDateId, DimLeaId, LeaOrganizationId)
	)

	declare @schOrganizationData TABLE 
	(
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		SchOrganizationId int
		unique clustered (DimStudentId, PersonId, DimCountDateId, DimSchoolId, SchOrganizationId)
	)


	if @useCutOffDate = null
	begin
		set @useCutOffDate = 1
	end

	declare @k12StudentRoleId as int
	declare @schoolOrganizationTypeId as int, @leaOrganizationElementTypeId as int, @leaOrganizationTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	
	select @leaOrganizationElementTypeId = RefOrganizationElementTypeId from ods.RefOrganizationElementType where Code = '001156'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'
	select @leaOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'LEA' and RefOrganizationElementTypeId = @leaOrganizationElementTypeId


	insert into @leaOrganizationData(DimStudentId, PersonId, DimCountDateId, DimLeaId, LeaOrganizationId)
	select distinct s.DimStudentId, s.PersonId, s.DimCountDateId, lea.DimLeaID, leaDetail.OrganizationId as LeaOrganizationid
	from @studentDates s
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId
	inner join ods.OrganizationDetail leaDetail on leaDetail.OrganizationId = r.OrganizationId
		and leaDetail.RefOrganizationTypeId = @leaOrganizationTypeId
	inner join rds.DimLeas lea on lea.LeaOrganizationId = leaDetail.OrganizationId
	where r.EntryDate <=
		case
			when @useCutOffDate = 0 then s.SubmissionYearEndDate
			else s.SubmissionYearDate
		end 
	and (
		r.ExitDate >=
			case
				when @useCutOffDate = 0 then s.SubmissionYearStartDate
				else s.SubmissionYearDate
			end 
	or r.ExitDate is null) and lea.DimLeaID > -1


	insert into @schOrganizationData(DimStudentId, PersonId, DimCountDateId, DimSchoolId, SchOrganizationId)
	select distinct s.DimStudentId, s.PersonId, s.DimCountDateId, sch.DimSchoolId, o.OrganizationId as SchOrganizationId
	from @studentDates s
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId
	inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
		and o.RefOrganizationTypeId = @schoolOrganizationTypeId
	inner join rds.DimSchools sch on sch.SchoolOrganizationId = o.OrganizationId
	where r.EntryDate <=
		case
			when @useCutOffDate = 0 then s.SubmissionYearEndDate
			else s.SubmissionYearDate
		end 
	and (
		r.ExitDate >=
			case
				when @useCutOffDate = 0 then s.SubmissionYearStartDate
				else s.SubmissionYearDate
			end 
	or r.ExitDate is null)
	and DimSchoolId > -1


	insert into @OrganizationData(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId)
		select distinct leaLevel.DimStudentId, leaLevel.PersonId, leaLevel.DimCountDateId,isnull(schLevel.DimSchoolId, -1), leaLevel.DimLeaID, 
		   isnull(schLevel.SchOrganizationId , -1), leaLevel.LeaOrganizationid
	from @leaOrganizationData leaLevel
	left outer join @schOrganizationData schLevel
	on leaLevel.DimStudentId = schLevel.DimStudentId and leaLevel.PersonId = schLevel.Personid and leaLevel.DimCountDateId = schLevel.DimCountDateId
	

	
	return;
END