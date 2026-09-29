CREATE PROCEDURE [RDS].[Migrate_DimFirearmsDiscipline]
	@studentDates AS K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN
	
	DECLARE @k12StudentRoleId AS INT
	SELECT @k12StudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Student'

	SELECT 
		  d.DimK12StudentId
		, d.DimCountDateId
		, d.PersonId
		, ISNULL(org.DimK12SchoolId, -1) AS DimK12SchoolId
		, ISNULL(org.DimLeaId, -1) AS DimLeaId
		, org.DimSeaId
		, dis.IncidentId
		, ISNULL(refFirearms.Code, 'MISSING')	 AS FirearmsDisciplineCode
		, ISNULL(refFirearmsIdea.Code, 'MISSING')	 AS IDEAFirearmsDisciplineCode
		, dis.DisciplinaryActionStartDate
		, dfd.DimFirearmDisciplineId
	FROM @studentDates d 
	JOIN @studentOrganizations org 
		ON d.DimK12StudentId = org.DimK12StudentId 
		AND d.PersonId = org.PersonId
	JOIN dbo.K12studentDiscipline dis 
		ON ISNULL(org.K12SchoolOrganizationPersonRoleId, org.LeaOrganizationPersonRoleId) = dis.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL 
			OR dis.DataCollectionId = @dataCollectionId)	
		AND dis.DisciplinaryActionStartDate <= d.SessionEndDate
		AND (dis.DisciplinaryActionEndDate IS NULL 
			OR dis.DisciplinaryActionEndDate >= d.SessionBeginDate)
	LEFT JOIN dbo.RefDisciplineMethodFirearms refFirearms 
		ON dis.RefDisciplineMethodFirearmsId = refFirearms.RefDisciplineMethodFirearmsId
	LEFT JOIN dbo.RefIDEADisciplineMethodFirearm refFirearmsIdea 
		ON dis.RefIDEADisciplineMethodFirearmId = refFirearmsIdea.RefIDEADisciplineMethodFirearmId
 	LEFT JOIN rds.DimFirearmDisciplines dfd
		ON dfd.DisciplineMethodForFirearmsIncidentsCode = ISNULL(refFirearms.Code, 'MISSING')
		AND dfd.IdeaDisciplineMethodForFirearmsIncidentsCode = ISNULL(refFirearmsIdea.Code, 'MISSING')
	
END
