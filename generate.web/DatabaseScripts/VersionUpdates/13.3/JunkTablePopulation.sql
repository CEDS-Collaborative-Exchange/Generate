	-------------------------------------------------------------------------
	-- Populate DimCharterSchoolStatuses   --
	-------------------------------------------------------------------------

	IF NOT EXISTS (SELECT 1 FROM RDS.DimCharterSchoolStatuses d WHERE d.DimCharterSchoolStatusId = -1) 
	BEGIN
		SET IDENTITY_INSERT rds.DimCharterSchoolStatuses ON

			INSERT INTO rds.DimCharterSchoolStatuses (
					DimCharterSchoolStatusId
					, AppropriationMethodCode
					, AppropriationMethodDescription
					, AppropriationMethodEdFactsCode
			)
			VALUES (
					-1
					, 'MISSING'
					, 'MISSING'
					, 'MISSING')

		SET IDENTITY_INSERT rds.DimCharterSchoolStatuses OFF
	END;

	DBCC CHECKIDENT ('RDS.DimCharterSchoolStatuses', RESEED, 0);

	IF OBJECT_ID('tempdb..#AppropriationMethod') IS NOT NULL BEGIN
		DROP TABLE #AppropriationMethod
	END;

	CREATE TABLE #AppropriationMethod (AppropriationMethodCode VARCHAR(50), AppropriationMethodDescription VARCHAR(200), AppropriationMethodEdFactsCode VARCHAR(50))

	--Insert the default rows until the CEDS table is updated
	INSERT INTO #AppropriationMethod VALUES ('STEAPRDRCT', 'Direct from state', 'STEAPRDRCT')
	INSERT INTO #AppropriationMethod VALUES ('STEAPRTHRULEA', 'Through local school district', 'STEAPRTHRULEA')
	INSERT INTO #AppropriationMethod VALUES ('STEAPRALLOCLEA', 'Allocation by local school district', 'STEAPRALLOCLEA')
	INSERT INTO #AppropriationMethod VALUES ('MISSING', 'Missing', 'MISSING')

	--INSERT INTO #AppropriationMethod 
	--SELECT
	--	  CedsOptionSetCode
	--	, CedsOptionSetDescription
	--	, EdFactsOptionSetCode
	--FROM [CEDS].CedsOptionSetMapping
	--WHERE CedsElementTechnicalName = 'CharterSchoolAppropriationMethod'

	INSERT INTO rds.DimCharterSchoolStatuses (
        AppropriationMethodCode
        , AppropriationMethodDescription
        , AppropriationMethodEdFactsCode
    )
	SELECT 
		a.AppropriationMethodCode
		, a.AppropriationMethodDescription
		, a.AppropriationMethodEdFactsCode
	FROM #AppropriationMethod a
	LEFT JOIN RDS.DimCharterSchoolStatuses main
		ON	a.AppropriationMethodCode = main.AppropriationMethodCode
	WHERE main.DimCharterSchoolStatusId IS NULL

	DROP TABLE #AppropriationMethod


