CREATE PROCEDURE [RDS].[Migrate_DimAges]
	@studentDates as RDS.K12StudentDateTableType READONLY,
	@factTypeCode as varchar(50) = 'submission',
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId INT = NULL
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
--declare     @factTypeCode as varchar(50) = 'grad'
--declare     @factTypeCode as varchar(50) = 'homeless'
--declare     @factTypeCode as varchar(50) = 'nord'
--declare     @factTypeCode as varchar(50) = 'other'
--declare     @factTypeCode as varchar(50) = 'specedexit'
--declare     @factTypeCode as varchar(50) = 'sppapr'
--declare     @factTypeCode as varchar(50) = 'submission' --Discipline, Assessments

--insert into @studentDates
--(
--     DimK12StudentId,
--     PersonId,
--     DimCountDateId,
--     SessionBeginDate,
--     [Year],
--     SubmissionYearStartDate,
--     SubmissionYearEndDate
--)
--exec rds.Migrate_DimDates_Students @factTypeCode, @migrationType, @selectedDate
/*****************************
End of Debugging code 
*****************************/

	declare @specialEdProgramTypeId as int
	select @specialEdProgramTypeId = RefProgramTypeId from dbo.RefProgramType where code = '04888'
	
	if @factTypeCode IN ('specedexit')
	BEGIN

		CREATE TABLE #studentSpecEdExit (
			DimK12StudentId int,
			PersonId int,
			Organizationid int,
			DimCountDateId int,
			ChildCountDate datetime,
			Exitdate datetime
		)

		insert into #studentSpecEdExit(DimK12StudentId, PersonId, Organizationid, DimCountDateId, ChildCountDate, Exitdate)
		select 
			s.DimK12StudentId
			, s.PersonId
			, r.K12SchoolOrganizationId
			, s.DimCountDateId
			, case 
				when s.CountDate <= max(p.SpecialEducationServicesExitDate)
				then s.CountDate 
			    else DATEADD(year, -1, s.CountDate) 
			  end as ChildCountDate
			, max(p.SpecialEducationServicesExitDate)
		from @studentDates s
		inner join @studentOrganizations r	
			on s.DimK12StudentId = r.DimK12StudentId 
			and s.DimCountDateId = r.DimCountDateId
		inner join dbo.OrganizationRelationship op 
			on op.Parent_OrganizationId = IIF(r.K12SchoolOrganizationId > 0 , r.K12SchoolOrganizationId, r.LeaOrganizationId)
		inner join dbo.OrganizationPersonRole rp 
			on rp.OrganizationId = op.OrganizationId 
			and rp.PersonId = r.PersonId
			and rp.EntryDate <= s.SessionEndDate 
			and (rp.ExitDate >=  s.SessionBeginDate or rp.ExitDate is null)
			and (@dataCollectionId IS NULL
				OR rp.DataCollectionId = @dataCollectionId)
		inner join 	dbo.OrganizationProgramType t 
			on t.OrganizationId = op.OrganizationId 
			and t.RefProgramTypeId = @specialEdProgramTypeId
		inner join dbo.PersonProgramParticipation ppp 
			on rp.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId 
		inner join dbo.ProgramParticipationSpecialEducation p 
			on p.PersonProgramParticipationId = ppp.PersonProgramParticipationId
		where p.SpecialEducationServicesExitDate is not null
		group by s.DimK12StudentId, s.PersonId, r.K12SchoolOrganizationId, s.DimCountDateId, s.CountDate
	
		select 
			s.DimK12StudentId,
			org.PersonId,
			org.DimLeaId,
			org.DimK12SchoolId,
			org.DimSeaId,
			spedexit.DimCountDateId,
			[RDS].[Get_Age](s.BirthDate, spedexit.ChildCountDate) as AgeCode,
			spedexit.Exitdate
		from rds.DimK12Students s
		inner join #studentSpecEdExit spedexit 
			on s.DimK12StudentId = spedexit.DimK12StudentId 
		inner join @studentOrganizations org 
			on spedexit.OrganizationId = IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId)
			and org.PersonId = spedexit.PersonId


		drop TABLE #studentSpecEdExit

	END
	ELSE IF @factTypeCode IN ('childcount', 'homeless')
	BEGIN
		
		select 
			s.DimK12StudentId
			, d.PersonId
			, d.DimCountDateId
	 		, [RDS].[Get_Age](s.BirthDate, d.CountDate) as AgeCode
		from rds.DimK12Students s
		inner join @studentDates d 
			on s.DimK12StudentId = d.DimK12StudentId

	END
	ELSE
	BEGIN
		
		select 
			s.DimK12StudentId
			, d.PersonId
			, d.DimCountDateId
	 		, [RDS].[Get_Age](s.BirthDate, d.SessionBeginDate) as AgeCode
		from rds.DimK12Students s
		inner join @studentDates d 
			on s.DimK12StudentId = d.DimK12StudentId

	END

END