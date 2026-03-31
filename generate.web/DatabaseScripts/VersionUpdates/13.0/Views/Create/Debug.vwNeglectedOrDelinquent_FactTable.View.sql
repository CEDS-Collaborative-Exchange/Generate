CREATE VIEW [debug].[vwNeglectedOrDelinquent_FactTable] 
AS
	SELECT	 Fact.FactK12StudentCountId
			, SchoolYear
			, Fact.K12StudentId
			, Students.K12StudentStudentIdentifierState
			, Students.BirthDate
			, Students.FirstName
			, Students.LastOrSurname
			, Students.MiddleName
			, SEA.StateANSICode
			, SEA.StateAbbreviationCode
			, SEA.StateAbbreviationDescription
			, SEA.SeaOrganizationIdentifierSea
			, SEA.SeaOrganizationName
			, LEAs.LeaIdentifierSea
			, LEAs.LeaOrganizationName
			, Schools.SchoolIdentifierSea
			, Schools.DimK12SchoolId
			, Schools.NameOfInstitution
			, Schools.SchoolOperationalStatus
			, Schools.SchoolTypeCode

			--Neglected or Delinquent 
			, NorD.NeglectedOrDelinquentStatusCode
			, NorD.NeglectedOrDelinquentStatusDescription
			, NorD.NeglectedOrDelinquentProgramTypeCode
			, NorD.NeglectedOrDelinquentProgramTypeDescription
			, NorD.NeglectedOrDelinquentProgramTypeEdFactsCode
			, NorD.NeglectedOrDelinquentLongTermStatusCode
			, NorD.NeglectedOrDelinquentLongTermStatusDescription
			, NorD.NeglectedOrDelinquentLongTermStatusEdFactsCode
			, NorD.NeglectedOrDelinquentProgramEnrollmentSubpartCode
			, NorD.NeglectedOrDelinquentProgramEnrollmentSubpartDescription
			, NorD.NeglectedProgramTypeCode
			, NorD.NeglectedProgramTypeDescription
			, NorD.NeglectedProgramTypeEdFactsCode
			, NorD.DelinquentProgramTypeCode
			, NorD.DelinquentProgramTypeDescription
			, NorD.DelinquentProgramTypeEdFactsCode
			, NorD.NeglectedOrDelinquentAcademicAchievementIndicatorCode
			, NorD.NeglectedOrDelinquentAcademicAchievementIndicatorDescription
			, NorD.NeglectedOrDelinquentAcademicOutcomeIndicatorCode
			, NorD.NeglectedOrDelinquentAcademicOutcomeIndicatorDescription

 	FROM		RDS.FactK12StudentCounts			Fact
	JOIN		RDS.DimSchoolYears					SchoolYears		ON Fact.SchoolYearId			= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes DMT				ON SchoolYears.dimschoolyearid	= DMT.dimschoolyearid
	JOIN		RDS.DimSeas							SEA				ON Fact.SeaId					= SEA.DimSeaId
	LEFT JOIN	RDS.DimPeople						Students		ON Fact.K12StudentId			= Students.DimPersonId	AND Students.IsActiveK12Student = 1
	LEFT JOIN	RDS.DimLeas							LEAs			ON Fact.LeaId					= LEAs.DimLeaId
	LEFT JOIN	RDS.DimK12Schools					Schools			ON Fact.K12SchoolId				= Schools.DimK12SchoolId
	LEFT JOIN	RDS.DimNorDStatuses					NorD			ON Fact.NorDStatusId			= NorD.DimNorDStatusId

	WHERE 1 = 1
	----2 ways to select by SchoolYear, use 1 or the other, not both
	----the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 3
	----or comment out the lines above and just set the SchoolYear
	--	--AND SchoolYears.SchoolYear = 2024
	AND Fact.FactTypeId = 15


