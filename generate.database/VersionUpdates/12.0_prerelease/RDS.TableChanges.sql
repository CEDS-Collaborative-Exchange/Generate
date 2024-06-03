SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------
-- DimNorDStatuses
-------------------------------------------

	IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedOrDelinquentStatusCode') IS NULL
	BEGIN
		ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedOrDelinquentStatusCode nvarchar(50);
	END

	IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedOrDelinquentStatusDescription') IS NULL
	BEGIN
		ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedOrDelinquentStatusDescription nvarchar(100);
	END

	IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedOrDelinquentProgramEnrollmentSubpartCode') IS NULL
	BEGIN
		ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedOrDelinquentProgramEnrollmentSubpartCode nvarchar(50);
	END

	IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedOrDelinquentProgramEnrollmentSubpartDescription') IS NULL
	BEGIN
		ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedOrDelinquentProgramEnrollmentSubpartDescription nvarchar(100);
	END

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

	IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedOrDelinquentAcademicAchievementIndicatorCode') IS NULL
	BEGIN
		ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedOrDelinquentAcademicAchievementIndicatorCode nvarchar(50);
	END

	IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedOrDelinquentAcademicAchievementIndicatorDescription') IS NULL
	BEGIN
		ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedOrDelinquentAcademicAchievementIndicatorDescription nvarchar(50);
	END

	IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedOrDelinquentAcademicOutcomeIndicatorCode') IS NULL
	BEGIN
		ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedOrDelinquentAcademicOutcomeIndicatorCode nvarchar(50);
	END

	IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedOrDelinquentAcademicOutcomeIndicatorDescription') IS NULL
	BEGIN
		ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedOrDelinquentAcademicOutcomeIndicatorDescription nvarchar(50);
	END

	IF COL_LENGTH('RDS.DimNOrDStatuses', 'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode') IS NULL
	BEGIN
		ALTER TABLE RDS.DimNOrDStatuses ADD EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode nvarchar(50);
	END

	IF COL_LENGTH('RDS.DimNOrDStatuses', 'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription') IS NULL
	BEGIN
		ALTER TABLE RDS.DimNOrDStatuses ADD EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription nvarchar(100);
	END

	IF COL_LENGTH('RDS.DimNOrDStatuses', 'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode') IS NULL
	BEGIN
		ALTER TABLE RDS.DimNOrDStatuses ADD EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode nvarchar(50);
	END

	IF COL_LENGTH('RDS.DimNOrDStatuses', 'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode') IS NULL
	BEGIN
		ALTER TABLE RDS.DimNOrDStatuses ADD EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode nvarchar(50);
	END

	IF COL_LENGTH('RDS.DimNOrDStatuses', 'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription') IS NULL
	BEGIN
		ALTER TABLE RDS.DimNOrDStatuses ADD EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription nvarchar(100);
	END

	IF COL_LENGTH('RDS.DimNOrDStatuses', 'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode') IS NULL
	BEGIN
		ALTER TABLE RDS.DimNOrDStatuses ADD EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode nvarchar(50);
	END

-------------------------------------------
-- ReportEDFactsK12StudentAssessments
-------------------------------------------
	IF COL_LENGTH('RDS.ReportEdFactsK12StudentAssessments', 'NEGLECTEDPROGRAMTYPE') IS NOT NULL
	BEGIN
		ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD NEGLECTEDPROGRAMTYPE nvarchar(50);
	END

	IF COL_LENGTH('RDS.ReportEdFactsK12StudentAssessments', 'DELINQUENTPROGRAMTYPE') IS NULL
	BEGIN
		ALTER TABLE RDS.ReportEdFactsK12StudentAssessments ADD DELINQUENTPROGRAMTYPE nvarchar(50);
	END

-------------------------------------------
-- FactK12StudentCounts
-------------------------------------------
	IF COL_LENGTH('RDS.FactK12StudentCounts', 'StatusStartDateNeglectedOrDelinquentId') IS NULL
	BEGIN
		ALTER TABLE RDS.FactK12StudentCounts ADD StatusStartDateNeglectedOrDelinquentId INT NOT NULL
			CONSTRAINT [DF_FactK12StudentCounts_StatusStartDateNeglectedOrDelinquentId] DEFAULT ((-1)) WITH VALUES;
	END

	IF COL_LENGTH('RDS.FactK12StudentCounts', 'StatusEndDateNeglectedOrDelinquentId') IS NULL
	BEGIN
		ALTER TABLE RDS.FactK12StudentCounts ADD StatusEndDateNeglectedOrDelinquentId INT NOT NULL
			CONSTRAINT [DF_FactK12StudentCounts_StatusEndDateNeglectedOrDelinquentId]  DEFAULT ((-1)) WITH VALUES;
	END

	ALTER TABLE [RDS].[FactK12StudentCounts]  WITH NOCHECK ADD CONSTRAINT [FK_FactK12StudentCounts_StatusStartDateNeglectedOrDelinquentId] FOREIGN KEY([StatusStartDateNeglectedOrDelinquentId])
	REFERENCES [RDS].[DimDates] ([DimDateId])

	ALTER TABLE [RDS].[FactK12StudentCounts] CHECK CONSTRAINT [FK_FactK12StudentCounts_StatusStartDateNeglectedOrDelinquentId]

	ALTER TABLE [RDS].[FactK12StudentCounts]  WITH NOCHECK ADD CONSTRAINT [FK_FactK12StudentCounts_StatusEndDateNeglectedOrDelinquentId] FOREIGN KEY([StatusEndDateNeglectedOrDelinquentId])
	REFERENCES [RDS].[DimDates] ([DimDateId])

	ALTER TABLE [RDS].[FactK12StudentCounts] CHECK CONSTRAINT [FK_FactK12StudentCounts_StatusEndDateNeglectedOrDelinquentId]

    IF COL_LENGTH('RDS.FactK12StudentCounts', 'EnrollmentEntryDateId') IS NULL
    BEGIN
        ALTER TABLE RDS.FactK12StudentCounts ADD EnrollmentEntryDateId INT NOT NULL
            CONSTRAINT [DF_FactK12StudentCounts_EnrollmentEntryDateId] DEFAULT ((-1)) WITH VALUES;
    END

    IF COL_LENGTH('RDS.FactK12StudentCounts', 'EnrollmentExitDateId') IS NULL
    BEGIN
        ALTER TABLE RDS.FactK12StudentCounts ADD EnrollmentExitDateId INT NOT NULL
            CONSTRAINT [DF_FactK12StudentCounts_EnrollmentExitDateId]  DEFAULT ((-1)) WITH VALUES;
    END

    ALTER TABLE [RDS].[FactK12StudentCounts]  WITH NOCHECK ADD CONSTRAINT [FK_FactK12StudentCounts_EnrollmentEntryDateId] FOREIGN KEY([EnrollmentEntryDateId])
    REFERENCES [RDS].[DimDates] ([DimDateId])

    ALTER TABLE [RDS].[FactK12StudentCounts] CHECK CONSTRAINT [FK_FactK12StudentCounts_EnrollmentEntryDateId]

    ALTER TABLE [RDS].[FactK12StudentCounts]  WITH NOCHECK ADD CONSTRAINT [FK_FactK12StudentCounts_EnrollmentExitDateId] FOREIGN KEY([EnrollmentExitDateId])
    REFERENCES [RDS].[DimDates] ([DimDateId])

    ALTER TABLE [RDS].[FactK12StudentCounts] CHECK CONSTRAINT [FK_FactK12StudentCounts_EnrollmentExitDateId]




	