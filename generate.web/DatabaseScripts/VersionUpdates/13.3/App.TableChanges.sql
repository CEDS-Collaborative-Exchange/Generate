IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UX_GenerateConfigurations' AND parent_object_id = OBJECT_ID('App.GenerateConfigurations'))
    ALTER TABLE [App].[GenerateConfigurations] DROP CONSTRAINT [UX_GenerateConfigurations]

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'App' AND TABLE_NAME = 'GenerateConfigurations' AND COLUMN_NAME = 'GenerateConfigurationCategory')
    ALTER TABLE [App].[GenerateConfigurations] ALTER COLUMN [GenerateConfigurationCategory] NVARCHAR(200) NOT NULL

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'App' AND TABLE_NAME = 'GenerateConfigurations' AND COLUMN_NAME = 'GenerateConfigurationKey')
    ALTER TABLE [App].[GenerateConfigurations] ALTER COLUMN [GenerateConfigurationKey] NVARCHAR(200) NOT NULL

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name = 'UX_GenerateConfigurations' AND parent_object_id = OBJECT_ID('App.GenerateConfigurations'))
BEGIN
    ALTER TABLE [App].[GenerateConfigurations] ADD  CONSTRAINT [UX_GenerateConfigurations] UNIQUE NONCLUSTERED 
    (
        [GenerateConfigurationCategory], [GenerateConfigurationKey] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
