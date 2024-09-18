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
		LeaOrganizationId int,
		OrganizationPersonRoleId int,
		OrganizationPersonRoleId_Parent int
		unique clustered (DimStudentId, PersonId, DimCountDateId, DimLeaId, LeaOrganizationId,OrganizationPersonRoleId,OrganizationPersonRoleId_Parent)
	)

	declare @schOrganizationData TABLE 
	(
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		SchOrganizationId int,
		OrganizationPersonRoleId int,
		OrganizationPersonRoleId_Parent int
		unique clustered (DimStudentId, PersonId, DimCountDateId, DimSchoolId, SchOrganizationId,OrganizationPersonRoleId,OrganizationPersonRoleId_Parent)
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


	insert into @leaOrganizationData(DimStudentId, PersonId, DimCountDateId, DimLeaId, LeaOrganizationId,OrganizationPersonRoleId,OrganizationPersonRoleId_Parent)
	select distinct s.DimStudentId, s.PersonId, s.DimCountDateId, lea.DimLeaID, leaDetail.OrganizationId as LeaOrganizationid,
	rr.OrganizationPersonRoleId, rr.OrganizationPersonRoleId_Parent
	from @studentDates s
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId
	inner join ods.OrganizationPersonRoleRelationship rr on r.OrganizationPersonRoleId = rr.OrganizationPersonRoleId_Parent
	inner join ods.OrganizationDetail leaDetail on leaDetail.OrganizationId = r.OrganizationId
		and leaDetail.RefOrganizationTypeId = @leaOrganizationTypeId
	inner join ods.OrganizationIdentifier oi on leaDetail.OrganizationId = oi.OrganizationId
		and oi.RefOrganizationIdentificationSystemId = 
			(select RefOrganizationIdentificationSystemId 
				from ods.RefOrganizationIdentificationSystem ois 
				join ods.RefOrganizationIdentifierType ot 
				on ois.RefOrganizationIdentifierTypeId = ot.RefOrganizationIdentifierTypeId 
				where ois.Code = 'SEA' and ot.Code = '001072')
	inner join rds.DimLeas lea on lea.LeaStateIdentifier = oi.Identifier
			AND lea.RecordStartDateTime <= IIF(@useCutOffDate = 0, s.SubmissionYearEndDate, s.SubmissionYearDate)
			AND ((lea.RecordEndDateTime >= IIF(@useCutOffDate = 0, s.SubmissionYearStartDate, s.SubmissionYearDate)) 
			OR lea.RecordEndDateTime IS NULL)
			AND lea.OperationalStatusEffectiveDate BETWEEN s.SubmissionYearStartDate 
			AND IIF(@useCutOffDate = 0, s.SubmissionYearEndDate, s.SubmissionYearDate)
			AND lea.LEAOperationalStatus not in ('Closed', 'Future', 'Inactive', 'MISSING')
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


	insert into @schOrganizationData(DimStudentId, PersonId, DimCountDateId, DimSchoolId, SchOrganizationId,OrganizationPersonRoleId,OrganizationPersonRoleId_Parent)
	select distinct s.DimStudentId, s.PersonId, s.DimCountDateId, sch.DimSchoolId, o.OrganizationId as SchOrganizationId,
	rr.OrganizationPersonRoleId, rr.OrganizationPersonRoleId_Parent
	from @studentDates s
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId
	inner join ods.OrganizationPersonRoleRelationship rr on r.OrganizationPersonRoleId = rr.OrganizationPersonRoleId
	inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
		and o.RefOrganizationTypeId = @schoolOrganizationTypeId
	inner join ods.OrganizationIdentifier oi on o.OrganizationId = oi.OrganizationId
		and oi.RefOrganizationIdentificationSystemId = 
			(select RefOrganizationIdentificationSystemId 
				from ods.RefOrganizationIdentificationSystem ois 
				join ods.RefOrganizationIdentifierType ot 
				on ois.RefOrganizationIdentifierTypeId = ot.RefOrganizationIdentifierTypeId 
				where ois.Code = 'SEA' and ot.Code = '001073')
	inner join rds.DimSchools sch on sch.SchoolStateIdentifier = oi.Identifier
			AND sch.RecordStartDateTime <= IIF(@useCutOffDate = 0, s.SubmissionYearEndDate, s.SubmissionYearDate)
			AND ((sch.RecordEndDateTime >= IIF(@useCutOffDate = 0, s.SubmissionYearStartDate, s.SubmissionYearDate)) 
			OR sch.RecordEndDateTime IS NULL)
			AND sch.OperationalStatusEffectiveDate BETWEEN s.SubmissionYearStartDate 
			AND IIF(@useCutOffDate = 0, s.SubmissionYearEndDate, s.SubmissionYearDate)
			AND sch.SchoolOperationalStatus not in ('Closed', 'Future', 'Inactive', 'MISSING')
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
	and leaLevel.OrganizationPersonRoleId = schLevel.OrganizationPersonRoleId
	and leaLevel.OrganizationPersonRoleId_Parent = schLevel.OrganizationPersonRoleId_Parent

	
	return;
END
