IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'APP' AND ROUTINE_NAME = 'GetOrganizationIdentifierSystemId') BEGIN
	DROP FUNCTION [App].[GetOrganizationIdentifierSystemId]
END

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Staging' AND ROUTINE_NAME = 'GetOrganizationIdentifierSystemId') BEGIN
	DROP FUNCTION [Staging].[GetOrganizationIdentifierSystemId]
END