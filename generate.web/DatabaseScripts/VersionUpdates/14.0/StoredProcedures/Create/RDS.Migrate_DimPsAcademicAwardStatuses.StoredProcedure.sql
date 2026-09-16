CREATE PROCEDURE [RDS].[Migrate_DimPsAcademicAwardStatuses]
	@studentDates AS RDS.PsStudentDateTableType READONLY,
	@useCutOffDate BIT,
	@studentOrganizations AS RDS.PsStudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT
AS
BEGIN

	SELECT 
		  o.DimPsStudentId
		, o.DimPsInstitutionId
		, sy.DimSchoolYearId
		, dd.DimDateId AS DimAcademicAwardDateId
		, ISNULL(paas.DimPsAcademicAwardStatusId, -1) AS DimOrganizationCalendarSessionId
		, ISNULL(paas.PescAwardLevelTypeCode, 'MISSING') AS PescAwardLevelTypeCode
		, ISNULL(paas.ProfessionalOrTechnicalCredentialConferredCode, 'MISSING') AS ProfessionalOrTechnicalCredentialConferredCode
	FROM @studentDates d
	JOIN @studentOrganizations o
		ON d.DimPsStudentId = o.DimPsStudentId
	JOIN dbo.OrganizationPersonRole opr
		ON d.PersonId = opr.PersonId
		AND o.PsInstitutionOrganizationId = opr.OrganizationId
	JOIN dbo.PsStudentAcademicAward saa
		ON opr.OrganizationPersonRoleId = saa.OrganizationPersonRoleId
	LEFT JOIN dbo.RefPESCAwardLevelType palt
		ON saa.RefPESCAwardLevelTypeId = palt.RefPESCAwardLevelTypeId
	LEFT JOIN dbo.RefProfessionalTechnicalCredentialType ptct
		ON saa.RefProfessionalTechnicalCredentialTypeId = ptct.RefProfessionalTechnicalCredentialTypeId
	LEFT JOIN RDS.DimPsAcademicAwardStatuses paas
		ON palt.Code = paas.PescAwardLevelTypeCode
		AND ptct.Code = paas.ProfessionalOrTechnicalCredentialConferredCode
	LEFT JOIN RDS.DimDates dd
		ON saa.AcademicAwardDate = dd.DateValue
	LEFT JOIN RDS.DimSchoolYears sy
		ON saa.AcademicAwardDate BETWEEN sy.SessionBeginDate AND sy.SessionEndDate
	WHERE (palt.Code IS NOT NULL OR ptct.Code IS NOT NULL)
		AND (@loadAllForDataCollection = 1
			OR ((@useCutOffDate = 1 
					AND d.CountDate = saa.AcademicAwardDate)
				OR  (@useCutOffDate = 0
					AND saa.AcademicAwardDate BETWEEN d.SessionBeginDate AND d.SessionEndDate)))
END