CREATE FUNCTION App.GetOrganizationIdentifierTypeId (@OrganizationIdentifierTypeCode VARCHAR(6))
RETURNS INT
AS BEGIN
	DECLARE @RefOrganizationIdentifierTypeId INT
	
	SELECT @RefOrganizationIdentifierTypeId = roit.RefOrganizationIdentifierTypeId
    FROM ODS.RefOrganizationIdentifierType roit
    WHERE roit.Code = @OrganizationIdentifierTypeCode -- 'State Agency Identification System'

	RETURN (@RefOrganizationIdentifierTypeId)
END