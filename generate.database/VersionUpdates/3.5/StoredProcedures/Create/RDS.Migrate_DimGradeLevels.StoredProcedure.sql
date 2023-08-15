CREATE PROCEDURE [RDS].[Migrate_DimGradeLevels]
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
--declare     @factTypeCode as varchar(50) = 'datapopulation'
--declare     @factTypeCode as varchar(50) = 'dropout'
--declare     @factTypeCode as varchar(50) = 'homeless'
--declare     @factTypeCode as varchar(50) = 'membership'
--declare     @factTypeCode as varchar(50) = 'mep'
--declare     @factTypeCode as varchar(50) = 'submission' --Discipline, Assessments
--declare     @factTypeCode as varchar(50) = 'titleI'
--declare     @factTypeCode as varchar(50) = 'titleIIIELOct'

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
		OrganizationId int,
		LeaOrganizationId int
	)

	
	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, OrganizationId, LeaOrganizationId from RDS.Get_StudentOrganizations(@studentDates, 0)

	select         
		s.DimStudentId,
		o.DimSchoolId,
		o.DimLeaId,
        d.PersonId,
        d.DimCountDateId,
        isnull(grd.Code, 'MISSING')
	from rds.DimStudents s 
	inner join @studentDates d 
		on s.DimStudentId = d.DimStudentId
	inner join ods.OrganizationPersonRole r 
		on r.PersonId = d.PersonId 
		and r.RoleId = @k12StudentRoleId
		and r.EntryDate <= d.SubmissionYearDate 
		and (r.ExitDate >= d.SubmissionYearDate or r.ExitDate is null)
	inner join #studentOrganizations o
		on d.DimStudentId = o.DimStudentId 
		and d.DimCountDateId = o.DimCountDateId 
		and r.OrganizationId = IIF(o.OrganizationId > 0 , o.OrganizationId, o.LeaOrganizationId)
	inner join [ODS].[K12StudentEnrollment] enr 
		on enr.OrganizationPersonRoleId = r.OrganizationPersonRoleId
		and d.SubmissionYearDate between ISNULL(enr.RecordStartDateTime, d.SubmissionYearDate) 
		and ISNULL(enr.RecordEndDateTime, GETDATE())
	inner join ods.RefGradeLevel grd 
		on enr.RefEntryGradeLevelId = grd.RefGradeLevelId
	inner join ods.RefGradeLevelType glt 
		on grd.RefGradeLevelTypeId = glt.RefGradeLevelTypeId
		and glt.Code = '000100'
	where s.DimStudentId <> -1
	order by s.DimStudentId
	
		drop TABLE #studentOrganizations
	

END
