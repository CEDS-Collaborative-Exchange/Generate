
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Utilities' AND ROUTINE_NAME = 'Check_SourceSystemReferenceData_Mapping') 
BEGIN
	DROP PROCEDURE [Utilities].[Check_SourceSystemReferenceData_Mapping]
END








