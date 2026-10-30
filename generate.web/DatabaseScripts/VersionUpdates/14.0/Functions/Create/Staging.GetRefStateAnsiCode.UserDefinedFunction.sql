CREATE FUNCTION Staging.GetRefStateAnsiCode (@StateName VARCHAR(30))
RETURNS CHAR(2)
AS BEGIN
	DECLARE @RefStateAnsiCode CHAR(2)
	
	SELECT @RefStateAnsiCode = CedsOptionSetCode FROM ceds.CedsOptionSetMapping WHERE CedsOptionSetDescription = @StateName

	RETURN @RefStateAnsiCode 
END