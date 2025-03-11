

	------------------------------------------------
	-- Populate DimAssessmentStatuses			 ---
	------------------------------------------------

	IF OBJECT_ID('rds.[FK_FactK12StudentAssessments_AssessmentStatusId]', 'F') IS NOT NULL 
	BEGIN
		ALTER TABLE [RDS].[FactK12StudentAssessments] DROP CONSTRAINT [FK_FactK12StudentAssessments_AssessmentStatusId]
	END

    --Drop the partially created values from the table
	DELETE FROM RDS.DimAssessmentStatuses 

	IF NOT EXISTS (SELECT 1 FROM RDS.DimAssessmentStatuses 
			WHERE ProgressLevelCode = 'MISSING'
			AND AssessedFirstTimeCode = 'MISSING'
			) 
	BEGIN
		SET IDENTITY_INSERT RDS.DimAssessmentStatuses ON

		INSERT INTO RDS.DimAssessmentStatuses (
			 DimAssessmentStatusId
			,ProgressLevelCode
			,ProgressLevelDescription
			,ProgressLevelEdFactsCode
			,AssessedFirstTimeCode
			,AssessedFirstTimeDescription
			,AssessedFirstTimeEdFactsCode
		)
		VALUES (-1, 'MISSING','MISSING','MISSING','MISSING','MISSING','MISSING')

		SET IDENTITY_INSERT RDS.DimAssessmentStatuses OFF
	END

	--ProgressLevel
	IF OBJECT_ID('tempdb..#ProgressLevel') IS NOT NULL 
	BEGIN
		DROP TABLE #ProgressLevel
	END

	CREATE TABLE #ProgressLevel (ProgressLevelCode VARCHAR(50), ProgressLevelDescription VARCHAR(100), ProgressLevelEdFactsCode VARCHAR(50))

	INSERT INTO #ProgressLevel VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #ProgressLevel
	SELECT
		  CedsOptionSetCode
		, CedsOptionSetDescription
		, CedsOptionSetCode
	FROM CEDS.CedsOptionSetMapping
	WHERE CedsElementTechnicalName = 'ProgressLevel'

	--AssessedFirstTime
	IF OBJECT_ID('tempdb..#AssessedFirstTime') IS NOT NULL 
	BEGIN
		DROP TABLE #AssessedFirstTime
	END

	CREATE TABLE #AssessedFirstTime (AssessedFirstTimeCode VARCHAR(50), AssessedFirstTimeDescription VARCHAR(200), AssessedFirstTimeEdFactsCode VARCHAR(50))

	INSERT INTO #AssessedFirstTime VALUES ('MISSING', 'MISSING', 'MISSING')
	INSERT INTO #AssessedFirstTime VALUES ('FIRSTASSESS', 'Assessed FirstTime', 'FIRSTASSESS')

	   	 
	INSERT INTO [RDS].[DimAssessmentStatuses]
           ([ProgressLevelCode]
           ,[ProgressLevelDescription]
           ,[ProgressLevelEdFactsCode]
           ,[AssessedFirstTimeCode]
           ,[AssessedFirstTimeDescription]
           ,[AssessedFirstTimeEdFactsCode])
	SELECT 
       progLevel.ProgressLevelCode, progLevel.ProgressLevelDescription, progLevel.ProgressLevelEdFactsCode,
	   assessedFirstTime.AssessedFirstTimeCode, assessedFirstTime.AssessedFirstTimeDescription, assessedFirstTime.AssessedFirstTimeEdFactsCode
	FROM #ProgressLevel progLevel
    CROSS JOIN #AssessedFirstTime assessedFirstTime
	LEFT JOIN rds.DimAssessmentStatuses main
		ON progLevel.ProgressLevelCode = main.ProgressLevelCode
        AND assessedFirstTime.AssessedFirstTimeCode = main.AssessedFirstTimeCode
	WHERE main.DimAssessmentStatusId IS NULL

	DROP TABLE #ProgressLevel
    DROP TABLE #AssessedFirstTime


--Add the Fact table constraints back in
	IF OBJECT_ID('rds.[FK_FactK12StudentAssessments_AssessmentStatusId]', 'F') IS NULL 
	BEGIN
		ALTER TABLE [RDS].[FactK12StudentAssessments] WITH NOCHECK ADD CONSTRAINT [FK_FactK12StudentAssessments_AssessmentStatusId] FOREIGN KEY([AssessmentStatusId])
		REFERENCES [RDS].[DimAssessmentStatuses]([DimAssessmentStatusId])

		ALTER TABLE [RDS].[FactK12StudentAssessments] CHECK CONSTRAINT [FK_FactK12StudentAssessments_AssessmentStatusId]
	END
		

