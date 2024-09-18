CREATE VIEW [Debug].[vwK12Staff_StagingTables] AS

	SELECT		DISTINCT 
				Personnel_Identifier_State
				,LEA_Identifier_State
				,School_Identifier_State
				,FirstName
				,LastName
				,MiddleName
				,BirthDate
				,Sex
				,PositionTitle
				,FullTimeEquivalency
				,SpecialEducationStaffCategory
				,K12StaffClassification
				,TitleIProgramStaffCategory
				,CredentialType
				,CredentialIssuanceDate
				,CredentialExpirationDate
				,ParaprofessionalQualification
				,SpecialEducationAgeGroupTaught
				,HighlyQualifiedTeacherIndicator
				,AssignmentStartDate
				,AssignmentEndDate
				,InexperiencedStatus
				,EmergencyorProvisionalCredentialStatus
				,OutOfFieldStatus
				,RecordStartDateTime
				,RecordEndDateTime

	FROM Staging.K12StaffAssignment							staff		
	
	--uncomment/modify the where clause conditions as necessary for validation
	WHERE 1 = 1
	--AND Personnel_Identifier_State = ''
	--AND LEA_Identifier_State = ''
	--AND School_Identifier_State = ''
	--AND FirstName = ''
	--AND LastName = ''
	--AND MiddleName = ''
	--AND BirthDate = ''
	--AND Sex = ''
	--AND PositionTitle = ''
	--AND FullTimeEquivalency = ''
	--AND SpecialEducationStaffCategory = ''
	--AND K12StaffClassification = ''
	--AND TitleIProgramStaffCategory = ''
	--AND CredentialType = ''
	--AND CredentialIssuanceDate = ''
	--AND CredentialExpirationDate = ''
	--AND ParaprofessionalQualification = ''
	--AND SpecialEducationAgeGroupTaught = ''
	--AND HighlyQualifiedTeacherIndicator = ''
	--AND AssignmentStartDate = ''
	--AND AssignmentEndDate = ''
	--AND InexperiencedStatus = ''
	--AND EmergencyorProvisionalCredentialStatus = ''
	--AND OutOfFieldStatus = ''
	--AND RecordStartDateTime = ''
	--AND RecordEndDateTime = ''

