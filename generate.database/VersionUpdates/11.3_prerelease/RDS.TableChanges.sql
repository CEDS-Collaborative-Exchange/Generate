--update the RDS dimension tables for Organization Address to match the CEDS defined lengths

--DimSeas
	IF COL_LENGTH('RDS.DimSeas', 'MailingAddressStreetNumberAndName') IS NOT NULL
	BEGIN
		ALTER TABLE RDS.DimSeas ALTER COLUMN MailingAddressStreetNumberAndName nvarchar(150);
	END

	IF COL_LENGTH('RDS.DimSeas', 'MailingAddressApartmentRoomOrSuiteNumber') IS NOT NULL
	BEGIN
		ALTER TABLE RDS.DimSeas ALTER COLUMN MailingAddressApartmentRoomOrSuiteNumber nvarchar(60);
	END

	IF COL_LENGTH('RDS.DimSeas', 'PhysicalAddressStreetNumberAndName') IS NOT NULL
	BEGIN
		ALTER TABLE RDS.DimSeas ALTER COLUMN PhysicalAddressStreetNumberAndName nvarchar(150);
	END

	IF COL_LENGTH('RDS.DimSeas', 'PhysicalAddressApartmentRoomOrSuiteNumber') IS NOT NULL
	BEGIN
		ALTER TABLE RDS.DimSeas ALTER COLUMN PhysicalAddressApartmentRoomOrSuiteNumber nvarchar(60);
	END

--DimLeas
	IF COL_LENGTH('RDS.DimLeas', 'MailingAddressApartmentRoomOrSuiteNumber') IS NOT NULL
	BEGIN
		ALTER TABLE RDS.DimLeas ALTER COLUMN MailingAddressApartmentRoomOrSuiteNumber nvarchar(60);
	END

	IF COL_LENGTH('RDS.DimLeas', 'PhysicalAddressApartmentRoomOrSuiteNumber') IS NOT NULL
	BEGIN
		ALTER TABLE RDS.DimLeas ALTER COLUMN PhysicalAddressApartmentRoomOrSuiteNumber nvarchar(60);
	END

--DimK12Schools
	IF COL_LENGTH('RDS.DimK12Schools', 'MailingAddressStreetNumberAndName') IS NOT NULL
	BEGIN
		ALTER TABLE RDS.DimK12Schools ALTER COLUMN MailingAddressStreetNumberAndName nvarchar(150);
	END

	IF COL_LENGTH('RDS.DimK12Schools', 'MailingAddressApartmentRoomOrSuiteNumber') IS NOT NULL
	BEGIN
		ALTER TABLE RDS.DimK12Schools ALTER COLUMN MailingAddressApartmentRoomOrSuiteNumber nvarchar(60);
	END

	IF COL_LENGTH('RDS.DimK12Schools', 'PhysicalAddressStreetNumberAndName') IS NOT NULL
	BEGIN
		ALTER TABLE RDS.DimK12Schools ALTER COLUMN PhysicalAddressStreetNumberAndName nvarchar(150);
	END

	IF COL_LENGTH('RDS.DimK12Schools', 'PhysicalAddressApartmentRoomOrSuiteNumber') IS NOT NULL
	BEGIN
		ALTER TABLE RDS.DimK12Schools ALTER COLUMN PhysicalAddressApartmentRoomOrSuiteNumber nvarchar(60);
	END

--DimCharterSchoolAuthorizers
	IF COL_LENGTH('RDS.CharterSchoolAuthorizers', 'MailingAddressApartmentRoomOrSuiteNumber') IS NOT NULL
	BEGIN
		ALTER TABLE RDS.CharterSchoolAuthorizers ALTER COLUMN MailingAddressApartmentRoomOrSuiteNumber nvarchar(60);
	END

	IF COL_LENGTH('RDS.CharterSchoolAuthorizers', 'PhysicalAddressApartmentRoomOrSuiteNumber') IS NOT NULL
	BEGIN
		ALTER TABLE RDS.CharterSchoolAuthorizers ALTER COLUMN PhysicalAddressApartmentRoomOrSuiteNumber nvarchar(60);
	END
