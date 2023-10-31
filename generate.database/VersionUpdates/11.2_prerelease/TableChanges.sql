
IF COL_LENGTH('RDS.ReportEDFactsOrganizationCounts', 'CharterSchoolAuthorizerType') IS NULL
		BEGIN
			ALTER TABLE RDS.ReportEDFactsOrganizationCounts ADD CharterSchoolAuthorizerType nvarchar(100);
END