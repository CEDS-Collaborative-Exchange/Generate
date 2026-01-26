CREATE VIEW [Debug].[vwStaff_StagingTables] AS

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
				, ParaprofessionalQualificationStatus
				, SpecialEducationAgeGroupTaught
				, HighlyQualifiedTeacherIndicator
				, AssignmentStartDate
				, AssignmentEndDate
				, EdFactsTeacherInexperiencedStatus
				, EDFactsTeacherOutOfFieldStatus
				, TitleIIILanguageInstructionIndicator
				, RecordStartDateTime
				, RecordEndDateTime

	FROM Staging.K12StaffAssignment							staff		
	
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
	--AND ParaprofessionalQualificationStatus = ''
	--AND SpecialEducationAgeGroupTaught = ''
	--AND HighlyQualifiedTeacherIndicator = ''
	--AND AssignmentStartDate = ''
	--AND AssignmentEndDate = ''
	--AND EdFactsTeacherInexperiencedStatus = ''
	--AND EDFactsTeacherOutOfFieldStatus = ''
	--AND RecordStartDateTime = ''
	--AND RecordEndDateTime = ''

