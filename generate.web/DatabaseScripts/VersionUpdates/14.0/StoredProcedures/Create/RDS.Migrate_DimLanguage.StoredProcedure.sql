CREATE PROCEDURE [RDS].[Migrate_DimLanguage]
    @studentDates AS K12StudentDateTableType READONLY,
	@dataCollectionId AS INT = NULL
AS
BEGIN
       
	DECLARE @languageUseTypeId AS INT 
    SELECT @languageUseTypeId = RefLanguageUseTypeId FROM dbo.RefLanguageUseType WHERE Code ='Native'
             
   	DECLARE @organizationElementTypeId AS INT
	SELECT @organizationElementTypeId = RefOrganizationElementTypeId
	FROM dbo.RefOrganizationElementType 
	WHERE [Code] = '001156'

	DECLARE @leaOrgTypeId AS INT
	SELECT @leaOrgTypeId = RefOrganizationTypeId
	FROM dbo.RefOrganizationType 
	WHERE ([Code] = 'LEA') AND RefOrganizationElementTypeId = @organizationElementTypeId

	DECLARE @schoolOrgTypeId AS INT
	SELECT @schoolOrgTypeId = RefOrganizationTypeId
	FROM dbo.RefOrganizationType 
	WHERE ([Code] = 'K12School') AND RefOrganizationElementTypeId = @organizationElementTypeId

    SELECT DISTINCT
              d.DimK12StudentId
            , d.PersonId
            , d.DimCountDateId
            , l.Code AS 'LanguageCode'          
	FROM @studentDates d
	JOIN dbo.PersonIdentifier pi 
		ON d.PersonId = pi.PersonId
		AND (@dataCollectionId IS NULL 
			OR pi.DataCollectionId = @dataCollectionId)	
    JOIN dbo.OrganizationPersonRole r 
		ON r.PersonId = d.PersonId
		AND (@dataCollectionId IS NULL 
			OR r.DataCollectionId = @dataCollectionId)	
	JOIN dbo.OrganizationDetail od 
		ON r.OrganizationId = od.OrganizationId 
		AND od.RefOrganizationTypeId IN (@leaOrgTypeId, @schoolOrgTypeId)
		AND (@dataCollectionId IS NULL 
			OR od.DataCollectionId = @dataCollectionId)	
    JOIN dbo.PersonLanguage pl 
		ON pl.PersonId = r.PersonId 
		AND pl.RefLanguageUseTypeId = @languageUseTypeId
		AND (@dataCollectionId IS NULL 
			OR pl.DataCollectionId = @dataCollectionId)	
    JOIN dbo.RefLanguage l 
		ON l.RefLanguageId = pl.RefLanguageId
    WHERE r.EntryDate <= d.CountDate 
		AND (r.ExitDate >= d.CountDate 
			OR r.ExitDate IS NULL)
END