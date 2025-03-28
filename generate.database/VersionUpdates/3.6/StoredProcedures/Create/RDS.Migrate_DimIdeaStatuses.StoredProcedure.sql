CREATE PROCEDURE [RDS].[Migrate_DimIdeaStatuses]
	@studentDates as StudentDateTableType READONLY,
	@factTypeCode as varchar(50),
	@useCutOffDate as bit

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
--declare     @factTypeCode as varchar(50) = 'mep'
--declare     @factTypeCode as varchar(50) = 'nord'
--declare     @factTypeCode as varchar(50) = 'other'
--declare     @factTypeCode as varchar(50) = 'specedexit'
--declare     @factTypeCode as varchar(50) = 'sppapr'
--declare     @factTypeCode as varchar(50) = 'submission' --Discipline, Assessments
--declare     @factTypeCode as varchar(50) = 'titleI'
--declare     @factTypeCode as varchar(50) = 'titleIIIELOct'

----variable for UseCutOffDate, uncomment the appropriate one
----If you're working on     'childcount','titleIIIELOct'
       --declare @useCutOffDate as bit = 1
----otherwise
       --declare @useCutOffDate as bit = 0

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

	declare @k12StudentRoleId as int, @schoolOrganizationTypeId as int, @specialEdProgramTypeId as int

	select @k12StudentRoleId = RoleId from ods.[Role] where Name = 'K12 Student'
	select @schoolOrganizationTypeId = RefOrganizationTypeId from ods.RefOrganizationType where code = 'K12School'
	select @specialEdProgramTypeId = RefProgramTypeId from ods.RefProgramType where code = '04888'

	declare @ideaStatusTypeId as int
	select @ideaStatusTypeId = RefPersonStatusTypeId from ods.RefPersonStatusType where code = 'IDEA'

	declare @ctePerkDisab as varchar(50)

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
	from RDS.Get_StudentOrganizations(@studentDates,@useCutOffDate)
			
	select @ctePerkDisab = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q 
		on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CTEPERKDISAB'

	declare @isADADisability as bit
	set @isADADisability = 0

	IF @factTypeCode = 'cte' AND @ctePerkDisab = 'ADA Disability'
	BEGIN
		set @isADADisability = 1
	END

	select distinct
		s.DimStudentId,
		r.DimSchoolId,
		r.DimLeaId,
		r.DimSeaId,
		s.PersonId,
		s.DimCountDateId,
		case when @useCutOffDate = 1 then 
		case
			when statusIdea.StatusValue is null then 'MISSING'
			when s.SubmissionYearDate BETWEEN statusIdea.StatusStartDate AND ISNULL(statusIdea.StatusEndDate, GETDATE())
				then
					case 
						when statusIdea.StatusValue = 1 then 'IDEA'
						else 'MISSING'
					end
			else 'MISSING' end
		else
		case
			when statusIdea.StatusValue is null then 'MISSING'
			when statusIdea.StatusStartDate <= s.SubmissionYearEndDate 
			and ISNULL(statusIdea.StatusEndDate, GETDATE()) >= s.SubmissionYearStartDate
			then
					case 
						when statusIdea.StatusValue = 1 then 'IDEA'
						else 'MISSING'
					end
			else 'MISSING' end
		end as IDEAIndicator,
		case when @isADADisability = 1 then IIF(pd.DisabilityStatus = 1, isnull(dt.Code, 'MISSING'),'MISSING')
			 else isnull(dt.Code, 'MISSING') end as DisabilityCode, 
		isnull(e.Code, isnull(sa.Code, 'MISSING')) as EducEnvCode,
		isnull(exitReason.Code, 'MISSING') as BasisOfExitCode,
		case when @factTypeCode = 'specedexit' then p.SpecialEducationServicesExitDate else NULL end as SpecialEducationServicesExitDate
	from @studentDates s
	inner join #studentOrganizations r
		on s.PersonId = r.PersonId 
		and s.DimCountDateId = r.DimCountDateId
	inner join ods.OrganizationRelationship ore 
		on IIF(r.OrganizationId > 0 , r.OrganizationId, r.LeaOrganizationId) = ore.Parent_OrganizationId
	inner join ods.OrganizationPersonRole rp 
		on rp.PersonId = s.PersonId
		and rp.EntryDate <= s.SubmissionYearEndDate 
		and (rp.ExitDate >=  s.SubmissionYearStartDate or rp.ExitDate is null)
		and ore.OrganizationId = rp.OrganizationId
	inner join 	ods.OrganizationProgramType t 
		on t.OrganizationId = rp.OrganizationId 
		and t.RefProgramTypeId = @specialEdProgramTypeId
	left outer join ods.PersonDisability pd 
		on pd.PersonId = S.PersonId
		and	ISNULL(pd.RecordStartDateTime, S.SubmissionYearDate) <= 
			case
				when @useCutOffDate = 0 then S.SubmissionYearEndDate
				else S.SubmissionYearDate
			end 
		and 
			ISNULL(pd.RecordEndDateTime, GETDATE()) >=
			case
				when @useCutOffDate = 0 then S.SubmissionYearStartDate
				else S.SubmissionYearDate
			end
	left join ods.RefDisabilityType dt 
		on dt.RefDisabilityTypeId = pd.PrimaryDisabilityTypeId
	left join ods.PersonProgramParticipation ppp 
		on rp.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId 
	left join ods.ProgramParticipationSpecialEducation p 
		on p.PersonProgramParticipationId = ppp.PersonProgramParticipationId
	left join ods.RefIDEAEducationalEnvironmentEC e 
		on e.RefIDEAEducationalEnvironmentECId = p.RefIDEAEducationalEnvironmentECId
	left join ods.RefIDEAEducationalEnvironmentSchoolAge sa 
		on sa.RefIDESEducationalEnvironmentSchoolAge = p.RefIDEAEdEnvironmentSchoolAgeId
	left join ods.RefSpecialEducationExitReason exitReason 
		on p.RefSpecialEducationExitReasonId = exitReason.RefSpecialEducationExitReasonId
	left outer join ods.PersonStatus statusIdea 
		on s.PersonId = statusIdea.PersonId
		and statusIdea.RefPersonStatusTypeId = @ideaStatusTypeId

	 drop TABLE #studentOrganizations

END
