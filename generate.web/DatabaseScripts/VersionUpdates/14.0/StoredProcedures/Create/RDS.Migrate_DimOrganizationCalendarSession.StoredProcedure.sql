CREATE PROCEDURE [RDS].[Migrate_DimOrganizationCalendarSession]
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
		, d.DimCountDateId
		, ses.DimOrganizationCalendarSessionId
		, ses.SessionCode
		, ses.BeginDate
		, ses.EndDate
	FROM @studentDates d
	JOIN @studentOrganizations o
		ON d.DimPsStudentId = o.DimPsStudentId
	JOIN dbo.OrganizationPersonRole opr
		ON d.PersonId = opr.PersonId
		AND o.PsInstitutionOrganizationId = opr.OrganizationId
	JOIN dbo.OrganizationCalendar oc
		ON o.PsInstitutionOrganizationId = oc.OrganizationId
	JOIN dbo.OrganizationCalendarSession ocs
		ON oc.OrganizationCalendarId = ocs.OrganizationCalendarId
	JOIN RDS.DimOrganizationCalendarSessions ses
		ON ses.SessionCode = ocs.Code
		AND ses.BeginDate = ocs.BeginDate
		AND ses.EndDate = ocs.EndDate
	WHERE oc.OrganizationId = o.PsInstitutionOrganizationId
		AND (@loadAllForDataCollection = 1
			OR ((@useCutOffDate = 1 
					AND d.CountDate BETWEEN ocs.BeginDate AND ocs.EndDate)
				OR  (@useCutOffDate = 0
					AND d.SessionEndDate >= ocs.BeginDate
					AND d.SessionBeginDate <= ocs.EndDate) 
				))

END