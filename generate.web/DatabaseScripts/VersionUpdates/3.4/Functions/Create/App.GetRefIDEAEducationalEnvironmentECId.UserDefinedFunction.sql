CREATE FUNCTION App.GetRefIDEAEducationalEnvironmentECId (@EducationalEnvironmentCode VARCHAR(50))
RETURNS INT
AS BEGIN
	DECLARE @EducationalEnvironmentId INT

	SELECT @EducationalEnvironmentId = RefIDEAEducationalEnvironmentECId
    FROM [ODS].[RefIDEAEducationalEnvironmentEC]
	WHERE Code = @EducationalEnvironmentCode

	RETURN (@EducationalEnvironmentId)
END