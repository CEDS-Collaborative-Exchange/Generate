
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Utilities' AND ROUTINE_NAME = 'Student_StagingToFactDifference') 
BEGIN
	DROP PROCEDURE [Utilities].[Student_StagingToFactDifference]
END








