IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'Staging' AND TABLE_NAME = 'ValidationErrors') BEGIN
	DROP TABLE [Staging].[ValidationErrors]
END