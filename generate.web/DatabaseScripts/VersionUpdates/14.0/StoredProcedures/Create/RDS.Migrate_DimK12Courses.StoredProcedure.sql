CREATE PROCEDURE [RDS].[Migrate_DimK12Courses]
	@studentDates AS RDS.K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT
AS
BEGIN

    DECLARE @k12StudentRoleId INT, @courseOrganizationType INT, @courseSectionOrganizationType INT 
	SELECT @k12StudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Student'
	SELECT @courseOrganizationType = Staging.GetOrganizationTypeId('Course', '001156')
	SELECT @courseSectionOrganizationType = Staging.GetOrganizationTypeId('CourseSection', '001156')
	

		;with OrgRelationshipForCourse as
			(Select distinct
				oreCS.OrganizationId as CourseSectionOrgId, odCS.Name as CoureSectionName,
				oreC.OrganizationId as CourseOrgId, odC.Name as CourseName,
				oreC.Parent_OrganizationId as EntOrgId, odC.DataCollectionId
			FROM  dbo.OrganizationDetail odCS
			JOIN dbo.OrganizationRelationship oreCS
				ON odCS.OrganizationId = oreCS.OrganizationId
					AND odCS.DataCollectionId = @dataCollectionId
					AND odCS.RefOrganizationTypeId = @courseSectionOrganizationType
			JOIN dbo.OrganizationRelationship oreC
				ON oreC.OrganizationId = oreCS.Parent_OrganizationId 
			JOIN dbo.OrganizationDetail odC
				ON oreC.OrganizationId = odC.OrganizationId
					AND odC.DataCollectionId = @dataCollectionId
					AND odC.RefOrganizationTypeId = @courseOrganizationType
			)
		SELECT DISTINCT
			  s.DimK12StudentId
			, o.DimK12SchoolId
			, o.DimLeaId
			, d.PersonId
			, d.DimCountDateId
			, dkc.DimK12CourseId
			, dkc.CourseTitle
			, ISNULL(AcadSY.DimSchoolYearId,-1) as DimSchoolYearId
			, r.EntryDate
			, r.ExitDate
		FROM @studentDates d
		JOIN @studentOrganizations s
			ON s.DimK12StudentId = d.DimK12StudentId 
			AND s.PersonId = d.PersonId
		JOIN dbo.OrganizationPersonRole r 
			ON r.PersonId = d.PersonId 
			AND r.RoleId = @k12StudentRoleId
			AND (@dataCollectionId IS NULL 
				OR r.DataCollectionId = @dataCollectionId)	
			AND (@loadAllForDataCollection = 1 
				OR r.EntryDate <= d.SessionEndDate AND (r.ExitDate >= d.SessionBeginDate OR r.ExitDate IS NULL))	
		JOIN OrgRelationshipForCourse cte
			ON r.OrganizationId = cte.CourseSectionOrgId		
		JOIN @studentOrganizations o 
			ON d.DimK12StudentId = o.DimK12StudentId 
			AND d.DimCountDateId = o.DimCountDateId 
			AND s.PersonId = o.PersonId
			AND cte.EntOrgId = IIF(o.K12SchoolOrganizationId > 0 , o.K12SchoolOrganizationId, o.LeaOrganizationId)
		JOIN (Select odC.OrganizationId,odC.Name From dbo.OrganizationDetail odC 
				Where odC.RefOrganizationTypeId = @courseOrganizationType and odC.DataCollectionId = @dataCollectionId 
					Group by odC.OrganizationId,odC.Name) odC
			ON cte.CourseOrgId = odC.OrganizationId
		JOIN dbo.Course c
			ON odC.OrganizationId = c.OrganizationId
		JOIN dbo.K12Course kc
			ON c.CourseId = kc.CourseId
		JOIN rds.DimK12Courses dkc
			ON odC.Name = dkc.CourseTitle
		JOIN rds.DimScedCodes sc
			ON kc.SCEDCourseCode = sc.ScedCourseCode
		LEFT JOIN rds.DimSchoolYears AcadSY --Including the School Years derived from Course Start/End date
			ON r.EntryDate <= AcadSY.SessionEndDate AND (r.ExitDate >= AcadSY.SessionBeginDate OR r.ExitDate IS NULL)

END