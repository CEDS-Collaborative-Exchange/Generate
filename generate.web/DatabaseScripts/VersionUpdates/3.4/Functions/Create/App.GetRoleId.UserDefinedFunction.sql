CREATE FUNCTION App.GetRoleId (@RoleName VARCHAR(30))
RETURNS INT
AS BEGIN
	DECLARE @RoleId INT
	
          SELECT @RoleId = RoleID
          FROM ods.[Role]
          WHERE [Name] = @RoleName
		  
	RETURN (@RoleId)
END