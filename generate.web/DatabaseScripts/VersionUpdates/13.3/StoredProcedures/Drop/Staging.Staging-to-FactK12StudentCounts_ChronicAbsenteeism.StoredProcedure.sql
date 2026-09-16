IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Staging' AND ROUTINE_NAME = 'Staging-to-FactK12StudentCounts_Chronic') 
BEGIN
	DROP PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_Chronic]
END

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Staging' AND ROUTINE_NAME = 'Staging-to-FactK12StudentCounts_ChronicAbsenteeism') 
BEGIN
	DROP PROCEDURE [Staging].[Staging-to-FactK12StudentCounts_ChronicAbsenteeism]
END