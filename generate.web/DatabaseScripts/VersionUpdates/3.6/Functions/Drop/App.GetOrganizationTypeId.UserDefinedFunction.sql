IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'APP' AND ROUTINE_NAME = 'GetOrganizationTypeId') BEGIN
	DROP FUNCTION [App].[GetOrganizationTypeId]
END