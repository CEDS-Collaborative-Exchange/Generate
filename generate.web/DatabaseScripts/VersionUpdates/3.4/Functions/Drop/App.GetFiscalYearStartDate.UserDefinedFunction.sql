IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'APP' AND ROUTINE_NAME = 'GetFiscalYearStartDate') BEGIN
	DROP FUNCTION [App].[GetFiscalYearStartDate]
END