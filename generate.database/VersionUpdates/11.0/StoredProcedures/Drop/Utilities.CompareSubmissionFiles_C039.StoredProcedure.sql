﻿
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Utilities' AND ROUTINE_NAME = 'CompareSubmissionFiles_C039') 
BEGIN
	DROP PROCEDURE [Utilities].[CompareSubmissionFiles_C039]
END








