--This will be used to house telephone number data for all three organization types (SEA, LEA, and K12 School)
CREATE TABLE Staging.OrganizationPhone (
	 Id INT IDENTITY(1, 1) Primary Key
	,OrganizationIdentifier VARCHAR(100)
	,OrganizationType VARCHAR(100)
	,InstitutionTelephoneNumberType VARCHAR(100)
	,TelephoneNumber VARCHAR(100)
	,OrganizationId VARCHAR(100)
	,LEA_OrganizationTelephoneId INT
	,School_OrganizationTelephoneId INT
	,RunDateTime DATETIME
	)

exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationPhone', @level2type = N'Column', @level2name = 'OrganizationIdentifier' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationPhone', @level2type = N'Column', @level2name = 'OrganizationType' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefOrganizationType', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationPhone', @level2type = N'Column', @level2name = 'OrganizationType' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationPhone', @level2type = N'Column', @level2name = 'InstitutionTelephoneNumberType' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefInstitutionTelephoneType', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationPhone', @level2type = N'Column', @level2name = 'InstitutionTelephoneNumberType' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationPhone', @level2type = N'Column', @level2name = 'TelephoneNumber' 