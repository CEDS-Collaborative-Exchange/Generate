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

------------------------------------------------
-- Drop and Create DimNOrDStatuses			 ---
------------------------------------------------
	-- Drop all foreign key constraints referencing rds.DimNorDStatuses
	DECLARE @sql NVARCHAR(MAX) = N'';

	SELECT @sql = @sql + 
		'ALTER TABLE [' + OBJECT_SCHEMA_NAME(fk.parent_object_id) + '].[' + OBJECT_NAME(fk.parent_object_id) + '] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
	FROM sys.foreign_keys fk
	WHERE fk.referenced_object_id = OBJECT_ID('rds.DimNorDStatuses');

	EXEC(@sql);

	-- Drop all constraints on rds.DimNorDStatuses itself
	SET @sql = N'';
	SELECT @sql = @sql +
		'ALTER TABLE [rds].[DimNorDStatuses] DROP CONSTRAINT [' + con.name + '];' + CHAR(13)
	FROM sys.objects con
	WHERE con.parent_object_id = OBJECT_ID('rds.DimNorDStatuses')
	AND con.type IN ('F', 'D', 'UQ', 'PK', 'C'); -- Foreign, Default, Unique, Primary, Check

	EXEC(@sql);

	--Drop the table if it exists
	IF OBJECT_ID(N'rds.DimNOrDStatuses') IS NOT NULL DROP TABLE rds.DimNOrDStatuses

	CREATE TABLE [RDS].[DimNOrDStatuses](
		[DimNOrDStatusId] [int] IDENTITY(1,1) NOT NULL,
		[NeglectedOrDelinquentStatusCode] [nvarchar](50) NULL,
		[NeglectedOrDelinquentStatusDescription] [nvarchar](100) NULL,
		[NeglectedOrDelinquentProgramTypeCode] [nvarchar](50) NULL,
		[NeglectedOrDelinquentProgramTypeDescription] [nvarchar](100) NULL,
		[NeglectedOrDelinquentProgramTypeEdFactsCode] [nvarchar](50) NULL,
		[NeglectedOrDelinquentLongTermStatusCode] [nvarchar](50) NULL,
		[NeglectedOrDelinquentLongTermStatusDescription] [nvarchar](100) NULL,
		[NeglectedOrDelinquentLongTermStatusEdFactsCode] [nvarchar](50) NULL,
		[NeglectedOrDelinquentProgramEnrollmentSubpartCode] [nvarchar](50) NULL,
		[NeglectedOrDelinquentProgramEnrollmentSubpartDescription] [nvarchar](100) NULL,
		[NeglectedProgramTypeCode] [nvarchar](50) NULL,
		[NeglectedProgramTypeDescription] [nvarchar](100) NULL,
		[NeglectedProgramTypeEdFactsCode] [nvarchar](50) NULL,
		[DelinquentProgramTypeCode] [nvarchar](50) NULL,
		[DelinquentProgramTypeDescription] [nvarchar](100) NULL,
		[DelinquentProgramTypeEdFactsCode] [nvarchar](50) NULL,
		[NeglectedOrDelinquentAcademicAchievementIndicatorCode] [nvarchar](50) NULL,
		[NeglectedOrDelinquentAcademicAchievementIndicatorDescription] [nvarchar](100) NULL,
		[NeglectedOrDelinquentAcademicOutcomeIndicatorCode] [nvarchar](50) NULL,
		[NeglectedOrDelinquentAcademicOutcomeIndicatorDescription] [nvarchar](100) NULL,
	 CONSTRAINT [PK_DimNorDStatuses] PRIMARY KEY NONCLUSTERED 
	(
		[DimNOrDStatusId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]

	------------------------------------------------
	-- Populate DimNOrDStatuses			 ---
	------------------------------------------------

	CREATE TABLE #NeglectedOrDelinquentProgramType (NeglectedOrDelinquentProgramTypeCode VARCHAR(50), NeglectedOrDelinquentProgramTypeDescription VARCHAR(200), NeglectedOrDelinquentProgramTypeEdFactsCode VARCHAR(50))

	INSERT INTO #NeglectedOrDelinquentProgramType VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #NeglectedOrDelinquentProgramType
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CASE CedsOptionSetCode
			WHEN 'AdultCorrection' THEN 'ADLTCORR'
			WHEN 'AtRiskPrograms' THEN 'ATRISK'
			WHEN 'JuvenileCorrection' THEN 'JUVCORR'
			WHEN 'JuvenileDetention' THEN 'JUVDET'
			WHEN 'NeglectedPrograms' THEN 'NEGLECT'
			WHEN 'OtherPrograms' THEN 'OTHER'
		END
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'NeglectedOrDelinquentProgramType'

	CREATE TABLE #NeglectedProgramType (NeglectedProgramTypeCode VARCHAR(50), NeglectedProgramTypeDescription VARCHAR(200), NeglectedProgramTypeEdFactsCode VARCHAR(50))

	INSERT INTO #NeglectedProgramType VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #NeglectedProgramType
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CedsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'NeglectedProgramType'

	CREATE TABLE #DelinquentProgramType (DelinquentProgramTypeCode VARCHAR(50), DelinquentProgramTypeDescription VARCHAR(200), DelinquentProgramTypeEdFactsCode VARCHAR(50))

	INSERT INTO #DelinquentProgramType VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #DelinquentProgramType
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CedsOptionSetCode
	FROM [CEDS].CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'DelinquentProgramType'

	INSERT INTO RDS.DimNOrDStatuses (
		[NeglectedOrDelinquentStatusCode]
		, [NeglectedOrDelinquentStatusDescription]
		, [NeglectedOrDelinquentProgramTypeCode]
		, [NeglectedOrDelinquentProgramTypeDescription]
		, [NeglectedOrDelinquentProgramTypeEdFactsCode]
		, [NeglectedOrDelinquentLongTermStatusCode]
		, [NeglectedOrDelinquentLongTermStatusDescription]
		, [NeglectedOrDelinquentLongTermStatusEdFactsCode]
		, [NeglectedOrDelinquentProgramEnrollmentSubpartCode]
		, [NeglectedOrDelinquentProgramEnrollmentSubpartDescription]
		, [NeglectedProgramTypeCode]
		, [NeglectedProgramTypeDescription]
		, [NeglectedProgramTypeEdFactsCode]
		, [DelinquentProgramTypeCode]
		, [DelinquentProgramTypeDescription]
		, [DelinquentProgramTypeEdFactsCode]
		, [NeglectedOrDelinquentAcademicAchievementIndicatorCode]
		, [NeglectedOrDelinquentAcademicAchievementIndicatorDescription]
		, [NeglectedOrDelinquentAcademicOutcomeIndicatorCode]
		, [NeglectedOrDelinquentAcademicOutcomeIndicatorDescription]
	)
	SELECT 		
		NorD.CedsOptionSetCode
		, NorD.CedsOptionSetDescription
		, ndpt.NeglectedOrDelinquentProgramTypeCode
		, ndpt.NeglectedOrDelinquentProgramTypeDescription
		, ndpt.NeglectedOrDelinquentProgramTypeEdFactsCode
		, NorDLongTerm.CedsOptionSetCode	
		, NorDLongTerm.CedsOptionSetDescription
		, NorDLongTerm.EdFactsCode	
		, NorDSubpart.CedsOptionSetCode	
		, NorDSubpart.CedsOptionSetDescription
		, npt.NeglectedProgramTypeCode
		, npt.NeglectedProgramTypeDescription
		, npt.NeglectedProgramTypeEdFactsCode
		, dpt.DelinquentProgramTypeCode
		, dpt.DelinquentProgramTypeDescription
		, dpt.DelinquentProgramTypeEdFactsCode
		, NorDAcademicAchievement.CedsOptionSetCode	
		, NorDAcademicAchievement.CedsOptionSetDescription
		, NorDAcademicOutcome.CedsOptionSetCode	
		, NorDAcademicOutcome.CedsOptionSetDescription
	FROM (VALUES('Yes', 'N or D student'),('MISSING', 'MISSING')) NorD(CedsOptionSetCode, CedsOptionSetDescription)
	CROSS JOIN (VALUES('NDLONGTERM', 'Long-Term N or D Students', 'NDLONGTERM'),('MISSING', 'MISSING', 'MISSING')) NorDLongTerm(CedsOptionSetCode, CedsOptionSetDescription, EdFactsCode)
	CROSS JOIN (VALUES('Subpart1', 'Subpart 1'),('Subpart2', 'Subpart 2'),('MISSING', 'MISSING')) NorDSubpart(CedsOptionSetCode, CedsOptionSetDescription)
	CROSS JOIN (VALUES('Yes', 'Yes'),('No', 'No'),('MISSING', 'MISSING')) NorDAcademicAchievement(CedsOptionSetCode, CedsOptionSetDescription)
	CROSS JOIN (VALUES('Yes', 'Yes'),('No', 'No'),('MISSING', 'MISSING')) NorDAcademicOutcome(CedsOptionSetCode, CedsOptionSetDescription)
	CROSS JOIN #NeglectedOrDelinquentProgramType ndpt
	CROSS JOIN #NeglectedProgramType npt
	CROSS JOIN #DelinquentProgramType dpt
	LEFT JOIN RDS.DimNOrDStatuses dnds
		ON NorD.CedsOptionSetCode = dnds.NeglectedOrDelinquentStatusCode
		AND ndpt.NeglectedOrDelinquentProgramTypeCode = dnds.NeglectedOrDelinquentProgramTypeCode
		AND NorDLongTerm.CedsOptionSetCode = dnds.NeglectedOrDelinquentLongTermStatusCode
		AND NorDSubpart.CedsOptionSetCode = dnds.NeglectedOrDelinquentProgramEnrollmentSubpartCode
		AND npt.NeglectedProgramTypeCode = dnds.NeglectedProgramTypeCode
		AND dpt.DelinquentProgramTypeCode = dnds.DelinquentProgramTypeCode
		AND NorDAcademicAchievement.CedsOptionSetCode = dnds.NeglectedOrDelinquentAcademicAchievementIndicatorCode
		AND NorDAcademicOutcome.CedsOptionSetCode = dnds.NeglectedOrDelinquentAcademicOutcomeIndicatorCode
	WHERE dnds.DimNOrDStatusId IS NULL
	AND NorD.CedsOptionSetCode = 'Yes'

	DROP TABLE #NeglectedOrDelinquentProgramType
	DROP TABLE #NeglectedProgramType
	DROP TABLE #DelinquentProgramType

	--Add constraints back 
	IF OBJECT_ID('FK_FactSpecialEducation_NOrDStatusId', 'F') IS NULL
	BEGIN
		ALTER TABLE [RDS].[FactSpecialEducation]  WITH CHECK ADD CONSTRAINT [FK_FactSpecialEducation_NOrDStatusId] FOREIGN KEY([NOrDStatusId])
		REFERENCES [RDS].[DimNOrDStatuses] ([DimNOrDStatusId]);

		ALTER TABLE [RDS].[FactSpecialEducation] CHECK CONSTRAINT [FK_FactSpecialEducation_NOrDStatusId];
	END

	IF OBJECT_ID('FK_FactK12StudentCounts_NOrDStatusId', 'F') IS NULL
	BEGIN
		ALTER TABLE [RDS].[FactK12StudentAssessments]  WITH CHECK ADD CONSTRAINT [FK_FactK12StudentAssessments_NOrDStatusId] FOREIGN KEY([NOrDStatusId])
		REFERENCES [RDS].[DimNOrDStatuses] ([DimNOrDStatusId]);

		ALTER TABLE [RDS].[FactK12StudentAssessments] CHECK CONSTRAINT [FK_FactK12StudentAssessments_NOrDStatusId];
	END

	IF OBJECT_ID('FK_FactK12StudentEnrollments_NOrDStatusId', 'F') IS NULL
	BEGIN
		ALTER TABLE [RDS].[FactK12StudentEnrollments]  WITH CHECK ADD CONSTRAINT [FK_FactK12StudentEnrollments_NOrDStatusId] FOREIGN KEY([NOrDStatusId])
		REFERENCES [RDS].[DimNOrDStatuses] ([DimNOrDStatusId]);

		ALTER TABLE [RDS].[FactK12StudentEnrollments] CHECK CONSTRAINT [FK_FactK12StudentEnrollments_NOrDStatusId];
	END

--update the existing report table records to remove the 'c'
	update rds.ReportEDFactsOrganizationCounts
	set ReportCode = substring(ReportCode,2,3)
	where len(ReportCode) = 4
	and substring(ReportCode,1,1) = 'c'

--update the FactTypeDescription column in rds.DimFactTypes with the latest changes
	update rds.DimFactTypes
	set FactTypeDescription = 'CTE - 082,083,154,155,156,158,169'
	where FactTypeCode = 'cte'

	update rds.DimFactTypes
	set FactTypeDescription = 'Directory related reports - 029,035,039,129,130,131,132,163,170,190,193,196,197,198,205,206,207,223'
	where FactTypeCode = 'directory'
