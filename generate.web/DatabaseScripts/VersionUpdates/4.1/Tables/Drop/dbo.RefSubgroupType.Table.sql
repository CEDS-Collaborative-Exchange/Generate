IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'RefSubgroupType') BEGIN
	DROP TABLE [dbo].[RefSubgroupType]
END