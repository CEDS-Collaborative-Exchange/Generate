CREATE PROCEDURE [RDS].[Migrate_DimAssessmentStatuses]
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
	DECLARE @schoolOrganizationTypeId AS INT
	SELECT @k12StudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Student'
	SELECT @schoolOrganizationTypeId = RefOrganizationTypeId FROM dbo.RefOrganizationType WHERE code = 'K12School'

	CREATE TABLE #firstAssessed
	(
		PersonId INT,
		DimCountDateId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		FirstAssessedDate date
	)

	CREATE TABLE #progressLevel
	(
		PersonId INT,
		DimCountDateId INT,
		DimK12SchoolId INT,
		DimLeaId INT,
		DimSeaId INT,
		AcademicSubject VARCHAR(100),
		ProgressLevel VARCHAR(100)
	)





	INSERT INTO #firstAssessed (
		  PersonId
		, DimK12SchoolId
		, DimLeaId
		, DimSeaId
		, DimCountDateId
		, FirstAssessedDate
		)
	SELECT 
		  reg.PersonId
		, org.DimK12SchoolId
		, org.DimLeaId
		, org.DimSeaId
		, org.DimCountDateId
		, MIN(adm.StartDate) AS 'FirstAssessedDate'
        FROM @studentDates s
		JOIN @studentOrganizations org
			ON s.DimK12StudentId = org.DimK12StudentId
			AND s.DimCountDateId = org.DimCountDateId
        JOIN dbo.AssessmentRegistration reg 
			ON s.PersonId = reg.PersonId 
			AND IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId) = ISNULL(reg.SchoolOrganizationId,reg.LeaOrganizationId)
			AND (@dataCollectionId IS NULL 
				OR reg.DataCollectionId = @dataCollectionId)
            JOIN dbo.RefGradeLevel grd 
				ON reg.RefGradeLevelWhenAssessedId = grd.RefGradeLevelId
            JOIN dbo.AssessmentAdministration adm 
				ON reg.AssessmentAdministrationId = adm.AssessmentAdministrationId        
            	AND (@dataCollectionId IS NULL 
					OR adm.DataCollectionId = @dataCollectionId)
			JOIN dbo.Assessment ass 
				ON adm.AssessmentId = ass.AssessmentId
            	AND (@dataCollectionId IS NULL 
					OR ass.DataCollectionId = @dataCollectionId)
			JOIN   (SELECT RefAcademicSubjectId 
					FROM dbo.RefAcademicSubject 
					WHERE Code = '00256') sub 
				ON ass.RefAcademicSubjectId = sub.RefAcademicSubjectId
            JOIN dbo.OrganizationCalendar oc 
				ON oc.OrganizationId = ISNULL(reg.SchoolOrganizationId,reg.LeaOrganizationId)
				AND (@dataCollectionId IS NULL 
					OR oc.DataCollectionId = @dataCollectionId)
			JOIN dbo.OrganizationCalendarSession ocs 
				ON oc.OrganizationCalendarId = ocs.OrganizationCalendarId    
				AND adm.StartDate BETWEEN ocs.BeginDate AND ocs.EndDate
				AND (@dataCollectionId IS NULL 
					OR ocs.DataCollectionId = @dataCollectionId)
            GROUP BY reg.PersonId, org.DimK12SchoolId, org.DimLeaId, org.DimSeaId, org.DimCountDateId         
				
	 INSERT INTO #progressLevel (
		  PersonId
		, DimK12SchoolId
		, DimLeaId
		, DimSeaId
		, DimCountDateId
		, AcademicSubject
		, ProgressLevel
		)            
	SELECT 
		  reg.PersonId
		, org.DimK12SchoolId
		, org.DimLeaId
		, org.DimSeaId
		, org.DimCountDateId
		, sub.Code AS AcademicSubject
		, levels.Code AS ProgressLevel
	FROM @studentDates s
	JOIN dbo.OrganizationPersonRole r 
		ON r.PersonId = s.PersonId
		AND r.EntryDate <= s.CountDate 
		AND (r.ExitDate >= s.CountDate 
			OR r.ExitDate IS NULL)
		AND (@dataCollectionId IS NULL 
			OR r.DataCollectionId = @dataCollectionId)
	JOIN @studentOrganizations org 
		ON s.DimK12StudentId = org.DimK12StudentId 
		AND r.OrganizationId = IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId)
	JOIN dbo.OrganizationRelationship orp 
		ON  r.OrganizationId = orp.Parent_OrganizationId
		AND (@dataCollectionId IS NULL 
			OR orp.DataCollectionId = @dataCollectionId)
	JOIN dbo.OrganizationPersonRole r2 
		ON r2.OrganizationId = orp.OrganizationId
		AND (@dataCollectionId IS NULL 
			OR r2.DataCollectionId = @dataCollectionId)
	JOIN dbo.PersonProgramParticipation ppp 
		ON r2.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId 
		AND (@dataCollectionId IS NULL 
			OR ppp.DataCollectionId = @dataCollectionId)
	JOIN dbo.ProgramParticipationNeglectedProgressLevel ppnProgress 
		ON ppp.PersonProgramParticipationId = ppnProgress.PersonProgramParticipationId
		AND (@dataCollectionId IS NULL 
			OR ppnProgress.DataCollectionId = @dataCollectionId)
	JOIN dbo.RefProgressLevel levels 
		ON levels.RefProgressLevelId = ppnProgress.RefProgressLevelId
	JOIN dbo.AssessmentRegistration reg 
		ON r.PersonId = reg.PersonId 
		AND r.OrganizationId = ISNULL(reg.SchoolOrganizationId,reg.LeaOrganizationId)  
		AND (@dataCollectionId IS NULL 
			OR reg.DataCollectionId = @dataCollectionId)
	JOIN dbo.RefGradeLevel grd 
		ON reg.RefGradeLevelWhenAssessedId = grd.RefGradeLevelId
	JOIN dbo.AssessmentAdministration adm 
		ON reg.AssessmentAdministrationId = adm.AssessmentAdministrationId        
		AND (@dataCollectionId IS NULL 
			OR adm.DataCollectionId = @dataCollectionId)
	JOIN dbo.RefAcademicSubject sub 
		ON ppnProgress.RefAcademicSubjectId = sub.RefAcademicSubjectId
	JOIN dbo.OrganizationCalendar oc 
		ON oc.OrganizationId = r.OrganizationId
		AND (@dataCollectionId IS NULL 
			OR oc.DataCollectionId = @dataCollectionId)
	JOIN dbo.OrganizationCalendarSession ocs 
		ON oc.OrganizationCalendarId = ocs.OrganizationCalendarId 
		AND adm.StartDate BETWEEN ocs.BeginDate AND ocs.EndDate
		AND (@dataCollectionId IS NULL 
			OR ocs.DataCollectionId = @dataCollectionId)
				
	SELECT 		
		  s.DimK12StudentId
		, IIF(aft.DimK12SchoolId > 0, aft.DimK12SchoolId, progress.DimK12SchoolId) AS DimK12SchoolId	
		, IIF(aft.DimLeaId > 0, aft.DimLeaId, progress.DimLeaId) AS DimLeaId
		, IIF(aft.DimSeaId > 0, aft.DimSeaId, progress.DimSeaId) AS DimSeaId
		, s.PersonId
		, s.DimCountDateId
		, CASE 
			WHEN aft.FirstAssessedDate IS NOT NULL 
				AND aft.FirstAssessedDate BETWEEN s.SessionBeginDate AND s.SessionEndDate 
				THEN 'FIRSTASSESS' 
			ELSE 'MISSING'	
		  END AS 'FirstAssessed'
		, AcademicSubject
		, ISNULL(progress.ProgressLevel,'MISSING') AS ProgressLevel
	FROM @studentDates s 
	LEFT JOIN #firstAssessed aft ON aft.PersonId = s.PersonId   
	LEFT JOIN #progressLevel progress ON progress.PersonId = s.PersonId

	DROP TABLE #firstAssessed
	DROP TABLE #progressLevel
				
END               