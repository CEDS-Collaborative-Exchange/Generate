IF NOT EXISTS(SELECT 1 FROM [App].[DataMigrationTypes] WHERE [DataMigrationTypeCode] = 'ps')
INSERT INTO [App].[DataMigrationTypes]
           ([DataMigrationTypeCode]
           ,[DataMigrationTypeName])
     VALUES
           (
		'ps'
           ,'Post Secondary Data Store'
		)