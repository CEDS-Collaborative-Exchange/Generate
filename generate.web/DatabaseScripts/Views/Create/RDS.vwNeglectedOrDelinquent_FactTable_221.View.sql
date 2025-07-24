CREATE VIEW [RDS].[vwNeglectedOrDelinquent_FactTable_221] 
AS
	SELECT  f.[SchoolYear]
			, f.[K12StudentStudentIdentifierState]
			, f.[NeglectedOrDelinquentStatusCode]
			, f.[NeglectedOrDelinquentProgramEnrollmentSubpartCode]
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
    FROM  [debug].[vwNeglectedOrDelinquent_FactTable] f
    WHERE f.NeglectedOrDelinquentStatusCode = 'Yes'
	    AND f.NeglectedOrDelinquentProgramEnrollmentSubpartCode = '2'
