CREATE PROCEDURE [RDS].[Migrate_DimFirearmsDiscipline]
	@studentDates AS K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN
	
	DECLARE @k12StudentRoleId AS INT
	SELECT @k12StudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Student'

	SELECT 
		s.DimK12StudentId
		, d.DimCountDateId
		, d.PersonId
		, ISNULL(org.DimK12SchoolId, -1) AS DimK12SchoolId
		, NULL AS DimLeaId
		, org.DimSeaId
		, dis.IncidentId
		, ISNULL(refFirearms.Code, 'MISSING')	 AS FirearmsDisciplineCode
		, ISNULL(refFirearmsIdea.Code, 'MISSING')	 AS IDEAFirearmsDisciplineCode
		, dis.DisciplinaryActionStartDate
		, dfd.DimFirearmDisciplineId
	INTO #FirearmDisciplines
	FROM rds.DimK12Students s 
	JOIN @studentDates d 
		ON s.DimK12StudentId = d.DimK12StudentId 
		AND s.RecordEndDateTime IS NULL
	JOIN @studentOrganizations org 
		ON s.DimK12StudentId = org.DimK12StudentId 
		AND d.DimCountDateId = org.DimCountDateId
	JOIN dbo.OrganizationDetail od 
		ON org.K12SchoolOrganizationId = od.OrganizationId
		AND (@dataCollectionId IS NULL 
			OR od.DataCollectionId = @dataCollectionId)	
	JOIN dbo.RefOrganizationType ot 
		ON od.RefOrganizationTypeId = ot.RefOrganizationTypeId
		AND ot.Code = 'K12School'

--Should the date be session begin/end or count date ???
	
	JOIN dbo.K12studentDiscipline dis 
		ON ISNULL(org.K12SchoolOrganizationPersonRoleId, org.LeaOrganizationPersonRoleId) = dis.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL 
			OR dis.DataCollectionId = @dataCollectionId)	
		AND (dis.DisciplinaryActionStartDate BETWEEN d.SessionBeginDate AND d.SessionEndDate
			OR dis.DisciplinaryActionEndDate IS NULL 
			OR dis.DisciplinaryActionEndDate BETWEEN d.SessionBeginDate AND d.SessionEndDate)
	LEFT JOIN dbo.RefDisciplineMethodFirearms refFirearms 
		ON dis.RefDisciplineMethodFirearmsId = refFirearms.RefDisciplineMethodFirearmsId
	LEFT JOIN dbo.RefIDEADisciplineMethodFirearm refFirearmsIdea 
		ON dis.RefIDEADisciplineMethodFirearmId = refFirearmsIdea.RefIDEADisciplineMethodFirearmId

 	LEFT JOIN rds.DimFirearmDisciplines dfd
		ON dfd.DisciplineMethodForFirearmsIncidentsCode = ISNULL(refFirearms.Code, 'MISSING')
		AND dfd.IdeaDisciplineMethodForFirearmsIncidentsCode = ISNULL(refFirearmsIdea.Code, 'MISSING')

	WHERE s.DimK12StudentId <> -1 

	UPDATE #FirearmDisciplines
	SET DimLeaId = org.DimLeaId
	FROM #FirearmDisciplines fd
	JOIN @studentOrganizations org
		ON fd.DimK12StudentId = org.DimK12StudentId 
		AND fd.DimCountDateId = org.DimCountDateId
		AND fd.DimK12SchoolId = org.DimK12SchoolId
	JOIN dbo.OrganizationDetail od 
		ON org.LeaOrganizationId = od.OrganizationId
	JOIN dbo.RefOrganizationType ot 
		ON od.RefOrganizationTypeId = ot.RefOrganizationTypeId
		AND ot.Code = 'LEA'
	JOIN dbo.OrganizationPersonRole r 
		ON fd.PersonId = r.PersonId 
		AND r.OrganizationId = org.LeaOrganizationId	
		AND fd.DisciplinaryActionStartDate BETWEEN r.EntryDate AND ISNULL(r.ExitDate, GETDATE())
	JOIN dbo.K12studentDiscipline dis 
		ON r.OrganizationPersonRoleId = dis.OrganizationPersonRoleId 
		AND dis.DisciplinaryActionStartDate = fd.DisciplinaryActionStartDate

	SELECT * FROM #FirearmDisciplines
	
	DROP TABLE #FirearmDisciplines
	
END
