﻿
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'App' AND ROUTINE_NAME = 'Cleanup_Grades_Offered') 
BEGIN
	DROP PROCEDURE [App].[Cleanup_Grades_Offered]
END








