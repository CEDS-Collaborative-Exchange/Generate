CREATE VIEW [Debug].[vwAssessment_FactTable] 
AS
	SELECT	Fact.FactK12StudentAssessmentId
			, SchoolYears.SchoolYear
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
			, LEAs.DimLeaId	
			, Schools.SchoolIdentifierSea
			, Schools.DimK12SchoolId
			, Schools.NameOfInstitution
			, Schools.SchoolOperationalStatus
			, Schools.SchoolTypeCode

			, Assess.AssessmentTitle
			, Assess.AssessmentIdentifierState
			, Assess.AssessmentAcademicSubjectCode
			, Assess.AssessmentAcademicSubjectDescription
			, Assess.AssessmentAcademicSubjectEdFactsCode
			, Assess.AssessmentTypeAdministeredCode
			, Assess.AssessmentTypeAdministeredToEnglishLearnersCode
			
			, AssessPerf.AssessmentPerformanceLevelLabel

			, AssessReg.AssessmentRegistrationParticipationIndicatorCode
			, AssessReg.AssessmentRegistrationReasonNotCompletingCode
			, AssessReg.ReasonNotTestedCode

			, Races.RaceEdFactsCode
			, Grades.GradeLevelEdFactsCode

			--IDEA Indicator
			, IDEAStatus.IdeaIndicatorEdFactsCode
			--English Learner
			, EL.EnglishLearnerStatusEdFactsCode
			--Economically Disadvantaged
			, Econ.EconomicDisadvantageStatusCode
			--Migratory
			, Migr.MigrantStatusCode
			--Homelessness
			, Hmls.HomelessnessStatusCode
			--Foster Care
			, Fstr.ProgramParticipationFosterCareCode
			--Military Connected
			, Mil.MilitaryConnectedStudentIndicatorCode
			--N or D
			, NorD.NeglectedOrDelinquentStatusCode
			, NorD.NeglectedOrDelinquentProgramEnrollmentSubpartCode
			--Title III
			, TitleIII.TitleIIILanguageInstructionProgramTypeCode

 	FROM		RDS.FactK12StudentAssessments				Fact
	JOIN		RDS.DimSchoolYears							SchoolYears	ON Fact.SchoolYearId						= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes			DMT			ON SchoolYears.dimschoolyearid				= DMT.dimschoolyearid		
	LEFT JOIN	RDS.DimPeople								Students	ON Fact.K12StudentId						= Students.DimPersonId			AND Students.IsActiveK12Student = 1
	LEFT JOIN	RDS.DimSeas									SEA			ON Fact.SeaId								= SEA.DimSeaId
	LEFT JOIN	RDS.DimLeas									LEAs		ON Fact.LeaId								= LEAs.DimLeaId
	LEFT JOIN	RDS.DimK12Schools							Schools		ON Fact.K12SchoolId							= Schools.DimK12SchoolId
	LEFT JOIN	RDS.DimAssessments							Assess		ON Fact.AssessmentId						= Assess.DimAssessmentId	
	LEFT JOIN	RDS.DimAssessmentRegistrations				AssessReg	ON Fact.AssessmentRegistrationId			= AssessReg.DimAssessmentRegistrationId	
	LEFT JOIN	RDS.DimAssessmentPerformanceLevels			AssessPerf	ON Fact.AssessmentPerformanceLevelId		= AssessPerf.DimAssessmentPerformanceLevelId
	LEFT JOIN	RDS.BridgeK12StudentAssessmentRaces			BrRace		ON Fact.FactK12StudentAssessmentId			= BrRace.FactK12StudentAssessmentId
	LEFT JOIN	RDS.DimRaces								Races		ON BrRace.RaceId							= Races.DimRaceId
	LEFT JOIN	RDS.DimGradeLevels							Grades		ON Fact.GradeLevelWhenAssessedId			= Grades.DimGradeLevelId
	LEFT JOIN	RDS.DimIdeaStatuses							IDEAStatus	ON Fact.IdeaStatusId						= IDEAStatus.DimIdeaStatusId
	LEFT JOIN	RDS.DimEnglishLearnerStatuses				EL			ON Fact.EnglishLearnerStatusId				= EL.DimEnglishLearnerStatusId
	LEFT JOIN	RDS.DimEconomicallyDisadvantagedStatuses	Econ		ON Fact.EconomicallyDisadvantagedStatusId	= Econ.DimEconomicallyDisadvantagedStatusId
	LEFT JOIN	RDS.DimMigrantStatuses						Migr		ON Fact.MigrantStatusId						= Migr.DimMigrantStatusId
	LEFT JOIN	RDS.DimHomelessnessStatuses					Hmls		ON Fact.HomelessnessStatusId				= Hmls.DimHomelessnessStatusId
	LEFT JOIN	RDS.DimFosterCareStatuses					Fstr		ON Fact.FosterCareStatusId					= Fstr.DimFosterCareStatusId
	LEFT JOIN	RDS.DimMilitaryStatuses						Mil			ON Fact.MilitaryStatusId					= Mil.DimMilitaryStatusId
	LEFT JOIN	RDS.DimNorDStatuses						    NorD		ON Fact.NorDStatusId						= NorD.DimNorDStatusId
	LEFT JOIN   RDS.DimTitleIIIStatuses                     TitleIII	ON Fact.TitleIIIStatusId					= TitleIII.DimTitleIIIStatusId
	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 3
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2023
		
	AND Fact.FactTypeId = 25
