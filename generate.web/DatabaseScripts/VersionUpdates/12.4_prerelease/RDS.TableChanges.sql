
-- -------------------------------------------
-- -- DimNorDStatuses
-- -------------------------------------------

-- 	IF COL_LENGTH('RDS.DimNOrDStatuses', 'NeglectedOrDelinquentStatusCode') IS NULL
-- 	BEGIN
-- 		ALTER TABLE RDS.DimNOrDStatuses ADD NeglectedOrDelinquentStatusCode nvarchar(50);
-- 	END

-- -------------------------------------------
-- -- ReportEDFactsK12StudentAssessments
-- -------------------------------------------
-- 	IF COL_LENGTH('RDS.ReportEdFactsK12StudentAssessments', 'NEGLECTEDPROGRAMTYPE') IS NOT NULL
-- 	BEGIN
-- 		ALTER TABLE RDS.ReportEDFactsK12StudentAssessments ADD NEGLECTEDPROGRAMTYPE nvarchar(50);
-- 	END

-- -------------------------------------------
-- -- FactK12StudentCounts
-- -------------------------------------------
-- 	IF COL_LENGTH('RDS.FactK12StudentCounts', 'StatusStartDateNeglectedOrDelinquentId') IS NULL
-- 	BEGIN
-- 		ALTER TABLE RDS.FactK12StudentCounts ADD StatusStartDateNeglectedOrDelinquentId INT NOT NULL
-- 			CONSTRAINT [DF_FactK12StudentCounts_StatusStartDateNeglectedOrDelinquentId] DEFAULT ((-1)) WITH VALUES;
-- 	END

-- 	IF COL_LENGTH('RDS.FactK12StudentCounts', 'StatusEndDateNeglectedOrDelinquentId') IS NULL
-- 	BEGIN
-- 		ALTER TABLE RDS.FactK12StudentCounts ADD StatusEndDateNeglectedOrDelinquentId INT NOT NULL
-- 			CONSTRAINT [DF_FactK12StudentCounts_StatusEndDateNeglectedOrDelinquentId]  DEFAULT ((-1)) WITH VALUES;
-- 	END

-- 	IF NOT EXISTS(SELECT 1
-- 	FROM
-- 		sys.foreign_keys AS fk
-- 		JOIN sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
-- 		JOIN sys.columns AS c ON fkc.parent_object_id = c.object_id AND fkc.parent_column_id = c.column_id
-- 		JOIN sys.tables AS t ON fk.parent_object_id = t.object_id
-- 	WHERE
-- 		fk.name = 'FK_FactK12StudentCounts_StatusStartDateNeglectedOrDelinquentId')
-- 	BEGIN
-- 	ALTER TABLE [RDS].[FactK12StudentCounts]  WITH NOCHECK ADD CONSTRAINT [FK_FactK12StudentCounts_StatusStartDateNeglectedOrDelinquentId] FOREIGN KEY([StatusStartDateNeglectedOrDelinquentId])
-- 		REFERENCES [RDS].[DimDates] ([DimDateId])

-- 	ALTER TABLE [RDS].[FactK12StudentCounts] CHECK CONSTRAINT [FK_FactK12StudentCounts_StatusStartDateNeglectedOrDelinquentId]
-- 	END


-- 	IF NOT EXISTS(SELECT 1
-- 	FROM
-- 		sys.foreign_keys AS fk
-- 		JOIN sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
-- 		JOIN sys.columns AS c ON fkc.parent_object_id = c.object_id AND fkc.parent_column_id = c.column_id
-- 		JOIN sys.tables AS t ON fk.parent_object_id = t.object_id
-- 	WHERE
--     fk.name = 'FK_FactK12StudentCounts_StatusEndDateNeglectedOrDelinquentId')
-- 	BEGIN
-- 		ALTER TABLE [RDS].[FactK12StudentCounts]  WITH NOCHECK ADD CONSTRAINT [FK_FactK12StudentCounts_StatusEndDateNeglectedOrDelinquentId] FOREIGN KEY([StatusEndDateNeglectedOrDelinquentId])
-- 		REFERENCES [RDS].[DimDates] ([DimDateId])

-- 		ALTER TABLE [RDS].[FactK12StudentCounts] CHECK CONSTRAINT [FK_FactK12StudentCounts_StatusEndDateNeglectedOrDelinquentId]
-- 	END

-- 	IF NOT EXISTS(SELECT 1
-- 	FROM
-- 		sys.foreign_keys AS fk
-- 		JOIN sys.foreign_key_columns AS fkc ON fk.object_id = fkc.constraint_object_id
-- 		JOIN sys.columns AS c ON fkc.parent_object_id = c.object_id AND fkc.parent_column_id = c.column_id
-- 		JOIN sys.tables AS t ON fk.parent_object_id = t.object_id
-- 	WHERE
--     fk.name = 'FK_FactK12StudentCounts_EnrollmentExitDateId')
-- 	BEGIN

-- 		ALTER TABLE [RDS].[FactK12StudentCounts]  WITH NOCHECK ADD CONSTRAINT [FK_FactK12StudentCounts_EnrollmentExitDateId] FOREIGN KEY([EnrollmentExitDateId])
-- 		REFERENCES [RDS].[DimDates] ([DimDateId])

-- 		ALTER TABLE [RDS].[FactK12StudentCounts] CHECK CONSTRAINT [FK_FactK12StudentCounts_EnrollmentExitDateId]

-- 	END

-------------------------------------------
-- Source-to-Staging_MigrantEdProgram
-------------------------------------------
	IF OBJECT_ID('Source.Source-to-Staging_MigrantEdProgram', 'P') IS NOT NULL
	BEGIN
		EXEC sp_rename 'Source.Source-to-Staging_MigrantEdProgram', 'Source-to-Staging_MigrantEducationProgram';
	END	

-------------------------------------------
-- DimFactTypes
-------------------------------------------
	-- Check if the column already exists before adding it
	IF COL_LENGTH('RDS.DimFactTypes', 'FactTypeLabel') IS NULL
		ALTER TABLE RDS.DimFactTypes ADD FactTypeLabel NVARCHAR(100) NULL;

