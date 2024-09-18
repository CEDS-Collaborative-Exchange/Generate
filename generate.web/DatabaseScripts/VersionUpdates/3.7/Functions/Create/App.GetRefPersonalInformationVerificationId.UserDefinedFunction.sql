CREATE FUNCTION App.GetRefPersonalInformationVerificationId (@PersonalInformationVerificationCode VARCHAR(20))
RETURNS INT
AS BEGIN
	DECLARE @PersonalInformationVerificationId INT
	
	SELECT @PersonalInformationVerificationId = r.RefPersonalInformationVerificationId 
	FROM ODS.RefPersonalInformationVerification r 
	WHERE Code = @PersonalInformationVerificationCode

	RETURN (@PersonalInformationVerificationId)
END