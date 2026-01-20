CREATE VIEW [debug].[vwTitleI_FactTable] 
AS
	SELECT	DISTINCT Fact.FactK12StudentCountId
			, SchoolYears.SchoolYear
			, Fact.K12StudentId
			, Students.K12StudentStudentIdentifierState
			, Students.BirthDate
			, Students.FirstName
			, Students.LastOrSurname
			, Students.MiddleName
			, Demo.SexCode
			, SEA.StateANSICode
			, SEA.StateAbbreviationCode
			, SEA.StateAbbreviationDescription
			, SEA.SeaOrganizationIdentifierSea
			, SEA.SeaOrganizationName
			, LEAs.LeaIdentifierSea
			, LEAs.LeaOrganizationName
			, LEAs.LeaOperationalStatus
			, OrgTitleIL.TitleIProgramTypeCode
			, Schools.SchoolIdentifierSea
			, Schools.DimK12SchoolId
			, Schools.NameOfInstitution
			, Schools.SchoolOperationalStatus
			, Schools.SchoolTypeCode
			, OrgTitleIS.TitleISchoolStatusEdFactsCode
			, TitleI.TitleIIndicatorCode
			, Grades.GradeLevelEdFactsCode
			, Races.RaceEdFactsCode
			--Homeless	
			, Home.HomelessnessStatusEdFactsCode
			--IDEA Indicator
			, Idea.IdeaIndicatorEdFactsCode
			--English Learner
			, EL.EnglishLearnerStatusEdFactsCode
			--Migrant 
			, Mig.MigrantStatusEdFactsCode
			--Foster
			, Foster.ProgramParticipationFosterCareEdFactsCode

 	FROM		RDS.FactK12StudentCounts					Fact
	JOIN		RDS.DimSchoolYears							SchoolYears	ON Fact.SchoolYearId				= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes 		DMT			ON SchoolYears.dimschoolyearid		= DMT.dimschoolyearid		
    LEFT JOIN   RDS.DimPeople				              	Students	ON Fact.K12StudentId				= Students.DimPersonId	AND Students.IsActiveK12Student = 1
	LEFT JOIN	RDS.DimSeas                             	SEA			ON Fact.SeaId    					= SEA.DimSeaId
	LEFT JOIN	RDS.DimLeas									LEAs		ON Fact.LeaId						= LEAs.DimLeaId
	LEFT JOIN	RDS.DimK12Schools							Schools		ON Fact.K12SchoolId					= Schools.DimK12SchoolId
	LEFT JOIN	RDS.DimK12Demographics                  	Demo        ON Fact.K12DemographicId	        = Demo.DimK12DemographicId
	LEFT JOIN	RDS.DimGradeLevels                      	Grades      ON Fact.GradeLevelId		        = Grades.DimGradeLevelId
	LEFT JOIN	RDS.DimRaces								Races		ON Fact.RaceId						= Races.DimRaceId
	LEFT JOIN	RDS.DimIdeaStatuses							Idea		ON Fact.IdeaStatusId				= Idea.DimIdeaStatusId
	LEFT JOIN	RDS.DimEnglishLearnerStatuses				EL			ON Fact.EnglishLearnerStatusId		= EL.DimEnglishLearnerStatusId
	LEFT JOIN	RDS.DimHomelessnessStatuses					Home		ON Fact.HomelessnessStatusId		= Home.DimHomelessnessStatusId
	LEFT JOIN	RDS.DimMigrantStatuses						Mig			ON Fact.MigrantStatusId				= Mig.DimMigrantStatusId
	LEFT JOIN 	RDS.DimFosterCareStatuses					Foster		ON Fact.FosterCareStatusId			= Foster.DimFosterCareStatusId
	LEFT JOIN 	RDS.DimTitleIStatuses						TitleI		ON Fact.TitleIStatusId				= TitleI.DimTitleIStatusId
	--join to FactOrganizationCounts by LEA to get the OrganizatuionTitleIStatus
	LEFT JOIN 	RDS.FactOrganizationCounts					FactLea		ON Fact.LeaId							= FactLea.LeaId			AND Fact.SchoolYearId = FactLea.SchoolYearId	
	LEFT JOIN	RDS.DimOrganizationTitleIStatuses			OrgTitleIL	ON FactLea.OrganizationTitleIStatusId	= OrgTitleIL.DimOrganizationTitleIStatusId
	--join to FactOrganizationCounts by School to get the OrganizatuionTitleIStatus
	LEFT JOIN 	RDS.FactOrganizationCounts					FactSch		ON Fact.K12SchoolId						= FactSch.K12SchoolId	AND Fact.SchoolYearId = FactSch.SchoolYearId	
	LEFT JOIN	RDS.DimOrganizationTitleIStatuses			OrgTitleIS	ON FactSch.OrganizationTitleIStatusId	= OrgTitleIS.DimOrganizationTitleIStatusId

	WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 3
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2024
	AND Fact.FactTypeId = 12