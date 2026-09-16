IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'Staging' AND TABLE_NAME = 'OrganizationSchoolComprehensiveAndTargetedSupport') BEGIN
	DROP TABLE [Staging].[OrganizationSchoolComprehensiveAndTargetedSupport]
END