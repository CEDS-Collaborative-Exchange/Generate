IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'RefComprehensiveSupportReasonApplicability') BEGIN
	DROP TABLE [dbo].[RefComprehensiveSupportReasonApplicability]
END