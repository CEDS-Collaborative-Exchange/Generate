IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'Staging' AND TABLE_NAME = 'K12SchoolComprehensiveSupportIdentificationType') 
BEGIN

    DROP TABLE [Staging].[K12SchoolComprehensiveSupportIdentificationType]

END


