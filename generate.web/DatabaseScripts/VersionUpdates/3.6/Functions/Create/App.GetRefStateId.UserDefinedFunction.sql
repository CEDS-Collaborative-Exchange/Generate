CREATE FUNCTION App.GetRefStateId (@StateAbbreviation CHAR(2))
RETURNS INT
AS BEGIN
	DECLARE @RefStateId INT
	
	SELECT @RefStateId = RefStateId FROM ODS.RefState WHERE Code = @StateAbbreviation

	RETURN @RefStateId
END