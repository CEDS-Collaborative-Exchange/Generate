
CREATE PROCEDURE [RDS].[Migrate_DimPsStudentsEnrollmentDates]
	@studentDates AS PsStudentDateTableType READONLY,
	@studentOrganizations AS RDS.PsStudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN

	SET NOCOUNT ON;
			
	SELECT DISTINCT
		  s.DimPsStudentId
		, org.DimPsInstitutionId
		, s.PersonId
		, s.DimCountDateId	
		, psentryd.DimDateID AS EntryDateIntoPostSecondaryId
		, entd.DimDateId AS DimEntryDateId
		, extd.DimDateId AS DimExitDateId
		, org.DimAcademicTermDesignatorId
		, org.OrganizationPersonRoleId AS OrganizationPersonRoleId
	FROM @studentDates s
	JOIN @studentOrganizations org 
		ON s.DimPsStudentId = org.DimPsStudentId 
		AND s.PersonId = org.PersonId
	JOIN dbo.OrganizationPersonRole r 
		ON r.OrganizationPersonRoleId = org.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL 
				OR r.DataCollectionId = @dataCollectionId)		
	LEFT JOIN PsStudentEnrollment pse
		ON org.OrganizationPersonRoleId = pse.OrganizationPersonRoleId
	LEFT JOIN rds.DimDates psentryd
		ON pse.EntryDateIntoPostsecondary = psentryd.DateValue
	LEFT JOIN rds.DimDates entd
		ON r.EntryDate = entd.DateValue
	LEFT JOIN rds.DimDates extd
		ON r.ExitDate = extd.DateValue

	SET NOCOUNT OFF;

END