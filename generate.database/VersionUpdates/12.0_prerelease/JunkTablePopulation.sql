	------------------------------------------------
	-- Populate DimNOrDStatuses			 ---
	------------------------------------------------
    --Drop the partially created values from the table
	ALTER TABLE [RDS].[FactK12StudentDisciplines] DROP CONSTRAINT [FK_FactK12StudentDisciplines_NOrDStatusId];
	ALTER TABLE [RDS].[FactK12StudentCounts] DROP CONSTRAINT [FK_FactK12StudentCounts_NOrDStatusId];


	DELETE FROM RDS.DimNOrDStatuses 

	IF NOT EXISTS (SELECT 1 FROM RDS.DimNOrDStatuses 
			WHERE NeglectedOrDelinquentLongTermStatusCode = 'MISSING'
			AND NeglectedOrDelinquentProgramTypeCode = 'MISSING'
			AND NeglectedProgramTypeCode = 'MISSING'
			AND DelinquentProgramTypeCode = 'MISSING'
			AND EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode = 'MISSING'
			AND EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode = 'MISSING') 
	BEGIN
		SET IDENTITY_INSERT RDS.DimNOrDStatuses ON

		INSERT INTO RDS.DimNOrDStatuses (
			DimNOrDStatusId
			,NeglectedOrDelinquentLongTermStatusCode
			,NeglectedOrDelinquentLongTermStatusDescription
			,NeglectedOrDelinquentLongTermStatusEdFactsCode
			,NeglectedOrDelinquentProgramTypeCode
			,NeglectedOrDelinquentProgramTypeDescription
			,NeglectedOrDelinquentProgramTypeEdFactsCode
			,NeglectedProgramTypeCode
			,NeglectedProgramTypeDescription
			,NeglectedProgramTypeEdFactsCode
			,DelinquentProgramTypeCode
			,DelinquentProgramTypeDescription
			,DelinquentProgramTypeEdFactsCode
            ,NeglectedOrDelinquentAcademicAchievementIndicatorCode
            ,NeglectedOrDelinquentAcademicAchievementIndicatorDescription
            ,NeglectedOrDelinquentAcademicOutcomeIndicatorCode
            ,NeglectedOrDelinquentAcademicOutcomeIndicatorDescription
			,EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode
			,EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription
			,EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode
			,EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode
			,EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription
            ,EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode
		)
		VALUES (-1, 'MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING','MISSING')

		SET IDENTITY_INSERT RDS.DimNOrDStatuses OFF
	END

	IF OBJECT_ID('tempdb..#NeglectedOrDelinquentProgramType') IS NOT NULL 
	BEGIN
		DROP TABLE #NeglectedOrDelinquentProgramType
	END

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
	FROM CEDS.CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'NeglectedOrDelinquentProgramType'

	IF OBJECT_ID('tempdb..#NorDAcademicAchievementIndicator') IS NOT NULL 
	BEGIN
		DROP TABLE #NorDAcademicAchievementIndicator
	END

	CREATE TABLE #NorDAcademicAchievementIndicator (NeglectedOrDelinquentAcademicAchievementIndicatorCode VARCHAR(50), NeglectedOrDelinquentAcademicAchievementIndicatorDescription VARCHAR(100))

	INSERT INTO #NorDAcademicAchievementIndicator VALUES ('MISSING', 'MISSING')
	INSERT INTO #NorDAcademicAchievementIndicator
	    VALUES ('Yes', 'Yes'),
                ('No', 'No')


	IF OBJECT_ID('tempdb..#NorDAcademicOutcomeIndicator') IS NOT NULL 
	BEGIN
		DROP TABLE #NorDAcademicOutcomeIndicator
	END

	CREATE TABLE #NorDAcademicOutcomeIndicator (NeglectedOrDelinquentAcademicOutcomeIndicatorCode VARCHAR(50), NeglectedOrDelinquentAcademicOutcomeIndicatorDescription VARCHAR(100))

	INSERT INTO #NorDAcademicOutcomeIndicator VALUES ('MISSING', 'MISSING')
	INSERT INTO #NorDAcademicOutcomeIndicator
	    VALUES ('Yes', 'Yes'),
                ('No', 'No')


	IF OBJECT_ID('tempdb..#EdFactsAcademicOrCTOutcomeType') IS NOT NULL 
	BEGIN
		DROP TABLE #EdFactsAcademicOrCTOutcomeType
	END

	CREATE TABLE #EdFactsAcademicOrCTOutcomeType (EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode VARCHAR(50), EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription VARCHAR(100), EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode VARCHAR(50))

	INSERT INTO #EdFactsAcademicOrCTOutcomeType VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #EdFactsAcademicOrCTOutcomeType
	SELECT
        CedsOptionSetCode
		, CedsOptionSetDescription
		, CedsOptionSetCode
	FROM CEDS.CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'EdFactsAcademicOrCareerAndTechnicalOutcomeType'

	IF OBJECT_ID('tempdb..#EdFactsAcademicOrCTOutcomeExitType') IS NOT NULL 
	BEGIN
		DROP TABLE #EdFactsAcademicOrCTOutcomeExitType
	END

	CREATE TABLE #EdFactsAcademicOrCTOutcomeExitType (EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode VARCHAR(50), EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription VARCHAR(100), EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode VARCHAR(50))

	INSERT INTO #EdFactsAcademicOrCTOutcomeExitType VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #EdFactsAcademicOrCTOutcomeExitType
	SELECT
        CedsOptionSetCode
		, CedsOptionSetDescription
		, CedsOptionSetCode
	FROM CEDS.CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType'

	IF OBJECT_ID('tempdb..#NeglectedProgramTypeCode') IS NOT NULL 
	BEGIN
		DROP TABLE #NeglectedProgramTypeCode
	END

	CREATE TABLE #NeglectedProgramTypeCode (NeglectedProgramTypeCode VARCHAR(50), NeglectedProgramTypeDescription VARCHAR(100), NeglectedProgramTypeEdFactsCode VARCHAR(50))

	INSERT INTO #NeglectedProgramTypeCode
	VALUES ('CMNTYDAYPRG', 'Community Day Programs', 'CMNTYDAYPRG'),
			('GRPHOMES', 'Group Homes', 'GRPHOMES'),
			('RSDNTLTRTMTHOME','Residential Treatment Home', 'RSDNTLTRTMTHOME'),
			('SHELTERS','Shelters', 'SHELTERS'),
			('OTHER','Other Programs', 'OTHER'),
			('MISSING', 'MISSING', 'MISSING')

	IF OBJECT_ID('tempdb..#DelinquentProgramTypeCode') IS NOT NULL 
	BEGIN
		DROP TABLE #DelinquentProgramTypeCode
	END

	CREATE TABLE #DelinquentProgramTypeCode (DelinquentProgramTypeCode VARCHAR(50), DelinquentProgramTypeDescription VARCHAR(100), DelinquentProgramTypeEdFactsCode VARCHAR(50))

	INSERT INTO #DelinquentProgramTypeCode
	VALUES ('ADLTCORR', 'Adult Correction', 'ADLTCORR'),
			('CMNTYDAYPRG', 'Community Day Programs', 'CMNTYDAYPRG'),
			('GRPHOMES', 'Group Homes', 'GRPHOMES'),
			('JUVDET','Juvenile detention centers', 'JUVDET'),
			('JUVLNGTRMFAC','Long-term secure juvenile facility', 'JUVLNGTRMFAC'),
			('RNCHWLDRNSCMPS','Ranch/wilderness camps', 'RNCHWLDRNSCMPS'),
			('RSDNTLTRTMTCTRS','Residential treatment centers', 'RSDNTLTRTMTCTRS'),
			('SHELTERS','Shelters', 'SHELTERS'),
			('OTHER','Other Programs', 'OTHER'),
			('MISSING', 'MISSING', 'MISSING')

	INSERT INTO RDS.DimNOrDStatuses (
        NeglectedOrDelinquentProgramTypeCode
        , NeglectedOrDelinquentProgramTypeDescription
        , NeglectedOrDelinquentProgramTypeEdFactsCode
        , NeglectedProgramTypeCode
        , NeglectedProgramTypeDescription
        , NeglectedProgramTypeEdFactsCode
        , DelinquentProgramTypeCode
        , DelinquentProgramTypeDescription
        , DelinquentProgramTypeEdFactsCode
        , NeglectedOrDelinquentAcademicAchievementIndicatorCode
        , NeglectedOrDelinquentAcademicAchievementIndicatorDescription
        , NeglectedOrDelinquentAcademicOutcomeIndicatorCode
        , NeglectedOrDelinquentAcademicOutcomeIndicatorDescription
        , EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode
        , EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription
        , EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode
        , EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode
        , EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription
        , EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode
    )
	SELECT 
		nodpt.NeglectedOrDelinquentProgramTypeCode
		, nodpt.NeglectedOrDelinquentProgramTypeDescription
		, nodpt.NeglectedOrDelinquentProgramTypeEdFactsCode
		, nptc.NeglectedProgramTypeCode
		, nptc.NeglectedProgramTypeDescription
		, nptc.NeglectedProgramTypeEdFactsCode
		, dptc.DelinquentProgramTypeCode
		, dptc.DelinquentProgramTypeDescription
		, dptc.DelinquentProgramTypeEdFactsCode
        , naai.NeglectedOrDelinquentAcademicAchievementIndicatorCode
        , naai.NeglectedOrDelinquentAcademicAchievementIndicatorDescription
        , naoi.NeglectedOrDelinquentAcademicOutcomeIndicatorCode
        , naoi.NeglectedOrDelinquentAcademicOutcomeIndicatorDescription
		, acot.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode
		, acot.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeDescription
        , acot.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode
		, acoet.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode
		, acoet.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeDescription
        , acoet.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode
	FROM #NeglectedOrDelinquentProgramType nodpt
	CROSS JOIN #NeglectedProgramTypeCode nptc
	CROSS JOIN #DelinquentProgramTypeCode dptc
    CROSS JOIN #NorDAcademicAchievementIndicator naai
    CROSS JOIN #NorDAcademicOutcomeIndicator naoi
	CROSS JOIN #EdFactsAcademicOrCTOutcomeType acot
	CROSS JOIN #EdFactsAcademicOrCTOutcomeExitType acoet
	LEFT JOIN rds.DimNOrDStatuses main
		ON nodpt.NeglectedOrDelinquentProgramTypeCode = main.NeglectedOrDelinquentProgramTypeCode
		AND nptc.NeglectedProgramTypeCode = main.NeglectedProgramTypeCode
		AND dptc.DelinquentProgramTypeCode = main.DelinquentProgramTypeCode
        AND naai.NeglectedOrDelinquentAcademicAchievementIndicatorCode = main.NeglectedOrDelinquentAcademicAchievementIndicatorCode
        AND naoi.NeglectedOrDelinquentAcademicOutcomeIndicatorCode = main.NeglectedOrDelinquentAcademicOutcomeIndicatorCode
		AND acot.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode = main.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode
		AND acoet.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode = main.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode

	WHERE main.DimNOrDStatusId IS NULL

	DROP TABLE #NeglectedOrDelinquentProgramType
	DROP TABLE #NeglectedProgramTypeCode 
	DROP TABLE #DelinquentProgramTypeCode
    DROP TABLE #NorDAcademicAchievementIndicator
    DROP TABLE #NorDAcademicOutcomeIndicator
	DROP TABLE #EdFactsAcademicOrCTOutcomeType
	DROP TABLE #EdFactsAcademicOrCTOutcomeExitType


