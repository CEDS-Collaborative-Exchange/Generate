IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Staging' AND ROUTINE_NAME = 'Staging-to-DimAccessibleEducationMaterialProviders') BEGIN
	DROP PROCEDURE [Staging].[Staging-to-DimAccessibleEducationMaterialProviders]
END