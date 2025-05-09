CREATE VIEW [debug].[vwGraduationRate_FactTable] 
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

			, Demo.SexEdFactsCode
			, Races.RaceEdFactsCode
			, Diploma.HighSchoolDiplomaTypeEdFactsCode
			, Cohort.CohortStatusEdFactsCode

			--Homeless	
			, Home.HomelessnessStatusCode
			--IDEA Indicator
			, Idea.IdeaIndicatorEdFactsCode
			--English Learner
			, EL.EnglishLearnerStatusEdFactsCode
			--Foster Care 
			, Foster.ProgramParticipationFosterCareEdFactsCode
			--Economically Disadvantaged
			, EcoDis.EconomicDisadvantageStatusEdFactsCode

 	FROM		RDS.FactK12StudentCounts					Fact
	JOIN		RDS.DimSchoolYears							SchoolYears	ON Fact.SchoolYearId						= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes 		DMT			ON SchoolYears.dimschoolyearid				= DMT.dimschoolyearid		
	LEFT JOIN	RDS.DimPeople								Students	ON Fact.K12StudentId						= Students.DimPersonId	AND Students.IsActiveK12Student = 1
	LEFT JOIN	RDS.DimSeas                             	SEA         ON Fact.SeaId    							= SEA.DimSeaId
	LEFT JOIN	RDS.DimLeas									LEAs		ON Fact.LeaId								= LEAs.DimLeaId
	LEFT JOIN	RDS.DimK12Schools							Schools		ON Fact.K12SchoolId							= Schools.DimK12SchoolId
	LEFT JOIN	RDS.DimCohortStatuses						Cohort		ON Fact.CohortStatusId						= Cohort.DimCohortStatusId
	LEFT JOIN	RDS.DimK12Demographics						Demo		ON Fact.K12DemographicId					= Demo.DimK12DemographicId
	LEFT JOIN	RDS.DimRaces								Races		ON Fact.RaceId								= Races.DimRaceId
	LEFT JOIN	RDS.BridgeLeaGradeLevels					LeaGrades	ON LEAs.DimLeaId							= LeaGrades.LeaId
	LEFT JOIN	RDS.BridgeK12SchoolGradeLevels				SchGrades	ON Schools.DimK12SchoolId					= SchGrades.K12SchoolId
	LEFT JOIN	RDS.DimIdeaStatuses							Idea		ON Fact.IdeaStatusId						= Idea.DimIdeaStatusId
	LEFT JOIN	RDS.DimEnglishLearnerStatuses				EL			ON Fact.EnglishLearnerStatusId				= EL.DimEnglishLearnerStatusId
	LEFT JOIN	RDS.DimHomelessnessStatuses					Home		ON Fact.HomelessnessStatusId				= Home.DimHomelessnessStatusId
	LEFT JOIN	RDS.DimFosterCareStatuses					Foster		ON Fact.FosterCareStatusId					= Foster.DimFosterCareStatusId
	LEFT JOIN	RDS.DimEconomicallyDisadvantagedStatuses	EcoDis		ON Fact.EconomicallyDisadvantagedStatusId	= EcoDis.DimEconomicallyDisadvantagedStatusId
	LEFT JOIN	RDS.DimK12AcademicAwardStatuses				Diploma		ON Fact.K12AcademicAwardStatusId			= Diploma.DimK12AcademicAwardStatusId
	
	WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 3
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2024
	AND Fact.FactTypeId = 18
	AND ISNULL(LeaGrades.GradeLevelId, '') = 14	--12th Grade
	AND ISNULL(SchGrades.GradeLevelId, '') = 14	--12th Grade

