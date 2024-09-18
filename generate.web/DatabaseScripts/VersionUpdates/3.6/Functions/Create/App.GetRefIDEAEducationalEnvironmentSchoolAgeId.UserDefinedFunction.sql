CREATE FUNCTION App.GetRefIDEAEducationalEnvironmentSchoolAgeId (@EducationalEnvironmentCode VARCHAR(50))
RETURNS INT
AS BEGIN
	DECLARE @EducationalEnvironmentId INT

	SELECT @EducationalEnvironmentId = RefIDESEducationalEnvironmentSchoolAge
    FROM [ODS].[RefIDEAEducationalEnvironmentSchoolAge]
	WHERE Code = @EducationalEnvironmentCode

	RETURN (@EducationalEnvironmentId)
END