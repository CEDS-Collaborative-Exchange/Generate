CREATE PROCEDURE [RDS].[Migrate_DimK12StaffStatuses]
	@staffDates AS K12StaffDateTableType READONLY,
	@staffOrganizations AS K12StaffOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT = 0
AS
BEGIN
	DECLARE @k12PersonnelRoleId AS INT
	SELECT @k12PersonnelRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Personnel'

	CREATE TABLE #credentialQuery (
		  DimK12StaffId INT
		, PersonId INT
		, DimCountDateId INT
		, Credentialed BIT
		, QualificationStatusCode VARCHAR(50)
	)

	INSERT INTO #credentialQuery (
		  DimK12StaffId
		, PersonId
		, DimCountDateId
		, Credentialed
		, QualificationStatusCode		
	)
	SELECT DISTINCT 
		s.DimK12StaffId
		, s.PersonId
		, s.DimCountDateId
		, 1
		, qual.Code AS QualificationStatusCode
	FROM @staffDates s
	JOIN dbo.PersonCredential cred 
		ON s.PersonId = cred.PersonId
		AND (@dataCollectionId IS NULL OR cred.DataCollectionId = @dataCollectionId)	
	JOIN dbo.RefCredentialType credType 
		ON cred.RefCredentialTypeId = credType.RefCredentialTypeId
	LEFT JOIN dbo.StaffCredential staffCred 
		ON cred.PersonCredentialId = staffCred.PersonCredentialId
		AND (@dataCollectionId IS NULL OR staffCred.DataCollectionId = @dataCollectionId)	
		AND s.CountDate BETWEEN ISNULL(staffCred.RecordStartDateTime, s.CountDate) AND ISNULL(staffCred.RecordEndDateTime, GETDATE())
	LEFT JOIN dbo.RefParaprofessionalQualification qual 
		ON staffCred.RefParaprofessionalQualificationId = qual.RefParaprofessionalQualificationId
	WHERE (credType.Code = 'Certification' OR credType.Code = 'Licensure')
		AND cred.IssuanceDate <= s.CountDate 
		AND (cred.ExpirationDate IS NULL OR cred.ExpirationDate >= CountDate)

	CREATE TABLE #personnelStatusQuery (
		DimK12StaffId INT
		, DimK12SchoolId INT
		, DimLeaId INT
		, DimSeaId INT
		, PersonId INT
		, DimCountDateId INT
		, AgeGroupCode VARCHAR(50)
		, CertificationStatusCode VARCHAR(50)
		, PersonnelTypeCode VARCHAR(50)
		, QualificationStatusCode VARCHAR(50)
		, StaffCategoryCode VARCHAR(50)
		, PersonnelFTE DECIMAL(18,3)
		, UnexperiencedStatusCode VARCHAR(50)
		, EmergencyOrProvisionalCredentialStatusCode VARCHAR(50)
		, OutOfFieldStatusCode VARCHAR(50)
	)

	INSERT INTO #personnelStatusQuery (
		DimK12StaffId
		, DimK12SchoolId
		, DimLeaId
		, DimSeaId
		, PersonId
		, DimCountDateId
		, AgeGroupCode
		, CertificationStatusCode
		, PersonnelTypeCode
		, QualificationStatusCode
		, StaffCategoryCode
		, PersonnelFTE
		, UnexperiencedStatusCode
		, EmergencyOrProvisionalCredentialStatusCode
		, OutOfFieldStatusCode
	)
	SELECT 
		s.DimK12StaffId
		, org.DimK12SchoolId
		, org.DimLeaId
		, org.DimSeaId
		, s.PersonId
		, s.DimCountDateId
		, ISNULL(ageGroup.Code, 'MISSING') AS AgeGroupCode
		, CASE
			WHEN cred.Credentialed = 1 THEN 'FC'
			ELSE 'NFC'
		  END AS CertificationStatusCode
		, CASE
			WHEN classif.Code = 'SpecialEducationTeachers' THEN 'TEACHER'
			WHEN classif.Code = 'Paraprofessionals' THEN 'PARAPROFESSIONAL'
			WHEN NOT staffCat.Code IS NULL THEN 'STAFF'
			ELSE 'MISSING'
		  END AS PersonnelTypeCode
		, CASE
			WHEN classif.Code = 'Paraprofessionals' THEN ISNULL(cred.QualificationStatusCode, 'MISSING')
			WHEN classif.Code = 'SpecialEducationTeachers' AND staff.HighlyQualifiedTeacherIndicator = 1 THEN 'SPEDTCHFULCRT'
			WHEN classif.Code = 'SpecialEducationTeachers' AND staff.HighlyQualifiedTeacherIndicator = 0 THEN 'SPEDTCHNFULCRT'
			WHEN s.DimCountDateId < 8 AND staff.HighlyQualifiedTeacherIndicator = 1 THEN 'HQ'
			WHEN s.DimCountDateId < 8 AND staff.HighlyQualifiedTeacherIndicator = 0 THEN 'NHQ'
			WHEN staff.HighlyQualifiedTeacherIndicator = 1 THEN 'SPEDTCHFULCRT'
			WHEN staff.HighlyQualifiedTeacherIndicator = 0 THEN 'SPEDTCHNFULCRT'
			ELSE 'MISSING'
		  END AS QualificationStatusCode
		, ISNULL(staffCat.Code, 'MISSING') AS StaffCategoryCode
		, staff.FullTimeEquivalency
		, ISNULL(unexp.Code, 'MISSING') AS UnexperiencedStatusCode
		, ISNULL(emerg.Code, 'MISSING') AS EmergencyOrProvisionalCredentialStatusCode
		, ISNULL(outf.Code, 'MISSING') AS OutOfFieldStatusCode
	FROM @staffDates s
    JOIN @staffOrganizations org
        ON s.PersonId = org.PersonId
    JOIN dbo.OrganizationPersonRole r
        ON r.PersonId = s.PersonId
        AND r.OrganizationId = IIF(org.K12SchoolOrganizationId > 0, org.K12SchoolOrganizationId, org.LeaOrganizationId)
        AND r.RoleId = @k12PersonnelRoleId
        AND	(	( @loadAllForDataCollection = 1 OR @dataCollectionId IS NULL ) 
				OR
				( r.EntryDate <= s.SessionEndDate
					AND ( r.ExitDate >= s.SessionBeginDate OR r.ExitDate IS NULL )
				)
			)
	JOIN dbo.K12staffAssignment staff 
		ON r.OrganizationPersonRoleId = staff.OrganizationPersonRoleId
		AND (@dataCollectionId IS NULL OR staff.DataCollectionId = @dataCollectionId)	
		AND s.CountDate BETWEEN ISNULL(staff.RecordStartDateTime, s.CountDate) AND ISNULL(staff.RecordEndDateTime, GETDATE())
	LEFT JOIN dbo.RefSpecialEducationAgeGroupTaught ageGroup 
		ON staff.RefSpecialEducationAgeGroupTaughtId = ageGroup.RefSpecialEducationAgeGroupTaughtId
	LEFT JOIN dbo.RefSpecialEducationStaffCategory staffCat 
		ON staff.RefSpecialEducationStaffCategoryId = staffCat.RefSpecialEducationStaffCategoryId
	LEFT JOIN dbo.RefK12StaffClassification classif 
		ON staff.RefK12StaffClassificationId = classif.RefK12StaffClassificationId
	LEFT JOIN #credentialQuery cred 
		ON s.DimK12StaffId = cred.DimK12StaffId 
		AND s.DimCountDateId = cred.DimCountDateId
	LEFT JOIN dbo.RefUnexperiencedStatus unexp 
		ON unexp.RefUnexperiencedStatusId = staff.RefUnexperiencedStatusId
	LEFT JOIN dbo.RefEmergencyOrProvisionalCredentialStatus emerg 
		ON emerg.RefEmergencyOrProvisionalCredentialStatusId = staff.RefEmergencyOrProvisionalCredentialStatusId
	LEFT JOIN dbo.RefOutOfFieldStatus outf 
		ON outf.RefOutOfFieldStatusId = staff.RefOutOfFieldStatusId
	WHERE s.DimK12StaffId <> -1
		AND r.EntryDate <= s.CountDate 
		AND (r.ExitDate >= s.CountDate OR r.ExitDate IS NULL)	
	ORDER BY s.DimK12StaffId

	-- output
	SELECT
		DimK12StaffId
		, DimK12SchoolId
        , DimLeaId
        , DimSeaId
		, PersonId
		, DimCountDateId
		, ISNULL(AgeGroupCode, 'MISSING')
		, ISNULL(CertificationStatusCode, 'MISSING')
		, ISNULL(PersonnelTypeCode, 'MISSING')
		, ISNULL(QualificationStatusCode, 'MISSING')
		, ISNULL(StaffCategoryCode, 'MISSING')
		, PersonnelFTE
		, ISNULL(UnexperiencedStatusCode, 'MISSING')
		, ISNULL(EmergencyOrProvisionalCredentialStatusCode, 'MISSING')
		, ISNULL(OutOfFieldStatusCode, 'MISSING')
	FROM #personnelStatusQuery

END
