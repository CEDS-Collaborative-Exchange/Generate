IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'K12SchoolTargetedSupportIdentificationType') 
BEGIN

    DROP TABLE [dbo].[K12SchoolTargetedSupportIdentificationType]

END


