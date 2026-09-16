IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'K12SchoolComprehensiveSupportIdentificationType') BEGIN
	DROP TABLE [dbo].[K12SchoolComprehensiveSupportIdentificationType]
END