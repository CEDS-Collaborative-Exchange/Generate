--update the Staging OrganizationAddress table to match the CEDS defined lengths

	IF COL_LENGTH('Staging.OrganizationAddress', 'AddressApartmentRoomOrSuiteNumber') IS NOT NULL
	BEGIN
		ALTER TABLE Staging.OrganizationAddress ALTER COLUMN AddressApartmentRoomOrSuiteNumber nvarchar(60);
	END
