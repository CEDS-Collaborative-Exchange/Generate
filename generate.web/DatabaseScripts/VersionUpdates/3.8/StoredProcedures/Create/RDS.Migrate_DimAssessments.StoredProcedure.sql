CREATE PROCEDURE [RDS].[Migrate_DimAssessments]
	@studentDates AS RDS.K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL
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
	--declare     @factTypeCode as varchar(50) = 'submission' --Discipline, Assessments

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

	DECLARE @k12StudentRoleId AS INT
	SELECT @k12StudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Student'

	SELECT 
		  s.DimK12StudentId
		, s.PersonId
		, org.DimLeaID
		, org.DimK12SchoolId
		,org.DimSeaId
		, s.DimCountDateId
		, ISNULL(sub.Code, 'MISSING') AS AssessmentSubjectCode
		, CASE 
			WHEN ISNULL(sub.Code, 'MISSING') =  '00256'  THEN 'ELPASS'
			ELSE ISNULL(cwd.Code, 'MISSING') 
		  END AS AssessmentTypeCode
		, ISNULL(grd.Code, 'MISSING') AS GradeLevelCode
		, CASE
			WHEN par.Code = 'DidNotParticipate' AND ISNULL(rea.Code, 'MISSING') = 'Medical' THEN 'MEDEXEMPT'
			WHEN par.Code = 'DidNotParticipate' AND ISNULL(rea.Code, 'MISSING') = 'PARTELP' THEN 'PARTELP'
			WHEN par.Code IS NULL THEN 'MISSING' 
			WHEN par.Code = 'DidNotParticipate' THEN 'NPART'
			WHEN par.Code = 'Participated' AND ISNULL(cwd.Code, 'MISSING') = 'REGASSWOACC' THEN 'REGPARTWOACC'
			WHEN par.Code = 'Participated' AND ISNULL(cwd.Code, 'MISSING') = 'REGASSWACC' THEN 'REGPARTWACC'
			WHEN par.Code = 'Participated' AND ISNULL(cwd.Code, 'MISSING') = 'ALTASSGRADELVL' THEN 'ALTPARTGRADELVL'
			WHEN par.Code = 'Participated' AND ISNULL(cwd.Code, 'MISSING') = 'ALTASSMODACH' THEN 'ALTPARTMODACH'
			WHEN par.Code = 'Participated' AND ISNULL(cwd.Code, 'MISSING') = 'ALTASSALTACH' THEN 'ALTPARTALTACH'
			ELSE 'MISSING'
		  END AS ParticipationStatusCode
		, ISNULL(lev.Identifier, 'MISSING')
		, CASE
			WHEN reg.StateFullAcademicYear = 1 THEN 'FULLYR'
			WHEN reg.StateFullAcademicYear = 0 THEN 'NFULLYR'
			ELSE 'MISSING'
		  END AS SeaFullYearStatusCode
		, CASE
			WHEN reg.LeaFullAcademicYear = 1 THEN 'FULLYR'
			WHEN reg.LeaFullAcademicYear = 0 THEN 'NFULLYR'
			ELSE 'MISSING'
		  END AS LeaFullYearStatusCode
		, CASE
			WHEN reg.SchoolFullAcademicYear = 1 THEN 'FULLYR'
			WHEN reg.SchoolFullAcademicYear = 0 THEN 'NFULLYR'
			ELSE 'MISSING'
		  END AS SchFullYearStatusCode
		, ISNULL(ael.Code, 'MISSING') AS AssessmentTypeAdministeredToEnglishLearnersCode
		, 1 AS AssessmentCount
	FROM @studentDates s 
	--JOIN dbo.OrganizationPersonRole r 
	--	ON r.PersonId = s.PersonId
	--	AND r.RoleId = @k12StudentRoleId 
	--	AND r.EntryDate <= s.CountDate 
	--	AND (r.ExitDate >= s.CountDate 
	--		OR r.ExitDate IS NULL)
	--	AND (@dataCollectionId IS NULL 
	--		OR r.DataCollectionId = @dataCollectionId)
	JOIN @studentOrganizations org
		ON s.DimK12StudentId = org.DimK12StudentId 
		AND s.DimCountDateId = org.DimCountDateId 
		AND s.PersonId = org.PersonId
		--AND r.OrganizationId = IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId)
	JOIN dbo.AssessmentRegistration reg 
		ON s.PersonId = reg.PersonId 
		AND org.LeaOrganizationId = reg.LeaOrganizationId
		AND (@dataCollectionId IS NULL 
			OR reg.DataCollectionId = @dataCollectionId)
	JOIN dbo.RefGradeLevel grd 
		ON reg.RefGradeLevelWhenAssessedId = grd.RefGradeLevelId
	JOIN dbo.AssessmentAdministration adm 
		ON reg.AssessmentAdministrationId = adm.AssessmentAdministrationId
		AND adm.StartDate BETWEEN s.SessionBeginDate AND s.SessionEndDate
		AND adm.StartDate >=  ISNULL(org.K12SchoolEntryDate, org.LeaEntryDate)
		AND (adm.FinishDate <= ISNULL(org.K12SchoolExitDate, org.LeaExitDate) 
				OR (org.K12SchoolExitDate  IS NULL AND org.LeaExitDate IS NULL)
			)
		AND (@dataCollectionId IS NULL 
			OR adm.DataCollectionId = @dataCollectionId)
	JOIN dbo.Assessment ass 
		ON adm.AssessmentId = ass.AssessmentId
		AND (@dataCollectionId IS NULL 
			OR ass.DataCollectionId = @dataCollectionId)
	JOIN dbo.RefAcademicSubject sub 
		ON ass.RefAcademicSubjectId = sub.RefAcademicSubjectId
	LEFT JOIN dbo.RefAssessmentParticipationIndicator par 
		ON reg.RefAssessmentParticipationIndicatorId = par.RefAssessmentParticipationIndicatorId
	LEFT JOIN dbo.RefAssessmentTypeChildrenWithDisabilities cwd 
		ON ass.RefAssessmentTypeChildrenWithDisabilitiesId = cwd.RefAssessmentTypeChildrenWithDisabilitiesId
	LEFT JOIN dbo.AssessmentResult res 
		ON reg.AssessmentRegistrationId = res.AssessmentRegistrationId
		AND (@dataCollectionId IS NULL 
			OR res.DataCollectionId = @dataCollectionId)
	LEFT JOIN dbo.AssessmentResult_PerformanceLevel per 
		ON res.AssessmentResultId = per.AssessmentResultId
		AND (@dataCollectionId IS NULL 
			OR per.DataCollectionId = @dataCollectionId)
	LEFT JOIN dbo.AssessmentPerformanceLevel lev 
		ON per.AssessmentPerformanceLevelId = lev.AssessmentPerformanceLevelId
		AND (@dataCollectionId IS NULL 
			OR lev.DataCollectionId = @dataCollectionId)
	LEFT JOIN dbo.RefAssessmentReasonNotCompleting rea 
		ON reg.RefAssessmentReasonNotCompletingId = rea.RefAssessmentReasonNotCompletingId
	LEFT JOIN dbo.RefAssessmentTypeAdministeredToEnglishLearners ael 
		ON ass.RefAssessmentTypeAdministeredToEnglishLearnersId = ael.RefAssessmentTypeAdministeredToEnglishLearnersId
	WHERE s.DimK12StudentId <> -1
	

END