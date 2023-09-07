CREATE VIEW [RDS].[vwDimAssessmentRegistrations] 
AS
	SELECT
		DimAssessmentRegistrationId
		, rsy.SchoolYear
		, StateFullAcademicYearCode
		, CASE StateFullAcademicYearCode
			WHEN 'Yes' THEN 1
			WHEN 'No' THEN 0
			ELSE NULL
		  END AS StateFullAcademicYearMap
		, LeaFullAcademicYearCode
		, CASE LeaFullAcademicYearCode
			WHEN 'Yes' THEN 1
			WHEN 'No' THEN 0
			ELSE NULL
		  END AS LeaFullAcademicYearMap
		, SchoolFullAcademicYearCode
		, CASE SchoolFullAcademicYearCode
			WHEN 'Yes' THEN 1
			WHEN 'No' THEN 0
			ELSE NULL
		  END AS SchoolFullAcademicYearMap
		, AssessmentRegistrationCompletionStatusCode
		, sssrd1.OutputCode AS AssessmentRegistrationCompletionStatusMap
		, AssessmentRegistrationParticipationIndicatorCode
		, sssrd2.OutputCode AS AssessmentRegistrationParticipationIndicatorMap
		, AssessmentRegistrationReasonNotCompletingCode
		, sssrd3.OutputCode AS AssessmentRegistrationReasonNotCompletingMap
		, ReasonNotTestedCode
		, sssrd4.OutputCode AS ReasonNotTestedMap
	FROM rds.DimAssessmentRegistrations rdar
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdar.AssessmentRegistrationCompletionStatusCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefAssessmentRegistrationCompletionStatus'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdar.AssessmentRegistrationParticipationIndicatorCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefAssessmentParticipationIndicator'
		AND rsy.SchoolYear = sssrd2.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		ON rdar.AssessmentRegistrationReasonNotCompletingCode = sssrd3.OutputCode
		AND sssrd3.TableName = 'RefAssessmentReasonNotCompleting'
		AND rsy.SchoolYear = sssrd3.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd4
		ON rdar.ReasonNotTestedCode = sssrd4.OutputCode
		AND sssrd4.TableName = 'RefAssessmentReasonNotTested'
		AND rsy.SchoolYear = sssrd4.SchoolYear
