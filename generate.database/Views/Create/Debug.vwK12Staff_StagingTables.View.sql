CREATE VIEW [Debug].[vwK12Staff_StagingTables] AS

	SELECT		DISTINCT 
				StaffMemberIdentifierState
				, LeaIdentifierSea
				, SchoolIdentifierSea
				, FirstName
				, LastOrSurname
				, MiddleName
				, BirthDate
				, Sex
				, PositionTitle
				, FullTimeEquivalency
				, SpecialEducationStaffCategory
				, K12StaffClassification
				, TitleIProgramStaffCategory
				, TeachingCredentialType
				, CredentialIssuanceDate
				, CredentialExpirationDate
				, ParaprofessionalQualification
				, SpecialEducationAgeGroupTaught
				, HighlyQualifiedTeacherIndicator
				, AssignmentStartDate
				, AssignmentEndDate
				, EdFactsTeacherInexperiencedStatus
				, EmergencyorProvisionalCredentialStatus
				, EDFactsTeacherOutOfFieldStatus
				, RecordStartDateTime
				, RecordEndDateTime

	FROM Staging.StaffAssignment							staff		
	
	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--AND StaffMemberIdentifierState = ''
	--AND LeaIdentifierSea = ''
	--AND SchoolIdentifierSea = ''
	--AND FirstName = ''
	--AND LastOrSurname = ''
	--AND MiddleName = ''
	--AND BirthDate = ''
	--AND Sex = ''
	--AND PositionTitle = ''
	--AND FullTimeEquivalency = ''
	--AND SpecialEducationStaffCategory = ''
	--AND K12StaffClassification = ''
	--AND TitleIProgramStaffCategory = ''
	--AND TeachingCredentialType = ''
	--AND CredentialIssuanceDate = ''
	--AND CredentialExpirationDate = ''
	--AND ParaprofessionalQualification = ''
	--AND SpecialEducationAgeGroupTaught = ''
	--AND HighlyQualifiedTeacherIndicator = ''
	--AND AssignmentStartDate = ''
	--AND AssignmentEndDate = ''
	--AND EdFactsTeacherInexperiencedStatus = ''
	--AND EmergencyorProvisionalCredentialStatus = ''
	--AND EDFactsTeacherOutOfFieldStatus = ''
	--AND RecordStartDateTime = ''
	--AND RecordEndDateTime = ''

