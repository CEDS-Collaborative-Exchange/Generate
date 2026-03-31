CREATE VIEW [RDS].[vwAssessmentAccommodations] 
AS
	SELECT
		DimAssessmentAccommodationId
		, rsy.SchoolYear
   		, AssessmentAccommodationCategoryCode
		, sssrd1.InputCode AS AssessmentAccommodationCategoryMap
      	, AccommodationTypeCode
		, sssrd2.InputCode AS AccommodationTypeMap
	FROM rds.DimAssessmentAccommodations rdaa
	CROSS JOIN (SELECT DISTINCT SchoolYear FROM staging.SourceSystemReferenceData) rsy
	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		ON rdaa.AssessmentAccommodationCategoryCode = sssrd1.OutputCode
		AND sssrd1.TableName = 'RefAssessmentAccommodationCategory'
		AND rsy.SchoolYear = sssrd1.SchoolYear
	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		ON rdaa.AccommodationTypeCode = sssrd2.OutputCode
		AND sssrd2.TableName = 'RefAccommodationType'
		AND rsy.SchoolYear = sssrd2.SchoolYear
