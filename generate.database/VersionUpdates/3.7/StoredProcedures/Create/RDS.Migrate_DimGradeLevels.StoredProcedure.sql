create procedure [RDS].[Migrate_DimGradeLevels]
	@studentDates as StudentDateTableType READONLY,
    @useCutOffDate AS BIT
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
		DimSeaId int,
		OrganizationId int,
		LeaOrganizationId int
	)

	
	insert into #studentOrganizations(DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId)
	select DimStudentId, PersonId, DimCountDateId, DimSchoolId, DimLeaId, DimSeaId, OrganizationId, LeaOrganizationId 
	from RDS.Get_StudentOrganizations(@studentDates, 0)

	select         
		s.DimStudentId,
		o.DimSchoolId,
		o.DimLeaId,
		o.DimSeaId,
        d.PersonId,
        d.DimCountDateId,
        isnull(grd.Code, 'MISSING')
	from rds.DimStudents s 
	inner join @studentDates d 
		on s.DimStudentId = d.DimStudentId
	inner join ods.OrganizationPersonRole r 
		on r.PersonId = d.PersonId 
		and r.RoleId = @k12StudentRoleId
        and r.EntryDate <=  case
								WHEN @useCutOffDate = 0 THEN
									d.SubmissionYearEndDate
								ELSE
									d.SubmissionYearDate
							END
        and ISNULL(r.ExitDate, GETDATE()) >= CASE
												WHEN @useCutOffDate = 0 THEN
													d.SubmissionYearStartDate
												ELSE
													d.SubmissionYearDate
											END
	inner join #studentOrganizations o
		on d.DimStudentId = o.DimStudentId 
		and d.DimCountDateId = o.DimCountDateId 
		and r.OrganizationId = IIF(o.OrganizationId > 0 , o.OrganizationId, o.LeaOrganizationId)
	inner join [ODS].[K12StudentEnrollment] enr 
		on enr.OrganizationPersonRoleId = r.OrganizationPersonRoleId
        and enr.RecordStartDateTime <=  case
								WHEN @useCutOffDate = 0 THEN
									d.SubmissionYearEndDate
								ELSE
									d.SubmissionYearDate
							END
        and ISNULL(enr.RecordEndDateTime, GETDATE()) >= CASE
                                                            WHEN @useCutOffDate = 0 THEN
                                                                d.SubmissionYearStartDate
                                                            ELSE
                                                                d.SubmissionYearDate
                                                        END
	inner join ods.RefGradeLevel grd 
		on enr.RefEntryGradeLevelId = grd.RefGradeLevelId
	where s.DimStudentId <> -1
	order by s.DimStudentId
	
		drop TABLE #studentOrganizations
	

END
