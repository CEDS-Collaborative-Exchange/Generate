
IF COL_LENGTH('RDS.ReportEDFactsOrganizationCounts', 'CharterSchoolAuthorizerType') IS NULL
BEGIN
	ALTER TABLE RDS.ReportEDFactsOrganizationCounts ADD CharterSchoolAuthorizerType nvarchar(100);
END

--Update the Age Group Taught values for EDFacts to the new PVs  CIID-5923
UPDATE rds.DimK12StaffStatuses
SET SpecialEducationAgeGroupTaughtEdFactsCode = '3TO5NOTK'
WHERE SpecialEducationAgeGroupTaughtCode = '3TO5'

UPDATE rds.DimK12StaffStatuses
SET SpecialEducationAgeGroupTaughtEdFactsCode = 'AGE5KTO21'
WHERE SpecialEducationAgeGroupTaughtCode = '6TO21'
