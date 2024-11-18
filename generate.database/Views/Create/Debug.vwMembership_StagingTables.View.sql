USE [generate]
GO

/****** Object:  View [debug].[vwMembership_StagingTables]    Script Date: 11/18/2024 11:54:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


CREATE VIEW [debug].[vwMembership_StagingTables] 
	AS
		SELECT	DISTINCT 
			toggle.SchoolYear
			, toggle.MembershipDate
			, enrollment.StudentIdentifierState
			, enrollment.LEAIdentifierSeaAccountability
			, enrollment.SchoolIdentifierSea
			, enrollment.FirstName
			, enrollment.LastOrSurname
			, enrollment.MiddleName
			, enrollment.BirthDate
			, enrollment.Sex 													-- For FS052
			, enrollment.GradeLevel 											-- For FS052
			, enrollment.EnrollmentEntryDate
			, enrollment.EnrollmentExitDate

			, ecodis.EconomicDisadvantageStatus 								-- For FS226
			, ecodis.EconomicDisadvantage_StatusStartDate 						-- For FS226 and FS033
			, ecodis.EconomicDisadvantage_StatusEndDate 						-- For FS226 and FS033
			, ecodis.EligibilityStatusForSchoolFoodServicePrograms 				-- For FS033
			, ecodis.NationalSchoolLunchProgramDirectCertificationIndicator 	-- For FS033

			, enrollment.HispanicLatinoEthnicity
			, race.RaceType 													-- For FS052
			, race.RecordStartDateTime					AS RaceStartDate
			, race.RecordEndDateTime					AS RaceEndDate

			, org.LEA_TitleIProgramType									
			, org.School_OperationalStatus
			, org.School_Type

		FROM 
			(
				SELECT max(sy.Schoolyear) AS SchoolYear, CAST(CAST(max(sy.Schoolyear) - 1 AS CHAR(4)) + '-' + CAST(MONTH(tr.ResponseValue) AS VARCHAR(2)) + '-' + CAST(DAY(tr.ResponseValue) AS VARCHAR(2)) AS DATE) AS MembershipDate
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
			AND toggle.MembershipDate BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, '1/1/9999')
		LEFT JOIN Staging.K12Organization						org
				ON 		enrollment.SchoolYear 											=	org.Schoolyear
				AND		ISNULL(enrollment.SchoolIdentifierSea, '')						= 	ISNULL(org.SchoolIdentifierSea, '')
				AND 	toggle.MembershipDate BETWEEN org.School_RecordStartDateTime AND ISNULL(org.School_RecordEndDateTime, '1/1/9999')

		LEFT JOIN Staging.K12PersonRace							race
				ON		enrollment.SchoolYear											=	race.SchoolYear
				AND		enrollment.StudentIdentifierState								=	race.StudentIdentifierState
				AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')			=	ISNULL(race.LEAIdentifierSeaAccountability, '')
				AND		ISNULL(enrollment.SchoolIdentifierSea, '')						=	ISNULL(race.SchoolIdentifierSea, '')
				AND		toggle.MembershipDate BETWEEN race.RecordStartDateTime AND ISNULL(race.RecordEndDateTime, '1/1/9999')

		LEFT JOIN Staging.PersonStatus							ecodis
				ON		ecodis.StudentIdentifierState								    =	enrollment.StudentIdentifierState
				AND		ISNULL(ecodis.LEAIdentifierSeaAccountability, '')			    =	ISNULL(enrollment.LEAIdentifierSeaAccountability, '')
				AND		ISNULL(ecodis.SchoolIdentifierSea, '')						    =	ISNULL(enrollment.SchoolIdentifierSea, '')
				

		WHERE 1 = 1
GO


