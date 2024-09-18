



CREATE PROCEDURE [RDS].[Migrate_DimMigrant]
 @studentDates as RDS.StudentDateTableType READONLY
 AS
 BEGIN


	declare @k12StudentRoleId as int
	declare @schoolOrganizationTypeId as int
	declare @refParticipationTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'
	select  @refParticipationTypeId = RefParticipationTypeId from ods.RefParticipationType where code = 'MEPParticipation'


	select	
		s.DimStudentId,
		sch.DimSchoolId,
		s.PersonId,	
		s.DimCountDateId,		
		case when ppm.ContinuationOfServicesStatus is null then 'MISSING'
			 when ppm.ContinuationOfServicesStatus = 1 then 'CONTINUED'
			 else 'MISSING'
		end as 'ContinuationOfServiceStatus',
		case when ppm.PrioritizedForServices is null then 'MISSING'
			 when ppm.PrioritizedForServices = 1 then 'PS'
			 else 'MISSING'
		end as MigrantPriorityForServices,
		rmst.Code as 'MepServiceTypeCode',
		case when schStatus.ConsolidatedMepFundsStatus = 1 THEN 'YES'
			when schStatus.ConsolidatedMepFundsStatus = 0 then 'NO'
			when schStatus.ConsolidatedMepFundsStatus  is null then 'MISSING'
		end as 'MepFundStatus',
		case when projType.Code = 'SchoolDay' THEN 'MEPRSYDAY'
			 when projType.Code = 'ExtendedDay' THEN 'MEPRSYWEEK'
			 when projType.Code = 'SummerIntersession' THEN 'MEPSUM'
			 when projType.Code = 'YearRound' THEN 'MEPYRP'
			 when projType.Code is null THEN 'MISSING'
			 else 'MISSING'
		end as 'MepEnrollmentType'
	from @studentDates s
	inner join ods.OrganizationPersonRole r on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId
		and r.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
	inner join ods.OrganizationDetail o on o.OrganizationId = r.OrganizationId
		and o.RefOrganizationTypeId = @schoolOrganizationTypeId
	inner join rds.DimSchools sch on sch.SchoolOrganizationId = o.OrganizationId
	inner join ods.K12School k12sch on o.OrganizationId = k12sch.OrganizationId
	join ods.OrganizationPersonRole r2 on r2.PersonId = s.PersonId
		and r2.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
	join ods.OrganizationRelationship ore on r2.OrganizationId = ore.OrganizationId and ore.Parent_OrganizationId = r.OrganizationId
	join ods.PersonProgramParticipation ppp on ppp.OrganizationPersonRoleId = r2.OrganizationPersonRoleId and ppp.RefParticipationTypeId = @refParticipationTypeId
	left join ods.ProgramParticipationMigrant ppm on ppm.PersonProgramParticipationId = ppp.PersonProgramParticipationId
	left join ods.K12SchoolStatus schStatus on k12sch.K12SchoolId = schStatus.K12SchoolId
	left join ods.RefMepServiceType rmst on rmst.RefMepServiceTypeId = ppm.RefMepServiceTypeId	
	left join ods.K12ProgramOrService prog on prog.OrganizationId = o.OrganizationId
	left join ods.RefMepProjectType projType on projType.RefMepProjectTypeId = prog.RefMepProjectTypeId


END

