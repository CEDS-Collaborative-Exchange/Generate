CREATE FUNCTION [RDS].[Get_StudentOrganizations]
(
	@studentDates as StudentDateTableType READONLY,
	@useCutOffDate as bit
)
RETURNS @OrganizationData TABLE 
(
	DimK12StudentId int,
	PersonId int,
	DimCountDateId int,
	DimK12SchoolId int,
	DimLeaId int,
	DimSeaId int,
	OrganizationId int,
	LeaOrganizationId int
	unique clustered (DimK12StudentId, DimK12SchoolId, DimCountDateId, DimLeaId, DimSeaId, OrganizationId)
)
AS
BEGIN

	declare @leaOrganizationData TABLE 
	(
		DimK12StudentId int,
		PersonId int,
		DimCountDateId int,
		DimSeaId int,
		DimLeaId int,
		LeaOrganizationId int,
		OrganizationPersonRoleId int,
		OrganizationPersonRoleId_Parent int
		unique clustered (DimK12StudentId, PersonId, DimCountDateId, DimLeaId, DimSeaId, LeaOrganizationId,OrganizationPersonRoleId,OrganizationPersonRoleId_Parent)
	)

	declare @schOrganizationData TABLE 
	(
		DimK12StudentId int,
		PersonId int,
		DimCountDateId int,
		DimK12SchoolId int,
		SchOrganizationId int,
		OrganizationPersonRoleId int,
		OrganizationPersonRoleId_Parent int
		unique clustered (DimK12StudentId, PersonId, DimCountDateId, DimK12SchoolId, SchOrganizationId,OrganizationPersonRoleId,OrganizationPersonRoleId_Parent)
	)


	if @useCutOffDate = null
	begin
		set @useCutOffDate = 1
	end

	declare @k12StudentRoleId as int
	declare @schoolOrganizationTypeId as int, @leaOrganizationElementTypeId as int, @leaOrganizationTypeId as int
	select @k12StudentRoleId = RoleId from dbo.[Role] where Name = 'K12 Student'
	
	select @leaOrganizationElementTypeId = RefOrganizationElementTypeId from dbo.RefOrganizationElementType where Code = '001156'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from dbo.RefOrganizationType where code = 'K12School'
	select @leaOrganizationTypeId = RefOrganizationTypeId from dbo.RefOrganizationType where code = 'LEA' and RefOrganizationElementTypeId = @leaOrganizationElementTypeId


	insert into @leaOrganizationData(DimK12StudentId, PersonId, DimCountDateId, DimLeaId, LeaOrganizationId,OrganizationPersonRoleId,OrganizationPersonRoleId_Parent, DimSeaId)
	select distinct s.DimStudentId, s.PersonId, s.DimCountDateId, lea.DimLeaID, leaDetail.OrganizationId as LeaOrganizationid,
	rr.OrganizationPersonRoleId, rr.OrganizationPersonRoleId_Parent,  isnull(sea.DimSeaId,-1) as DimSeaId
	from @studentDates s
	inner join dbo.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId
	inner join dbo.OrganizationPersonRoleRelationship rr on r.OrganizationPersonRoleId = rr.OrganizationPersonRoleId_Parent
	inner join dbo.OrganizationDetail leaDetail on leaDetail.OrganizationId = r.OrganizationId
		and leaDetail.RefOrganizationTypeId = @leaOrganizationTypeId
	inner join dbo.OrganizationIdentifier oi on leaDetail.OrganizationId = oi.OrganizationId
		and oi.RefOrganizationIdentificationSystemId = 
			(select RefOrganizationIdentificationSystemId 
				from dbo.RefOrganizationIdentificationSystem ois 
				join dbo.RefOrganizationIdentifierType ot 
				on ois.RefOrganizationIdentifierTypeId = ot.RefOrganizationIdentifierTypeId 
				where ois.Code = 'SEA' and ot.Code = '001072')
	inner join rds.DimLeas lea on lea.LeaIdentifierState = oi.Identifier
			AND lea.RecordStartDateTime <= IIF(@useCutOffDate = 0, s.SubmissionYearEndDate, s.SubmissionYearDate)
			AND ((lea.RecordEndDateTime >= IIF(@useCutOffDate = 0, s.SubmissionYearStartDate, s.SubmissionYearDate)) 
			OR lea.RecordEndDateTime IS NULL)
			AND lea.LEAOperationalStatus not in ('Closed', 'Future', 'Inactive', 'MISSING')
	LEFT JOIN rds.DimSeas sea
        ON case	when @useCutOffDate = 0 then s.SubmissionYearStartDate else s.SubmissionYearDate end  <= ISNULL(sea.RecordEndDateTime, GETDATE())
        AND case when @useCutOffDate = 0 then s.SubmissionYearEndDate else s.SubmissionYearDate end >= sea.RecordStartDateTime
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


	insert into @schOrganizationData(DimK12StudentId, PersonId, DimCountDateId, DimK12SchoolId, SchOrganizationId,OrganizationPersonRoleId,OrganizationPersonRoleId_Parent)
	select distinct s.DimStudentId, s.PersonId, s.DimCountDateId, sch.DimK12SchoolId, o.OrganizationId as SchOrganizationId,
	rr.OrganizationPersonRoleId, rr.OrganizationPersonRoleId_Parent
	from @studentDates s
	inner join dbo.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId
	inner join dbo.OrganizationPersonRoleRelationship rr on r.OrganizationPersonRoleId = rr.OrganizationPersonRoleId
	inner join dbo.OrganizationDetail o on o.OrganizationId = r.OrganizationId
		and o.RefOrganizationTypeId = @schoolOrganizationTypeId
	inner join dbo.OrganizationIdentifier oi on o.OrganizationId = oi.OrganizationId
		and oi.RefOrganizationIdentificationSystemId = 
			(select RefOrganizationIdentificationSystemId 
				from dbo.RefOrganizationIdentificationSystem ois 
				join dbo.RefOrganizationIdentifierType ot 
				on ois.RefOrganizationIdentifierTypeId = ot.RefOrganizationIdentifierTypeId 
				where ois.Code = 'SEA' and ot.Code = '001073')
	inner join rds.DimK12Schools sch on sch.SchoolIdentifierState = oi.Identifier
			AND sch.RecordStartDateTime <= IIF(@useCutOffDate = 0, s.SubmissionYearEndDate, s.SubmissionYearDate)
			AND ((sch.RecordEndDateTime >= IIF(@useCutOffDate = 0, s.SubmissionYearStartDate, s.SubmissionYearDate)) 
			OR sch.RecordEndDateTime IS NULL)
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
	and DimK12SchoolId > -1


	insert into @OrganizationData(DimK12StudentId, PersonId, DimCountDateId, DimK12SchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId)
		select distinct leaLevel.DimK12StudentId, leaLevel.PersonId, leaLevel.DimCountDateId,isnull(schLevel.DimK12SchoolId, -1), leaLevel.DimLeaID,
			leaLevel.DimSeaId, isnull(schLevel.SchOrganizationId , -1), leaLevel.LeaOrganizationid
	from @leaOrganizationData leaLevel
	left outer join @schOrganizationData schLevel
	on leaLevel.DimK12StudentId = schLevel.DimK12StudentId and leaLevel.PersonId = schLevel.Personid and leaLevel.DimCountDateId = schLevel.DimCountDateId
	and leaLevel.OrganizationPersonRoleId = schLevel.OrganizationPersonRoleId
	and leaLevel.OrganizationPersonRoleId_Parent = schLevel.OrganizationPersonRoleId_Parent

	
	return;
END