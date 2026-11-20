CREATE PROCEDURE [RDS].[Migrate_DimPsEnrollmentStatuses]
	@studentDates AS RDS.PsStudentDateTableType READONLY,
	@useCutOffDate BIT,
	@studentOrganizations AS RDS.PsStudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT
AS
BEGIN

	SELECT DISTINCT
		  o.DimPsStudentId
		, o.DimPsInstitutionId
		, d.DimCountDateId
		, d.DimSchoolYearid
		, ISNULL(pewt.Code, 'MISSING') AS PostsecondaryExitOrWithdrawalTypeCode
		, ISNULL(pes.DimPsEnrollmentStatusId, -1) AS DimPsEnrollmentStatusId
		, o.DimAcademicTermDesignatorId
		, o.DimOrganizationCalendarSessionId
	FROM @studentDates d
	INNER JOIN @studentOrganizations o
		ON d.DimPsStudentId = o.DimPsStudentId
		AND d.PersonId = o.PersonId
	JOIN dbo.PsStudentEnrollment pse
		ON o.OrganizationPersonRoleId = pse.OrganizationPersonRoleId
		AND pse.DataCollectionid = @DataCollectionId
	LEFT JOIN dbo.RefPSExitOrWithdrawalType pewt
		ON pse.RefPSExitOrWithdrawalTypeId = pewt.RefPSExitOrWithdrawalTypeId
	LEFT JOIN rds.DimPsEnrollmentStatuses pes
		ON pewt.Code = pes.PostsecondaryExitOrWithdrawalTypeCode
END