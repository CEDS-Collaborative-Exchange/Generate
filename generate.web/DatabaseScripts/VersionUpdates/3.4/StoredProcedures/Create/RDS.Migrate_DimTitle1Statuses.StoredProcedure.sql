CREATE PROCEDURE [RDS].[Migrate_DimTitle1Statuses]
	@studentDates as StudentDateTableType READONLY
AS
BEGIN

	declare @k12StudentRoleId as int
	declare @schoolOrganizationTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'

	CREATE TABLE #studentOrganizations
			(
				DimStudentId int,
				PersonId int,
				DimCountDateId int,
				DimSchoolId int,
				DimLeaId int,
				OrganizationId int,
				LeaOrganizationId int
			)

	
	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId from RDS.Get_StudentOrganizations(@studentDates,0)

	select distinct
		s.DimStudentId,
		org.DimSchoolId,
		org.DimLeaId,
		s.PersonId,
		s.DimCountDateId,		
		isnull(title1Status.Code, 'MISSING') as TitleISchoolStatusCode,
		isnull(instrlSrvc.Code,'MISSING') as TitleIinstructionalServiceCode,
		isnull(srvc.Code,'MISSING') as Title1SupportServiceCode,
		isnull(prgType.Code,'MISSING') as Title1ProgramTypeCode		
	from @studentDates s
	inner join #studentOrganizations org
	on s.PersonId = org.PersonId and s.DimCountDateId = org.DimCountDateId
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
		and s.SubmissionYearDate between r.EntryDate and isnull(r.ExitDate, getdate())
	inner join ods.OrganizationRelationship ore on r.OrganizationId = ore.OrganizationId
	left outer join ods.K12School sch on org.OrganizationId = sch.OrganizationId
	left join ods.K12SchoolStatus t1schStatus on t1schStatus.K12SchoolId = sch.K12SchoolId
	left join ods.RefTitleISchoolStatus title1Status on t1schStatus.RefTitleISchoolStatusId = title1Status.RefTitle1SchoolStatusId
	left join ods.K12programOrService ps on ps.OrganizationId = ore.Parent_OrganizationId
	and ps.RecordStartDateTime <= s.SubmissionYearEndDate and (ps.RecordEndDateTime >=  s.SubmissionYearStartDate or ps.RecordEndDateTime is null)	
	left join ods.RefTitleIinstructionalServices instrlSrvc on instrlSrvc.RefTitleIInstructionalServicesId = ps.RefTitleIInstructionalServicesId
	left join ods.K12programOrService ps2 on ps2.OrganizationId = ore.Parent_OrganizationId	
	and ps2.RecordStartDateTime <= s.SubmissionYearEndDate and (ps2.RecordEndDateTime >=  s.SubmissionYearStartDate or ps2.RecordEndDateTime is null)	
	left join ods.RefTitleIProgramType prgType on prgType.RefTitleIProgramTypeId = ps2.RefTitleIProgramTypeId	
	left join ods.K12LeaTitleISupportService tss on tss.OrganizationId = ore.Parent_OrganizationId	
	and tss.RecordStartDateTime <= s.SubmissionYearEndDate and (tss.RecordEndDateTime >=  s.SubmissionYearStartDate or tss.RecordEndDateTime is null)	
	left join ods.RefK12LeaTitleISupportService srvc on srvc.RefK12LEATitleISupportServiceId = tss.RefK12LEATitleISupportServiceId	


	 drop TABLE #studentOrganizations

END	