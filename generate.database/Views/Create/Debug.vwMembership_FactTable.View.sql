CREATE VIEW [debug].[vwMembership_FactTable] 
AS
	SELECT Fact.K12StudentId
		,Students.StateStudentIdentifier
		,Students.BirthDate
		,Students.FirstName
		,Students.LastName
		,Students.MiddleName
		,Students.SexCode
		,LEAs.LeaIdentifierState
		,LEAs.LeaIdentifierNces
		,LEAs.LeaName
		,Schools.SchoolIdentifierState
		,Schools.NameOfInstitution
		,StudentStatuses.NSLPDirectCertificationIndicatorCode  --FRL
		,ProgramStatuses.EligibilityStatusForSchoolFoodServiceProgramCode  --FRL

		,Races.RaceEdFactsCode
		,Grades.GradeLevelEdFactsCode

	FROM   		RDS.FactK12StudentCounts				Fact
	JOIN        RDS.DimSchoolYears                      SchoolYears 		ON Fact.SchoolYearId            = SchoolYears.DimSchoolYearId 
	JOIN        RDS.DimSchoolYearDataMigrationTypes 	DMT                 ON SchoolYears.dimschoolyearid  = DMT.dimschoolyearid             
	LEFT JOIN   RDS.DimK12Students                      Students            ON Fact.K12StudentId            = Students.DimK12StudentId
	LEFT JOIN   RDS.DimLeas                             LEAs                ON Fact.LeaId    				= LEAs.DimLeaId
	LEFT JOIN   RDS.DimK12Schools                       Schools             ON Fact.K12SchoolId             = Schools.DimK12SchoolId

	LEFT JOIN   RDS.DimK12Demographics                  Demo                ON Fact.K12DemographicId        = Demo.DimK12DemographicId
	LEFT JOIN   RDS.DimRaces                            Races               ON Fact.RaceId                  = Races.DimRaceId
	LEFT JOIN   RDS.DimGradeLevels                      Grades              ON Fact.GradeLevelId            = Grades.DimGradeLevelId
	LEFT JOIN   RDS.DimK12StudentStatuses               StudentStatuses     ON Fact.K12StudentStatusId      = StudentStatuses.DimK12StudentStatusId
	LEFT JOIN   RDS.DimProgramStatuses                  ProgramStatuses     ON Fact.ProgramStatusId         = ProgramStatuses.DimProgramStatusId
	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--2 ways to select by SchoolYear, use 1 or the other, not both
	--the next 2 conditions set the SchoolYear selected to the one from the most recent RDS migration
		AND DMT.IsSelected = 1
		AND DMT.DataMigrationTypeId = 2
	--or comment out the lines above and just set the SchoolYear
		--AND SchoolYears.SchoolYear = 2023

	AND Fact.FactTypeId = 6
	--AND Students.StateStudentIdentifier = '12345678'    
	--AND Students.SexCode = 'M'
	--AND LEAs.LeaIdentifierState = '123'
	--AND LEAs.LeaName = 'Casey County'
	--AND Schools.SchoolIdentifierState = '456'
	--AND Schools.NameOfInstitution = 'Casey County High School'
	--AND Ages.AgeEdFactsCode = '12'
	--AND Grades.GradeLevelEdFactsCode = '07'
	--AND Races.RaceEdFactsCode = 'AM7'                                    		--('AM7','AS7','BL7','PI7','WH7','MU7','HI7',NULL)
	--AND Demo.EnglishLearnerStatusEdFactsCode = 'LEP'                         	--('LEP', 'NLEP', 'MISSING')
	--AND IDEAStatus.IdeaIndicatorEdFactsCode = 'IDEA'                         	--('IDEA', 'MISSING')
	--AND IDEAStatus.PrimaryDisabilityTypeEdFactsCode = 'EMN'           		--('AUT','DB','DD','EMN','HI','ID','MD','OHI','OI','SLD','SLI','TBI','VI','MISSING')
	--AND IDEAStatus.SpecialEducationExitReasonEdFactsCode = 'MKN'  			--('GHS','GRADALTDPL','RC','RMA','MKC','TRAN','DROPOUT','D','MISSING')
	--AND StudentStatuses.NSLPDirectCertificationIndicatorCode  = ''  			-- ('YES', 'NO', 'MISSING')
	--AND ProgramStatuses.EligibilityStatusForSchoolFoodServiceProgramCode = '' --('FREE', 'FULLPRICE', 'MISSING', 'OTHER', 'REDUCEDPRICE') 