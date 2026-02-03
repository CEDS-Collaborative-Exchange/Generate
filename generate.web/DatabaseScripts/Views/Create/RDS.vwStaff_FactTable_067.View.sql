CREATE VIEW [RDS].[vwStaff_FactTable_067] 
AS
	SELECT 	f.[FactK12StaffCountId]
			, f.[SchoolYear]
		  	, f.[K12StaffId]
			, f.[K12StaffStaffMemberIdentifierState]
		  	, f.[StateANSICode]
		  	, f.[StateAbbreviationCode]
		  	, f.[StateAbbreviationDescription]
		  	, f.[SeaOrganizationIdentifierSea]
		  	, f.[SeaOrganizationName]
		  	, f.[LeaIdentifierSea]
		  	, f.[LeaOrganizationName]
		  	, f.[SchoolIdentifierSea]
		  	, f.[DimK12SchoolId]
		  	, f.[NameOfInstitution]
		  	, f.[SchoolOperationalStatus]
		  	, f.[SchoolTypeCode]
	  		, f.[EdFactsCertificationStatusEdFactsCode]
			, f.[TitleIIILanguageInstructionIndicatorCode]
	FROM [debug].[vwStaff_FactTable] f
	WHERE SchoolOperationalStatus NOT IN ('Closed', 'Inactive', 'FutureAgency') 
	AND TitleIIILanguageInstructionIndicatorCode = 'Yes'
