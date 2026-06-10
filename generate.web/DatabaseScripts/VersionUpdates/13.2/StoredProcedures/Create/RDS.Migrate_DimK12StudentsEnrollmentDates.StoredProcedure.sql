CREATE PROCEDURE [RDS].[Migrate_DimK12StudentsEnrollmentDates]
	@studentDates AS K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @k12studentRoleId AS INT
	SELECT @k12studentRoleId = RoleId
	FROM dbo.[Role] WHERE Name = 'K12 Student'

	SELECT 
		  s.DimK12StudentId
		, org.DimK12SchoolId
		, org.DimLeaId
		, s.PersonId
		, s.DimCountDateId	
		, entd.DimDateId AS DimEntryDateId
		, extd.DimDateId AS DimExitDateId
		, pgd.DimDateId AS DimProjectedGraduationDateId
	FROM @studentDates s
	JOIN @studentOrganizations org 
		ON s.DimK12StudentId = org.DimK12StudentId 
	JOIN dbo.OrganizationPersonRole r 
		ON r.PersonId = s.PersonId
		AND (@dataCollectionId IS NULL 
			OR r.DataCollectionId = @dataCollectionId)	
		AND r.RoleId = @k12StudentRoleId 
		AND r.OrganizationId = IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId)
	LEFT JOIN dbo.K12StudentAcademicRecord ksar
		ON r.OrganizationPersonRoleId = ksar.OrganizationPersonRoleId
	LEFT JOIN rds.DimDates entd
		ON r.EntryDate = entd.DateValue
	LEFT JOIN rds.DimDates extd
		ON r.ExitDate = extd.DateValue
	LEFT JOIN rds.DimDates pgd
		ON ksar.ProjectedGraduationDate = pgd.DateValue		  

	SET NOCOUNT OFF;

END