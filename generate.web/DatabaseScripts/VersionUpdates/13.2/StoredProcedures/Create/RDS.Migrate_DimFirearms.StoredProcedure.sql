CREATE PROCEDURE [RDS].[Migrate_DimFirearms]
	@studentDates AS K12StudentDateTableType READONLY,
	@studentOrganizations AS K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN
     
    SELECT 
          d.DimK12StudentId AS DimK12StudentId
        , org.DimK12SchoolId
		, org.DimLeaId
		, org.DimSeaId
        , d.PersonId AS PersonId
        , d.DimCountDateId AS DimCountDateId
        , ISNULL(rft.Code,'MISSING') AS FirearmsCode 
    FROM  @studentDates d 
	JOIN @studentOrganizations org 
		ON d.DimK12StudentId = org.DimK12StudentId 
		AND d.DimCountDateId = org.DimCountDateId
    JOIN dbo.OrganizationPersonRole r 
		ON r.PersonId = d.PersonId 
		AND r.OrganizationId = IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId)    
		AND (@dataCollectionId IS NULL 
			OR r.DataCollectionId = @dataCollectionId)	
	JOIN dbo.Incident incident 
		ON incident.OrganizationPersonRoleId = r.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL 
			OR incident.DataCollectionId = @dataCollectionId)	
	LEFT JOIN dbo.RefFirearmType rft 
		ON rft.RefFirearmTypeId=incident.RefFirearmTypeId	
    WHERE r.EntryDate <= d.CountDate 
		AND (r.ExitDate >= d.CountDate 
			OR r.ExitDate IS NULL) 
		AND incident.IncidentDate BETWEEN d.SessionBeginDate AND d.SessionEndDate

END
