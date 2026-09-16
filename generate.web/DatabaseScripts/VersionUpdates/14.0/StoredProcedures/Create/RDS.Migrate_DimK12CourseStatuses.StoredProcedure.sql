CREATE PROCEDURE [RDS].[Migrate_DimK12CourseStatuses]
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
	From dbo.OrganizationDetail odCS
		JOIN dbo.OrganizationRelationship oreCS
			ON odCS.OrganizationId = oreCS.OrganizationId
				AND odCS.DataCollectionId = @dataCollectionId
				AND odCS.RefOrganizationTypeId = @courseSectionOrganizationType
		JOIN dbo.OrganizationRelationship oreC
			ON oreC.OrganizationId = oreCS.Parent_OrganizationId 
		JOIN dbo.OrganizationDetail odC
			ON oreC.OrganizationId = odC.OrganizationId
				AND odC.DataCollectionId = @dataCollectionId
				AND odC.RefOrganizationTypeId = @courseOrganizationType)
	
	SELECT DISTINCT
		  s.DimK12StudentId
		, o.DimK12SchoolId
		, o.DimLeaId
        , d.PersonId
        , d.DimCountDateId
		, dkc.DimK12CourseId
		, dkc.CourseTitle
		, cs.DimK12CourseStatusId
		, cs.CourseLevelCharacteristicCode
	FROM @studentDates d
	JOIN @studentOrganizations s
		ON s.DimK12StudentId = d.DimK12StudentId 
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
	JOIN dbo.RefCourseLevelCharacteristic clc
		ON c.RefCourseLevelCharacteristicsId = clc.RefCourseLevelCharacteristicId	
	JOIN rds.DimK12Courses dkc
		ON odC.Name = dkc.CourseTitle
	JOIN rds.DimK12CourseStatuses cs
		ON clc.Code = cs.CourseLevelCharacteristicCode

END