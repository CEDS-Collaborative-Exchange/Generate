CREATE FUNCTION App.GetRefStateAnsiCode (@StateName VARCHAR(30))
RETURNS CHAR(2)
AS BEGIN
	DECLARE @RefStateAnsiCode CHAR(2)
	
	SELECT @RefStateAnsiCode = Code FROM ODS.RefStateAnsiCode WHERE StateName = @StateName

	RETURN @RefStateAnsiCode 
END