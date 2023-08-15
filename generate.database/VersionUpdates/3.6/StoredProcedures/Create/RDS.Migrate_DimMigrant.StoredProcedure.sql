CREATE PROCEDURE [RDS].[Migrate_DimMigrant]
 @studentDates as RDS.StudentDateTableType READONLY
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
--declare     @factTypeCode as varchar(50) = 'immigrant'
--declare     @factTypeCode as varchar(50) = 'mep'

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

	declare @k12StudentRoleId as int
	declare @refParticipationTypeId as int
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select  @refParticipationTypeId = RefParticipationTypeId from ods.RefParticipationType where code = 'MEPParticipation'

	CREATE TABLE #studentOrganizations (
		DimStudentId int,
		PersonId int,
		DimCountDateId int,
		DimSchoolId int,
		DimLeaId int,
		DimSeaId int,
		OrganizationId int,
		LeaOrganizationId int
	)

	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId from RDS.Get_StudentOrganizations(@studentDates,0)

	select	
		s.DimStudentId,
		r.DimSchoolId,
		r.DimLeaId,
		r.DimSeaId,
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
	inner join  #studentOrganizations r
		on s.PersonId = r.PersonId 
		and s.DimCountDateId = r.DimCountDateId
	inner join ods.OrganizationPersonRole opr 
		on opr.PersonId = s.PersonId
		and opr.RoleId = @k12StudentRoleId 
		and opr.OrganizationId = IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId)
		and opr.EntryDate <= s.SubmissionYearEndDate 
		and (opr.ExitDate >=  s.SubmissionYearStartDate or opr.ExitDate is null)
	left join ods.OrganizationPersonRole r2 
		on r2.PersonId = s.PersonId
		and r2.EntryDate <= s.SubmissionYearEndDate 
		and (r2.ExitDate >=  s.SubmissionYearStartDate or opr.ExitDate is null)
	left join ods.OrganizationRelationship ore 
		on r2.OrganizationId = ore.OrganizationId 
		and ore.Parent_OrganizationId = opr.OrganizationId
	left join ods.PersonProgramParticipation ppp 
		on ppp.OrganizationPersonRoleId = r2.OrganizationPersonRoleId 
		and ppp.RefParticipationTypeId = @refParticipationTypeId
	left join ods.ProgramParticipationMigrant ppm 
		on ppm.PersonProgramParticipationId = ppp.PersonProgramParticipationId
	left join ods.K12School k12sch 
		on k12sch.OrganizationId = r.OrganizationId
	left join ods.K12SchoolStatus schStatus 
		on k12sch.K12SchoolId = schStatus.K12SchoolId
	left join ods.RefMepServiceType rmst 
		on rmst.RefMepServiceTypeId = ppm.RefMepServiceTypeId	
	left join ods.K12ProgramOrService prog 
		on prog.OrganizationId = r.OrganizationId
	left join ods.RefMepProjectType projType 
		on projType.RefMepProjectTypeId = prog.RefMepProjectTypeId

	drop TABLE #studentOrganizations
END