-------------------------------------------
-- DimTitleIIIStatuses
-------------------------------------------

	IF COL_LENGTH('RDS.DimTitleIIIStatuses', 'EnglishLearnersExitedStatusCode') IS NULL
	BEGIN
		ALTER TABLE RDS.DimTitleIIIStatuses ADD EnglishLearnersExitedStatusCode nvarchar(50);
	END

	IF COL_LENGTH('RDS.DimTitleIIIStatuses', 'EnglishLearnersExitedStatusDescription') IS NULL
	BEGIN
		ALTER TABLE RDS.DimTitleIIIStatuses ADD EnglishLearnersExitedStatusDescription nvarchar(200);
	END

	IF COL_LENGTH('RDS.DimTitleIIIStatuses', 'EnglishLearnersExitedStatusEdFactsCode') IS NULL
	BEGIN
		ALTER TABLE RDS.DimTitleIIIStatuses ADD EnglishLearnersExitedStatusEdFactsCode nvarchar(50);
	END

