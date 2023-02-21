IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Generate') AND EXISTS (SELECT * FROM sys.server_principals WHERE name = 'Generate') BEGIN
	ALTER USER Generate  WITH LOGIN  = Generate
END ELSE IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'Generate') BEGIN
	CREATE USER Generate FOR LOGIN Generate WITH DEFAULT_SCHEMA=[dbo]
END 
