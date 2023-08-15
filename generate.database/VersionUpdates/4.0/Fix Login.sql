IF EXISTS (SELECT 1 FROM master.dbo.sysdatabases WHERE Name = 'generate-test') BEGIN
	ALTER DATABASE [generate-test] SET RECOVERY SIMPLE ;  
END ELSE BEGIN
	ALTER DATABASE [generate] SET RECOVERY SIMPLE ;  
END

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Generate') AND EXISTS (SELECT * FROM sys.server_principals WHERE name = 'Generate') BEGIN
	ALTER USER Generate  WITH LOGIN  = Generate
END ELSE IF EXISTS (SELECT * FROM sys.server_principals WHERE name = 'Generate') BEGIN
	CREATE USER Generate FOR LOGIN Generate WITH DEFAULT_SCHEMA=[dbo]
END 
