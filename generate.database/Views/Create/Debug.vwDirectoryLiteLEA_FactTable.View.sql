CREATE VIEW [Debug].[vwDirectoryLiteLEA_FactTable] 
AS
SELECT DISTINCT	
			Fact.SchoolYearId
			, SchoolYears.SchoolYear
			, LEAs.LeaIdentifierSea								AS LEA_Identifier
			, LEAs.LeaOrganizationName							AS LEA_Name
			, CASE LEAs.ReportedFederally
				WHEN 1 THEN 'Yes'
				WHEN 0 THEN 'No'
			ELSE 'MISSING' END									AS LEA_ReportedFederally
			, LEAs.LeaTypeCode									AS LEA_Type
			, LEAs.LeaOperationalStatus							AS LEA_OperationalStatus
			, LEAs.OperationalStatusEffectiveDate				AS LEA_OperationalStatusEffectiveDate
			, LEAs.RecordStartDateTime							AS LEA_RecordStartDateTime
			, LEAs.RecordEndDateTime							AS LEA_RecordEndDateTime
 	FROM		RDS.FactOrganizationCounts			Fact
	JOIN		RDS.DimSchoolYears					SchoolYears		ON Fact.SchoolYearId				= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes DMT				ON SchoolYears.DimSchoolYearId		= DMT.DimSchoolYearId		
	LEFT JOIN	RDS.DimLeas							LEAs			ON Fact.LeaId						= LEAs.DimLeaId

	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 2
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2023

	AND Fact.FactTypeId = 21
	AND Fact.LeaId > -1	
	--AND LEAs.LeaIdentifierSea = '123'
	--AND LEAs.LeaOperationalStatus = 'Open'      				--'Open', 'Closed', 'New', 'FutureAgency'
	--AND LEAs.LeaTypeCode = 'RegularNotInSupervisoryUnion' 	--'FederalOperatedAgency','IndependentCharterDistrict','Other','RegularNotInSupervisoryUnion','ServiceAgency','StateOperatedAgency'


