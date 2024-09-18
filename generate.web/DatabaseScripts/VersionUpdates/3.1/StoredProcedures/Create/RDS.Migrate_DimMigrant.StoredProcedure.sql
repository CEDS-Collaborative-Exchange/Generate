CREATE PROCEDURE [RDS].[Migrate_DimMigrant]
 @studentDates as RDS.StudentDateTableType READONLY
 AS
 BEGIN


	declare @k12StudentRoleId as int
	declare @refParticipationTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select  @refParticipationTypeId = RefParticipationTypeId from ods.RefParticipationType where code = 'MEPParticipation'


	select	
		s.DimStudentId,
		r.DimSchoolId,
		r.DimLeaId,
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
	inner join (select * from RDS.Get_StudentOrganizations(@studentDates, 0)) r
	on s.PersonId = r.PersonId and s.DimCountDateId = r.DimCountDateId
	inner join ods.OrganizationPersonRole opr on opr.PersonId = s.PersonId
		and opr.RoleId = @k12StudentRoleId and opr.OrganizationId = IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId)
		and opr.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
	left join ods.OrganizationPersonRole r2 on r2.PersonId = s.PersonId
		and r2.EntryDate between s.SubmissionYearStartDate and s.SubmissionYearEndDate
	left join ods.OrganizationRelationship ore on r2.OrganizationId = ore.OrganizationId and ore.Parent_OrganizationId = opr.OrganizationId
	left join ods.PersonProgramParticipation ppp on ppp.OrganizationPersonRoleId = r2.OrganizationPersonRoleId and ppp.RefParticipationTypeId = @refParticipationTypeId
	left join ods.ProgramParticipationMigrant ppm on ppm.PersonProgramParticipationId = ppp.PersonProgramParticipationId
	left join ods.K12School k12sch on k12sch.OrganizationId = r.OrganizationId
	left join ods.K12SchoolStatus schStatus on k12sch.K12SchoolId = schStatus.K12SchoolId
	left join ods.RefMepServiceType rmst on rmst.RefMepServiceTypeId = ppm.RefMepServiceTypeId	
	left join ods.K12ProgramOrService prog on prog.OrganizationId = r.OrganizationId
	left join ods.RefMepProjectType projType on projType.RefMepProjectTypeId = prog.RefMepProjectTypeId


END