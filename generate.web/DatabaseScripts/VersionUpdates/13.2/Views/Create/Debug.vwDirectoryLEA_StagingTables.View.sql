CREATE VIEW [Debug].[vwDirectoryLEA_StagingTables] 
AS

	SELECT	DISTINCT	
			  LeaIdentifierSea
			, PriorLeaIdentifierSea
			, LeaIdentifierNCES
			, LeaOrganizationName
			, LEA_WebSiteAddress
			, LEA_OperationalStatus
			, LEA_OperationalStatusEffectiveDate
			, CASE LEA_IsReportedFederally
				WHEN 1 THEN 'Yes'
				WHEN 0 THEN 'No'
			  ELSE 'MISSING' END AS LEA_ReportedFederally	
			, LEA_CharterLeaStatus
			, LEA_CharterSchoolIndicator
			, LEA_Type
			, SchoolYear
			, LEA_RecordStartDateTime
			, LEA_RecordEndDateTime
	FROM Staging.K12Organization
	
	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--AND LeaIdentifierSea = '12345678'
	--AND LeaOrganizationName = 'LEA Org Name'
	--AND LeaIdentifierSea = '00000B'	
	--AND LEA_OperationalStatus = 'Open_1'
	--AND LEA_IsReportedFederally = 1
