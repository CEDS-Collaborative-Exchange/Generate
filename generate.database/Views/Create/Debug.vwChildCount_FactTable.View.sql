CREATE VIEW [Debug].[vwChildCount_FactTable] 
AS
	SELECT	Fact.K12StudentId
			, Students.K12StudentStudentIdentifierState
			, Students.BirthDate
			, Students.FirstName
			, Students.LastOrSurname
			, Students.MiddleName
			, Demo.SexCode
			, LEAs.LeaIdentifierSea
			, LEAs.LeaIdentifierNces
			, LEAs.LeaOrganizationName
			, Schools.SchoolIdentifierSea
			, Schools.NameOfInstitution

			, Ages.AgeEdFactsCode
			, Races.RaceEdFactsCode
			, Grades.GradeLevelEdFactsCode

			--Primary Disability
			, IDEADisability.IdeaDisabilityTypeEdFactsCode
			--IDEA Indicator
			, IDEAStatus.IdeaIndicatorEdFactsCode
			--EducationEnvironment
			, IDEAStatus.IdeaEducationalEnvironmentForSchoolAgeEdFactsCode
			, IDEAStatus.IdeaEducationalEnvironmentForEarlyChildhoodEdFactsCode
			--English Learner
			, EL.EnglishLearnerStatusEdFactsCode

 	FROM		RDS.FactK12StudentCounts			Fact
	JOIN		RDS.DimSchoolYears					SchoolYears			ON Fact.SchoolYearId			= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes DMT					ON SchoolYears.dimschoolyearid	= DMT.dimschoolyearid		
	LEFT JOIN	RDS.DimPeople						Students			ON Fact.K12StudentId			= Students.DimPersonId			AND Students.IsActiveK12Student = 1
	LEFT JOIN	RDS.DimLeas							LEAs				ON Fact.LeaId					= LEAs.DimLeaId
	LEFT JOIN	RDS.DimK12Schools					Schools				ON Fact.K12SchoolId				= Schools.DimK12SchoolId
	LEFT JOIN	RDS.DimIdeaStatuses					IDEAStatus			ON Fact.IdeaStatusId			= IDEAStatus.DimIdeaStatusId
    LEFT JOIN   RDS.DimIdeaDisabilityTypes         	IDEADisability  	ON Fact.PrimaryDisabilityTypeId = IDEADisability.DimIdeaDisabilityTypeId
	LEFT JOIN	RDS.DimK12Demographics				Demo				ON Fact.K12DemographicId		= Demo.DimK12DemographicId
	LEFT JOIN	RDS.DimEnglishLearnerStatuses		EL					ON Fact.EnglishLearnerStatusId	= EL.DimEnglishLearnerStatusId
	LEFT JOIN	RDS.DimAges							Ages				ON Fact.AgeId					= Ages.DimAgeId      
	LEFT JOIN	RDS.DimRaces						Races				ON Fact.RaceId					= Races.DimRaceId
	LEFT JOIN	RDS.DimGradeLevels					Grades				ON Fact.GradeLevelId			= Grades.DimGradeLevelId
	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 2
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2023

	AND Fact.FactTypeId = 3
	--AND Students.StudentIdentifierState = '12345678'	
	--AND LEAs.LeaIdentifierSeaAccountability = '123'
	--AND Schools.SchoolIdentifierSea = '456'
	--AND Ages.AgeEdFactsCode = '12'
	--AND Grades.GradeLevelEdFactsCode = '07'
	--AND Races.RaceEdFactsCode = 'AM7'								--('AM7','AS7','BL7','PI7','WH7','MU7','HI7',NULL)
	--AND EL.EnglishLearnerStatusEdFactsCode = 'LEP'				--('LEP', 'NLEP', 'MISSING')
	--AND IDEAStatus.IdeaIndicatorEdFactsCode = 'IDEA'				--('IDEA', 'MISSING')
	--AND IDEAStatus.IdeaEducationalEnvironmentEdFactsCode = ''	
	--AND IDEADisability.IdeaDisabilityTypeEdFactsCode = 'EMN'		--('AUT','DB','DD','EMN','HI','ID','MD','OHI','OI','SLD','SLI','TBI','VI','MISSING')
