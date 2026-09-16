CREATE TABLE Staging.OrganizationAddress (
	 Id INT IDENTITY(1, 1) Primary Key
	,OrganizationIdentifier VARCHAR(60)
	,OrganizationType VARCHAR(100)
	,AddressTypeForOrganization VARCHAR(50)
	,AddressStreetNumberAndName VARCHAR(150)
	,AddressApartmentRoomOrSuite VARCHAR(50)
	,AddressCity VARCHAR(30)
	,RefStateId VARCHAR(100)
	,AddressStateANSICode VARCHAR(100)
	,AddressPostalCode VARCHAR(17)
	,OrganizationId VARCHAR(100)
	,LocationId VARCHAR(100)
	,RunDateTime DATETIME
	)

exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationAddress', @level2type = N'Column', @level2name = 'OrganizationIdentifier' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationAddress', @level2type = N'Column', @level2name = 'OrganizationType' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefOrganizationType', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationAddress', @level2type = N'Column', @level2name = 'OrganizationType' 
exec sp_addextendedproperty @name = N'TableFilter', @value = N'001156', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationAddress', @level2type = N'Column', @level2name = 'OrganizationType' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationAddress', @level2type = N'Column', @level2name = 'AddressTypeForOrganization' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefOrganizationLocationType', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationAddress', @level2type = N'Column', @level2name = 'AddressTypeForOrganization' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationAddress', @level2type = N'Column', @level2name = 'AddressStreetNumberAndName' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationAddress', @level2type = N'Column', @level2name = 'AddressCity' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationAddress', @level2type = N'Column', @level2name = 'RefStateId' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefState', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationAddress', @level2type = N'Column', @level2name = 'RefStateId' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationAddress', @level2type = N'Column', @level2name = 'AddressStateANSICode' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefStateANSICode', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationAddress', @level2type = N'Column', @level2name = 'AddressStateANSICode' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationAddress', @level2type = N'Column', @level2name = 'AddressPostalCode' 
