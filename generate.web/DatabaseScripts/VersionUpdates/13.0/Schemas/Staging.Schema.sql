IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Staging')
BEGIN
	EXEC sp_executesql N'CREATE SCHEMA Staging'
END