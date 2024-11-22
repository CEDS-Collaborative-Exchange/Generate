CREATE TABLE Staging.OrganizationFederalFunding (
	 Id INT IDENTITY(1, 1) Primary Key
	,OrganizationIdentifier VARCHAR(60)
	,OrganizationType VARCHAR(100)
	,FederalProgramCode VARCHAR(10)
	,FederalProgramsFundingAllocation NUMERIC(12,2)
	,ParentalInvolvementReservationFunds NUMERIC(12,2)
	,REAPAlternativeFundingStatusCode VARCHAR(100)
	,FederalProgramFundingAllocationType VARCHAR(100)
	,RunDateTime DATETIME
	)

exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationFederalFunding', @level2type = N'Column', @level2name = 'OrganizationIdentifier' 
exec sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationFederalFunding', @level2type = N'Column', @level2name = 'OrganizationType' 
exec sp_addextendedproperty @name = N'Lookup', @value = N'RefOrganizationType', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationFederalFunding', @level2type = N'Column', @level2name = 'OrganizationType' 
exec sp_addextendedproperty @name = N'TableFilter', @value = N'001156', @level0type = N'Schema', @level0name = 'Staging', @level1type = N'Table',  @level1name = 'OrganizationFederalFunding', @level2type = N'Column', @level2name = 'OrganizationType' 

