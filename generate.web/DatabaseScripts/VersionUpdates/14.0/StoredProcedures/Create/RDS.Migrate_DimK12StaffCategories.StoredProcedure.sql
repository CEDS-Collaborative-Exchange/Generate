CREATE PROCEDURE [RDS].[Migrate_DimK12StaffCategories]
	@staffDates AS K12StaffDateTableType READONLY,
	@staffOrganizations AS K12StaffOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT = 0
AS
BEGIN

	DECLARE @k12PersonnelRoleId AS INT
	SELECT @k12PersonnelRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Personnel'
	
	SELECT 
		s.DimK12StaffId
		, org.DimK12SchoolId
		, org.DimLeaId
		, org.DimSeaId
		, s.PersonId
		, s.DimCountDateId		
		, ISNULL(staffCat.Code, 'MISSING') AS StaffCategorySpecialCode
		, ISNULL(classif.Code, 'MISSING') AS StaffCategoryCCD
		, ISNULL(sTitle.Code, 'MISSING') AS StaffCategoryTitle1Code
		, staff.FullTimeEquivalency
	FROM @staffDates s
    JOIN @staffOrganizations org
        ON s.PersonId = org.PersonId
    JOIN dbo.OrganizationPersonRole r
        ON r.PersonId = s.PersonId
        AND r.OrganizationId = IIF(org.K12SchoolOrganizationId > 0, org.K12SchoolOrganizationId, org.LeaOrganizationId)
        AND r.RoleId = @k12PersonnelRoleId
        AND	(	( @loadAllForDataCollection = 1 OR @dataCollectionId IS NULL ) 
				OR
				( r.EntryDate <= s.SessionEndDate
					AND ( r.ExitDate >= s.SessionBeginDate OR r.ExitDate IS NULL )
				)
			)
	JOIN dbo.K12staffAssignment staff 
		ON r.OrganizationPersonRoleId = staff.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL OR staff.DataCollectionId = @dataCollectionId)	
		AND s.CountDate BETWEEN ISNULL(staff.RecordStartDateTime, s.CountDate) AND ISNULL(staff.RecordEndDateTime, GETDATE())	
	LEFT JOIN dbo.RefSpecialEducationStaffCategory staffCat 
		ON staff.RefSpecialEducationStaffCategoryId = staffCat.RefSpecialEducationStaffCategoryId
	LEFT JOIN dbo.RefK12StaffClassification classif 
		ON staff.RefK12StaffClassificationId = classif.RefK12StaffClassificationId
	LEFT JOIN dbo.RefTitleIProgramStaffCategory sTitle 
		ON staff.RefTitleIProgramStaffCategoryId = sTitle.RefTitleIProgramStaffCategoryId
	WHERE s.DimK12StaffId <> -1
		AND r.EntryDate <= s.CountDate 
		AND (r.ExitDate >= s.CountDate OR r.ExitDate IS NULL)	
	ORDER BY s.DimK12StaffId	

END
