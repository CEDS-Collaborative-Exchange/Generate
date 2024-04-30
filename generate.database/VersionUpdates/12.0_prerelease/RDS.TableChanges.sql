IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedProgramTypeCode') IS NULL
BEGIN
	ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedProgramTypeCode nvarchar(50);
END

IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedProgramTypeDescription') IS NULL
BEGIN
	ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedProgramTypeDescription nvarchar(100);
END

IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedProgramTypeEdFactsCode') IS NULL
BEGIN
	ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedProgramTypeEdFactsCode nvarchar(50);
END

IF COL_LENGTH('RDS.DimNOrDStatuses', 'DelinquentProgramTypeCode') IS NULL
BEGIN
	ALTER TABLE RDS.DimNOrDStatuses ADD DelinquentProgramTypeCode nvarchar(50);
END

IF COL_LENGTH('RDS.DimNOrDStatuses', 'DelinquentProgramTypeDescription') IS NULL
BEGIN
	ALTER TABLE RDS.DimNOrDStatuses ADD DelinquentProgramTypeDescription nvarchar(100);
END

IF COL_LENGTH('RDS.DimNOrDStatuses', 'DelinquentProgramTypeEdFactsCode') IS NULL
BEGIN
	ALTER TABLE RDS.DimNOrDStatuses ADD DelinquentProgramTypeEdFactsCode nvarchar(50);
END

IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedOrDelinquentAcademicOutcomeIndicatorCode') IS NULL
BEGIN
	ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedOrDelinquentAcademicOutcomeIndicatorCode nvarchar(50);
END

IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedOrDelinquentAcademicOutcomeIndicatorDescription') IS NULL
BEGIN
	ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedOrDelinquentAcademicOutcomeIndicatorDescription nvarchar(100);
END

IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedOrDelinquentAcademicAchievementIndicatorCode') IS NULL
BEGIN
	ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedOrDelinquentAcademicAchievementIndicatorCode nvarchar(50);
END

IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedOrDelinquentAcademicAchievementIndicatorDescription') IS NULL
BEGIN
	ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedOrDelinquentAcademicAchievementIndicatorDescription nvarchar(100);
END

IF COL_LENGTH('RDS.ReportEdFactsK12StudentAssessments', 'NEGLECTEDPROGRAMTYPE') IS NOT NULL
BEGIN
	ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD NEGLECTEDPROGRAMTYPE nvarchar(50);
END

IF COL_LENGTH('RDS.ReportEdFactsK12StudentAssessments', 'DELINQUENTPROGRAMTYPE') IS NULL
BEGIN
	ALTER TABLE RDS.ReportEdFactsK12StudentAssessments ADD DELINQUENTPROGRAMTYPE nvarchar(50);
END
