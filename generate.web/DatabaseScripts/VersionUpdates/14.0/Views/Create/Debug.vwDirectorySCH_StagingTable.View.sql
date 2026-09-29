CREATE VIEW [Debug].[vwDirectorySCH_StagingTable] 
AS

	SELECT		
				 LeaIdentifierSea
				,PriorLeaIdentifierSea
				,LeaIdentifierNCES
				,LeaOrganizationName
				,LEA_WebSiteAddress
				,LEA_OperationalStatus
				,LEA_OperationalStatusEffectiveDate
				, CASE LEA_IsReportedFederally
				  WHEN 1 THEN 'Yes'
				  WHEN 0 THEN 'No'
				  ELSE 'MISSING' END AS LEA_ReportedFederally	
				,LEA_CharterLeaStatus
				,LEA_CharterSchoolIndicator
				,LEA_Type
				,SchoolIdentifierSea
				,SchoolIdentifierNCES
				,SchoolOrganizationName
				,School_WebSiteAddress
				,School_OperationalStatus
				,School_OperationalStatusEffectiveDate
				, CASE School_IsReportedFederally
				  WHEN 1 THEN 'Yes'
				  WHEN 0 THEN 'No'
				  ELSE 'MISSING' END AS School_ReportedFederally	
				,School_Type
				,School_ReconstitutedStatus
				,School_CharterSchoolIndicator
				,School_CharterPrimaryAuthorizer
				,SchoolYear
				,LEA_RecordStartDateTime
				,LEA_RecordEndDateTime
				,School_RecordStartDateTime
				,School_RecordEndDateTime

	FROM Staging.K12Organization

	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	AND SchoolIdentifierSea IS NOT NULL -- Remove records that are only LEAs by checking for populated school identifier
	--AND SchoolIdentifierSea = '12345678'
	--AND SchoolOrganizationName = 'School Name'
	--AND School_OperationalStatus = 'Open_1'
	--AND School_IsReportedFederally = 1
	--AND LeaIdentifierSea = '12345678'
	--AND LeaOrganizationName = 'LEA Name'
	--AND LEA_OperationalStatus = 'Open_1'
	--AND LEA_IsReportedFederally = 1
