	CREATE VIEW [debug].[vwMembership_StagingTables] 
	AS
		SELECT	DISTINCT 
			toggle.SchoolYear
			, toggle.MemebershipDate
			, enrollment.StudentIdentifierState
			, enrollment.LEAIdentifierSeaAccountability
			, enrollment.SchoolIdentifierSea
			, enrollment.FirstName
			, enrollment.LastOrSurname
			, enrollment.MiddleName
			, enrollment.BirthDate
			, enrollment.Sex -- For FS052
			, enrollment.GradeLevel -- For FS052
			, enrollment.EnrollmentEntryDate
			, enrollment.EnrollmentExitDate

			, ecodis.EconomicDisadvantageStatus -- For FS226
			, ecodis.EconomicDisadvantage_StatusStartDate -- For FS226 and FS033
			, ecodis.EconomicDisadvantage_StatusEndDate -- For FS226 and FS033
			, ecodis.EligibilityStatusForSchoolFoodServicePrograms -- For FS033
			, ecodis.NationalSchoolLunchProgramDirectCertificationIndicator -- For FS033

			, enrollment.HispanicLatinoEthnicity
			, race.RaceType -- For FS052
			, race.RecordStartDateTime					AS RaceStartDate
			, race.RecordEndDateTime					AS RaceEndDate

		FROM 
			(
				SELECT max(sy.Schoolyear) AS SchoolYear, CAST(CAST(max(sy.Schoolyear) - 1 AS CHAR(4)) + '-' + CAST(MONTH(tr.ResponseValue) AS VARCHAR(2)) + '-' + CAST(DAY(tr.ResponseValue) AS VARCHAR(2)) AS DATE) AS MemebershipDate
				FROM App.ToggleQuestions tq
				JOIN App.ToggleResponses tr
					ON tq.ToggleQuestionId = tr.ToggleQuestionId
				CROSS JOIN rds.DimSchoolYearDataMigrationTypes dm
				INNER JOIN rds.dimschoolyears sy
						on dm.dimschoolyearid = sy.dimschoolyearid	
				WHERE tq.EmapsQuestionAbbrv = 'MEMBERDTE'
				AND dm.IsSelected = 1
				GROUP BY tr.ResponseValue
			) toggle
		JOIN Staging.K12Enrollment								enrollment		
			on toggle.SchoolYear = enrollment.SchoolYear
			AND toggle.MemebershipDate BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())
		LEFT JOIN Staging.K12PersonRace							race
				ON		enrollment.SchoolYear											=	race.SchoolYear
				AND		enrollment.StudentIdentifierState								=	race.StudentIdentifierState
				AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')			=	ISNULL(race.LEAIdentifierSeaAccountability, '')
				AND		ISNULL(enrollment.SchoolIdentifierSea, '')						=	ISNULL(race.SchoolIdentifierSea, '')
				AND		toggle.MemebershipDate BETWEEN race.RecordStartDateTime AND ISNULL(race.RecordEndDateTime, GETDATE())

		LEFT JOIN Staging.PersonStatus							ecodis
				ON		ecodis.StudentIdentifierState								    =	enrollment.StudentIdentifierState
				AND		ISNULL(ecodis.LEAIdentifierSeaAccountability, '')			    =	ISNULL(enrollment.LEAIdentifierSeaAccountability, '')
				AND		ISNULL(ecodis.SchoolIdentifierSea, '')						    =	ISNULL(enrollment.SchoolIdentifierSea, '')
				AND		toggle.MemebershipDate BETWEEN EconomicDisadvantage_StatusStartDate AND ISNULL(ecodis.EconomicDisadvantage_StatusEndDate, GETDATE())

		--uncomment/modify the where clause conditions as necessary for validation
		WHERE 1 = 1
		--AND enrollment.StudentIdentifierState = '12345678'	
		--AND enrollment.LeaIdentifierSeaAccountability = '123'
		--AND enrollment.SchoolIdentifierSea = '456'
		--AND [RDS].[Get_Age] (enrollment.BirthDate, dates.ResponseValue) = '12'
		--AND enrollment.FirstName = ''
		--AND enrollment.LastOrSurname = ''
		--AND enrollment.BirthDate = ''
