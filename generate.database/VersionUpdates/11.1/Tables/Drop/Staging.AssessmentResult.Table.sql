IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'Staging' AND TABLE_NAME = 'AssessmentResult') BEGIN
	DROP TABLE [Staging].[AssessmentResult]
END