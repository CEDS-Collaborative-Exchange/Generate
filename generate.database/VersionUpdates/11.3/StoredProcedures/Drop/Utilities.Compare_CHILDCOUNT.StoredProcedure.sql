﻿
IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Utilities' AND ROUTINE_NAME = 'Compare_CHILDCOUNT') 
BEGIN
	DROP PROCEDURE [Utilities].[Compare_CHILDCOUNT]
END







