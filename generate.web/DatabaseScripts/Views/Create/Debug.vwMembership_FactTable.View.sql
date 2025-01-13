CREATE VIEW [debug].[vwMembership_FactTable] 
AS
	SELECT	 Fact.FactK12StudentCountId
			, SchoolYear
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
			, Schools.SchoolIdentifierSea
			, Schools.DimK12SchoolId
			, Schools.NameOfInstitution
			, Schools.SchoolOperationalStatus
			, Schools.SchoolTypeCode

			, EconDis.NationalSchoolLunchProgramDirectCertificationIndicatorCode  --FRL
			, EconDis.EligibilityStatusForSchoolFoodServiceProgramsEdFactsCode  --FRL
			, EconDis.EconomicDisadvantageStatusCode

			, Races.RaceEdFactsCode
			, Grades.GradeLevelEdFactsCode
			, approvedGradeLevels.Grade

			, TitleI.TitleIProgramTypeEdFactsCode

	FROM   		RDS.FactK12StudentCounts					Fact
	JOIN        RDS.DimSchoolYears                      	SchoolYears		ON Fact.SchoolYearId            = SchoolYears.DimSchoolYearId 
	JOIN		RDS.DimPeople								Students		ON Fact.K12StudentId			= Students.DimPersonId			AND Students.IsActiveK12Student = 1
	JOIN		RDS.DimSeas                             	SEA             ON Fact.SeaId    				= SEA.DimSeaId
	JOIN		RDS.DimLeas                             	LEAs            ON Fact.LeaId    				= LEAs.DimLeaId
	JOIN		RDS.DimK12Schools                       	Schools         ON Fact.K12SchoolId             = Schools.DimK12SchoolId

	JOIN		RDS.DimK12Demographics                  	Demo            ON Fact.K12DemographicId        = Demo.DimK12DemographicId
	JOIN		RDS.DimRaces                            	Races           ON Fact.RaceId                  = Races.DimRaceId
	JOIN		RDS.DimGradeLevels                      	Grades          ON Fact.GradeLevelId            = Grades.DimGradeLevelId
	JOIN		RDS.DimEconomicallyDisadvantagedStatuses    EconDis         ON Fact.EconomicallyDisadvantagedStatusId = EconDis.DimEconomicallyDisadvantagedStatusId
	JOIN		RDS.DimTitleIStatuses						TitleI			ON Fact.TitleIStatusId			= TitleI.DimTitleIStatusId
	LEFT JOIN (

		SELECT *  from (VALUES ('PK'),('KG'),('01'),('02'),('03'),('04'),('05'),('06'),('07'),('08'),('09'),('10'),('11'),('12')) AS Grades(Grade)

		UNION

		SELECT CASE WHEN r.ResponseValue = 'true' THEN '13' ELSE NULL END
		FROM app.ToggleQuestions q 
		LEFT OUTER JOIN app.ToggleResponses r 
			ON r.ToggleQuestionId = q.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'CCDGRADE13'

		UNION

		SELECT CASE WHEN r.ResponseValue = 'true' THEN 'UG' ELSE NULL END
		FROM app.ToggleQuestions q 
		LEFT OUTER JOIN app.ToggleResponses r 
			ON r.ToggleQuestionId = q.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'CCDUNGRADED'

		UNION

		SELECT CASE WHEN r.ResponseValue = 'true' THEN 'ABE' ELSE NULL END
		FROM app.ToggleQuestions q 
		LEFT OUTER JOIN app.ToggleResponses r 
			ON r.ToggleQuestionId = q.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ADULTEDU'

	) approvedGradeLevels ON Grades.GradeLevelEdFactsCode = approvedGradeLevels.Grade
	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
	--AND DMT.IsSelected = 1
	--AND DMT.DataMigrationTypeId = 2
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2024

	AND Fact.FactTypeId = 6
