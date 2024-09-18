CREATE FUNCTION App.GetRefPersonIdentificationSystemId (@PersonIdentificationSystemCode VARCHAR(20), @PersonIdentifierTypeCode VARCHAR(6))
RETURNS INT
AS BEGIN
	DECLARE @PersonIdentificationSystemId INT
	
	SELECT @PersonIdentificationSystemId = r.RefPersonIdentificationSystemId 
	FROM ODS.RefPersonIdentificationSystem r 
	JOIN ODS.RefPersonIdentifierType rpt 
		ON r.RefPersonIdentifierTypeId = rpt.RefPersonIdentifierTypeId 
	WHERE r.Code = @PersonIdentificationSystemCode 
		AND rpt.Code = @PersonIdentifierTypeCode

	RETURN (@PersonIdentificationSystemId)
END