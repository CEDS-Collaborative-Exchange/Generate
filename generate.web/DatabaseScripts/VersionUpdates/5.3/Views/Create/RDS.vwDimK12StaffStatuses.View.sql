create VIEW RDS.vwDimK12StaffStatuses AS
	SELECT
		  DimK12StaffStatusId
		, rsy.SchoolYear
		, SpecialEducationAgeGroupTaughtCode 
		, sssrd1.InputCode AS SpecialEducationAgeGroupTaughtMap
		, QualificationStatusCode 
		, CASE  
			WHEN QualificationStatusCode = 'SPEDTCHFULCRT' THEN 'SPEDTCHFULCRT'
			WHEN QualificationStatusCode = 'SPEDTCHNFULCRT' THEN 'SPEDTCHNFULCRT'
			ELSE sssrd6.InputCode
		  END AS QualificationStatusMap
		, UnexperiencedStatusCode 
		, sssrd3.InputCode AS UnexperiencedStatusMap
		, EmergencyOrProvisionalCredentialStatusCode 
		, sssrd4.InputCode AS EmergencyOrProvisionalCredentialStatusMap
		, OutOfFieldStatusCode 
		, sssrd5.InputCode AS OutOfFieldStatusMap
		, rdkss.CertificationStatusEdFactsCode
	FROM rds.DimK12StaffStatuses rdkss
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdkss.SpecialEducationAgeGroupTaughtCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefSpecialEducationAgeGroupTaught'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdkss.UnexperiencedStatusCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefUnexperiencedStatus'
		AND rsy.SchoolYear = sssrd3.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd4
		ON rdkss.EmergencyOrProvisionalCredentialStatusCode = sssrd4.OutputCode
		AND sssrd4.TableName = 'RefEmergencyOrProvisionalCredentialStatus'
		AND rsy.SchoolYear = sssrd4.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd5
		ON rdkss.OutOfFieldStatusCode = sssrd5.OutputCode
		AND sssrd5.TableName = 'RefOutOfFieldStatus'
		AND rsy.SchoolYear = sssrd5.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd6
		ON rdkss.QualificationStatusCode = sssrd6.OutputCode
		AND sssrd6.TableName = 'RefParaprofessionalQualification'
		AND rsy.SchoolYear = sssrd6.SchoolYear
	WHERE rdkss.K12StaffClassificationCode = 'MISSING'