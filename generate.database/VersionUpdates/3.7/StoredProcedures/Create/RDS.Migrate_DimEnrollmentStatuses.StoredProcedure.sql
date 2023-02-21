CREATE PROCEDURE [RDS].[Migrate_DimEnrollmentStatuses]
	@studentDates as StudentDateTableType READONLY
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
--declare     @factTypeCode as varchar(50) = 'childcount'
--declare     @factTypeCode as varchar(50) = 'chronic'
--declare     @factTypeCode as varchar(50) = 'cte'
--declare     @factTypeCode as varchar(50) = 'datapopulation'
--declare     @factTypeCode as varchar(50) = 'dropout'
--declare     @factTypeCode as varchar(50) = 'grad'
--declare     @factTypeCode as varchar(50) = 'gradrate'
--declare     @factTypeCode as varchar(50) = 'homeless'
--declare     @factTypeCode as varchar(50) = 'hsgradenroll'
--declare     @factTypeCode as varchar(50) = 'immigrant'
--declare     @factTypeCode as varchar(50) = 'membership'
--declare     @factTypeCode as varchar(50) = 'mep'
--declare     @factTypeCode as varchar(50) = 'nord'
--declare     @factTypeCode as varchar(50) = 'other'
--declare     @factTypeCode as varchar(50) = 'specedexit'
--declare     @factTypeCode as varchar(50) = 'submission' --Discipline, Assessments
--declare     @factTypeCode as varchar(50) = 'titleI'
--declare     @factTypeCode as varchar(50) = 'titleIIIELOct'
--declare     @factTypeCode as varchar(50) = 'titleIIIELSY'

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
	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'

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
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId from RDS.Get_StudentOrganizations(@studentDates, 0)


	select s.DimStudentId,org.DimSchoolId,org.DimLeaId,org.DimSeaId,
	s.PersonId,s.DimCountDateId, isnull(refExitType.Code, 'MISSING') as ExitOrWithdrawalCode
	from @studentDates s
	inner join ods.OrganizationPersonRole r 
		on r.PersonId = s.PersonId
		and r.RoleId = @k12StudentRoleId 
		and r.EntryDate <= s.SubmissionYearDate 
		and (r.ExitDate >= s.SubmissionYearDate or r.ExitDate is null)
	inner join #studentOrganizations org 
		on s.PersonId = org.PersonId 
		and r.OrganizationId = IIF(org.OrganizationId > 0 , org.OrganizationId, org.LeaOrganizationId)
	inner join ods.K12StudentEnrollment enr 
		on enr.OrganizationPersonRoleId = r.OrganizationPersonRoleId 
		and s.SubmissionYearDate between ISNULL(enr.RecordStartDateTime, s.SubmissionYearDate) 
		and ISNULL(enr.RecordEndDateTime, GETDATE())
	left outer join ods.RefExitOrWithdrawalType refExitType 
		on enr.RefExitOrWithdrawalTypeId = refExitType.RefExitOrWithdrawalTypeId

	drop TABLE #studentOrganizations
			
END