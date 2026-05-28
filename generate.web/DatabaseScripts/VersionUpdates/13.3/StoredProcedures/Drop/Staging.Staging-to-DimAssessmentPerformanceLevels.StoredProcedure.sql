IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Staging' AND ROUTINE_NAME = 'Staging-to-DimAssessmentPerformanceLevels') BEGIN
	DROP PROCEDURE [Staging].[Staging-to-DimAssessmentPerformanceLevels]
END