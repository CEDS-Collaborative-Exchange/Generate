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

IF COL_LENGTH('Staging.ProgramParticipationNorD', 'NeglectedProgramType') IS  NULL
BEGIN
	ALTER TABLE Staging.ProgramParticipationNorD ADD NeglectedProgramType nvarchar(100);
END

IF COL_LENGTH('Staging.ProgramParticipationNorD', 'DelinquentProgramType') IS NULL
BEGIN
	ALTER TABLE Staging.ProgramParticipationNorD ADD DelinquentProgramType nvarchar(100);
END

IF COL_LENGTH('RDS.ReportEDFactsK12StudentCounts', 'NEGLECTEDPROGRAMTYPE') IS NULL
BEGIN
	ALTER TABLE RDS.ReportEDFactsK12StudentCounts ADD NEGLECTEDPROGRAMTYPE nvarchar(50);
END

IF COL_LENGTH('RDS.ReportEDFactsK12StudentCounts', 'DELINQUENTPROGRAMTYPE') IS NULL
BEGIN
	ALTER TABLE RDS.ReportEDFactsK12StudentCounts ADD DELINQUENTPROGRAMTYPE nvarchar(50);
END

IF COL_LENGTH('RDS.ReportEdFactsK12StudentAssessments', 'NEGLECTEDPROGRAMTYPE') IS NOT NULL
BEGIN
	ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD NEGLECTEDPROGRAMTYPE nvarchar(50);
END

IF COL_LENGTH('RDS.ReportEdFactsK12StudentAssessments', 'DELINQUENTPROGRAMTYPE') IS NULL
BEGIN
	ALTER TABLE RDS.ReportEdFactsK12StudentAssessments ADD DELINQUENTPROGRAMTYPE nvarchar(50);
END
