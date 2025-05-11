CREATE VIEW [debug].[vwTitleIIIELOct_FactTable] 
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

			, Races.RaceEdFactsCode
			, Grades.GradeLevelEdFactsCode
			, Languages.Iso6392LanguageCodeEdFactsCode

			--IDEA Indicator
			, Idea.IdeaIndicatorEdFactsCode
			--English Learner
			, EL.EnglishLearnerStatusEdFactsCode

 	FROM		RDS.FactK12StudentCounts				Fact
	JOIN		RDS.DimSchoolYears						SchoolYears	ON Fact.SchoolYearId				= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes 	DMT			ON SchoolYears.dimschoolyearid		= DMT.dimschoolyearid		
    LEFT JOIN   RDS.DimPeople		              		Students	ON Fact.K12StudentId				= Students.DimPersonId	AND Students.IsActiveK12Student = 1
	LEFT JOIN	RDS.DimSeas                            	SEA         ON Fact.SeaId  						= SEA.DimSeaId
	LEFT JOIN	RDS.DimLeas								LEAs		ON Fact.LeaId						= LEAs.DimLeaId
	LEFT JOIN	RDS.DimK12Schools						Schools		ON Fact.K12SchoolId					= Schools.DimK12SchoolId
	LEFT JOIN	RDS.DimEnglishLearnerStatuses			EL			ON Fact.EnglishLearnerStatusId		= EL.DimEnglishLearnerStatusId
	LEFT JOIN 	RDS.DimLanguages						Languages	ON Fact.LanguageId					= Languages.DimLanguageId			
	LEFT JOIN	RDS.DimRaces							Races		ON Fact.RaceId						= Races.DimRaceId
	LEFT JOIN	RDS.DimGradeLevels						Grades		ON Fact.GradeLevelId				= Grades.DimGradeLevelId
	LEFT JOIN	RDS.DimIdeaStatuses						Idea		ON Fact.IdeaStatusId				= Idea.DimIdeaStatusId
	
	WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 3
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2024
	AND Fact.FactTypeId = 9
	AND EL.EnglishLearnerStatusEdFactsCode = 'LEP'
