-----------------------------------------------
--DimPeople and DimPeople_Current
-----------------------------------------------

    --Expand the column length

   	IF COL_LENGTH('RDS.DimPeople', 'FirstName') IS NULL
	BEGIN
		ALTER TABLE RDS.DimPeople ALTER COLUMN FirstName NVARCHAR(100) NULL;
	END

   	IF COL_LENGTH('RDS.DimPeople', 'MiddleName') IS NULL
	BEGIN
		ALTER TABLE RDS.DimPeople ALTER COLUMN MiddleName NVARCHAR(100) NULL;
	END

   	IF COL_LENGTH('RDS.DimPeople', 'LastOrSurname') IS NULL
	BEGIN
		ALTER TABLE RDS.DimPeople ALTER COLUMN LastOrSurname NVARCHAR(100) NULL;
	END

   	IF COL_LENGTH('RDS.DimPeople_Current', 'FirstName') IS NULL
	BEGIN
		ALTER TABLE RDS.DimPeople_Current ALTER COLUMN FirstName NVARCHAR(100) NULL;
	END

   	IF COL_LENGTH('RDS.DimPeople_Current', 'MiddleName') IS NULL
	BEGIN
		ALTER TABLE RDS.DimPeople_Current ALTER COLUMN MiddleName NVARCHAR(100) NULL;
	END

   	IF COL_LENGTH('RDS.DimPeople_Current', 'LastOrSurname') IS NULL
	BEGIN
		ALTER TABLE RDS.DimPeople_Current ALTER COLUMN LastOrSurname NVARCHAR(100) NULL;
	END
