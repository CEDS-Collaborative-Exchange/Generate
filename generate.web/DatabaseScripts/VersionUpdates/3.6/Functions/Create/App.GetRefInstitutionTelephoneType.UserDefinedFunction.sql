CREATE FUNCTION App.GetRefInstitutionTelephoneType (@TelephoneTypeCode CHAR(2))
RETURNS INT
AS BEGIN
	DECLARE @RefInstitutionTelephoneTypeId INT
	
	SELECT @RefInstitutionTelephoneTypeId = RefInstitutionTelephoneTypeId FROM ODS.RefInstitutionTelephoneType WHERE Code = @TelephoneTypeCode

	RETURN @RefInstitutionTelephoneTypeId
END