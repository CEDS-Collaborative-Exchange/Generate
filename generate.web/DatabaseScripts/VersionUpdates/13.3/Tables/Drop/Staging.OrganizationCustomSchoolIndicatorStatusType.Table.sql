IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'Staging' AND TABLE_NAME = 'OrganizationCustomSchoolIndicatorStatusType') BEGIN
	DROP TABLE [Staging].[OrganizationCustomSchoolIndicatorStatusType]
END