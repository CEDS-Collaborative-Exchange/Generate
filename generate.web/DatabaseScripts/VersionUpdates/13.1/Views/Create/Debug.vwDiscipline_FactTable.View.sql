CREATE VIEW [Debug].[vwDiscipline_FactTable] 
AS
	SELECT	 Fact.FactK12StudentDisciplineId
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
				
			, Ages.AgeValue
			, Races.RaceCode
			, Grades.GradeLevelEdFactsCode
			
			--English Learner Status
			, EL.EnglishLearnerStatusEdFactsCode
			-- IDEA Indicator
			, IDEAStatus.IdeaIndicatorEdFactsCode
			-- Education Env School Age
			, IDEAStatus.IdeaEducationalEnvironmentForSchoolAgeEDFactsCode
			-- Primary Disability Type
			, IDEADisability.IdeaDisabilityTypeEdFactsCode
			-- Discipline Method Of Children With Disabilities
			, Disciplines.DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode
			-- Disciplinary Action Taken Code
			, Disciplines.DisciplinaryActionTakenEdFactsCode
			-- IDEA Interim Removal
			, Disciplines.IdeaInterimRemovalEdFactsCode
			-- IDEA Interim Removal Reason
			, Disciplines.IdeaInterimRemovalReasonEdFactsCode
			-- Educational Services After Removal
			, Disciplines.EducationalServicesAfterRemovalEdFactsCode
			, Fact.DurationOfDisciplinaryAction

			, Firearms.FirearmTypeEdFactsCode
			, FirearmDiscipline.DisciplineMethodForFirearmsIncidentsEdFactsCode
			, FirearmDiscipline.IdeaDisciplineMethodForFirearmsIncidentsEdFactsCode

			, Fact.DisciplineCount
			, ActionStartDate.DateValue		AS DisciplinaryActionStartDate
			, ActionEndDate.DateValue		AS DisciplinaryActionEndDate

    FROM   		RDS.FactK12StudentDisciplines		Fact
	JOIN		RDS.DimSchoolYears					SchoolYears			ON Fact.SchoolYearId					= SchoolYears.DimSchoolYearId	
	JOIN		RDS.DimSchoolYearDataMigrationTypes DMT					ON SchoolYears.dimschoolyearid			= DMT.dimschoolyearid		
    LEFT JOIN   RDS.DimPeople		              	Students			ON Fact.K12StudentId					= Students.DimPersonId			AND Students.IsActiveK12Student = 1
	LEFT JOIN	RDS.DimSeas                        	SEA         		ON Fact.SeaId    						= SEA.DimSeaId
    LEFT JOIN   RDS.DimLeas                     	LEAs            	ON Fact.LeaId               			= LEAs.DimLeaId
    LEFT JOIN   RDS.DimK12Schools               	Schools         	ON Fact.K12SchoolId         			= Schools.DimK12SchoolId
    LEFT JOIN   RDS.DimIdeaStatuses             	IDEAStatus      	ON Fact.IdeaStatusId        			= IDEAStatus.DimIdeaStatusId
    LEFT JOIN   RDS.DimIdeaDisabilityTypes         	IDEADisability  	ON Fact.PrimaryDisabilityTypeId			= IDEADisability.DimIdeaDisabilityTypeId
    LEFT JOIN   RDS.DimK12Demographics          	Demo            	ON Fact.K12DemographicId    			= Demo.DimK12DemographicId
	LEFT JOIN	RDS.DimEnglishLearnerStatuses		EL					ON Fact.EnglishLearnerStatusId			= EL.DimEnglishLearnerStatusId
    LEFT JOIN   RDS.DimAges                     	Ages            	ON Fact.AgeId               			= Ages.DimAgeId      
    LEFT JOIN   RDS.DimRaces                    	Races           	ON Fact.RaceId              			= Races.DimRaceId
    LEFT JOIN   RDS.DimGradeLevels              	Grades          	ON Fact.GradeLevelId        			= Grades.DimGradeLevelId
    LEFT JOIN   RDS.DimDisciplineStatuses          	Disciplines     	ON Fact.DisciplineStatusId				= Disciplines.DimDisciplineStatusId
    LEFT JOIN   RDS.DimFirearmDisciplineStatuses    FirearmDiscipline	ON Fact.FirearmDisciplineStatusId		= FirearmDiscipline.DimFirearmDisciplineStatusId
    LEFT JOIN   RDS.DimFirearms			          	Firearms 	     	ON Fact.FirearmId						= Firearms.DimFirearmId
    LEFT JOIN   RDS.DimDates			          	ActionStartDate 	ON Fact.DisciplinaryActionStartDateId  	= ActionStartDate.DimDateId
    LEFT JOIN   RDS.DimDates			          	ActionEndDate 		ON Fact.DisciplinaryActionEndDateId		= ActionEndDate.DimDateId
    --uncomment/modify the where clause conditions as necessary for validation
    WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 3
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2023
	AND Fact.FactTypeId = 24

