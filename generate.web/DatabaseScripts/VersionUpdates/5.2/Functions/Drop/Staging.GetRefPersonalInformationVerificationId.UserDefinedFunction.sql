IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'APP' AND ROUTINE_NAME = 'GetRefPersonalInformationVerificationId') BEGIN
	DROP FUNCTION [App].[GetRefPersonalInformationVerificationId]
END

IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'Staging' AND ROUTINE_NAME = 'GetRefPersonalInformationVerificationId') BEGIN
	DROP FUNCTION [Staging].[GetRefPersonalInformationVerificationId]
END