IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Upgrade')
BEGIN
	EXEC sp_executesql N'CREATE SCHEMA Upgrade'
END