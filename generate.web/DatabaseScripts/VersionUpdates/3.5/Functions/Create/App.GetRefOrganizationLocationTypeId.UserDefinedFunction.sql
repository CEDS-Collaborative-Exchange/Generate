CREATE FUNCTION App.GetRefOrganizationLocationTypeId (@OrganizationLocationTypeCode VARCHAR(50))
RETURNS INT
AS BEGIN
	DECLARE @OrganizationLocationTypeId INT

	SELECT @OrganizationLocationTypeId = RefOrganizationLocationTypeId
    FROM [ODS].[RefOrganizationLocationType]
	WHERE Code = @OrganizationLocationTypeCode

	RETURN (@OrganizationLocationTypeId)
END