CREATE VIEW [debug].[vwMembership_StagingTables] 
AS
/*  This is used for both Membership and Free and Reduced Lunch */
	SELECT DISTINCT 
		enrollment.Student_Identifier_State
		,enrollment.LEA_Identifier_State
		,enrollment.School_Identifier_State
		,enrollment.FirstName
		,enrollment.LastName
		,enrollment.MiddleName
		,enrollment.Sex
		,enrollment.BirthDate
		,enrollment.EnrollmentEntryDate
		,enrollment.EnrollmentExitDate
		,race.RaceType
		,race.RecordStartDateTime
		,race.RecordEndDateTime
		,Pstatus.EligibilityStatusForSchoolFoodServicePrograms   --FRL
		,Pstatus.NationalSchoolLunchProgramDirectCertificationIndicator  --FRL
	FROM Staging.K12Enrollment									enrollment          

	LEFT JOIN Staging.K12PersonRace                              race
		ON		enrollment.SchoolYear                                               =      race.SchoolYear
		AND     enrollment.Student_Identifier_State                          =      race.Student_Identifier_State
		AND     (race.OrganizationType = 'SEA'
				OR (enrollment.LEA_Identifier_State = race.OrganizationIdentifier
						AND race.OrganizationType = 'LEA')
				OR (enrollment.School_Identifier_State = race.OrganizationIdentifier
						AND race.OrganizationType = 'K12School'))
		--   AND          race.RecordStartDateTime  BETWEEN enrollment.EnrollmentEntryDate AND ISNULL(enrollment.EnrollmentExitDate, GETDATE())
	LEFT JOIN Staging.PersonStatus                               pStatus
		ON      enrollment.Student_Identifier_State                          =      Pstatus.Student_Identifier_State
				AND isnull(enrollment.LEA_Identifier_State, '') = isnull(Pstatus.LEA_Identifier_State, '')
				AND isnull(enrollment.School_Identifier_State, '') = isnull(Pstatus.School_Identifier_State, '')
		
	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--AND enrollment.Student_Identifier_State  = '12345678'     
	--AND enrollment.LEA_Identifier_State = '073606000'
	--AND enrollment.School_Identifier_State = '073606460'
	--AND enrollment.FirstName = ''
	--AND enrollment.LastName = ''
	--AND enrollment.BirthDate = ''
	--AND race.RaceType = ''
	--AND race.RecordStartDateTime = ''
	--AND race.RecordEndDateTime = ''
	--AND Pstatus.EligibilityStatusForSchoolFoodServicePrograms = ''
	--AND Pstatus.NationalSchoolLunchProgramDirectCertificationIndicator = ''
