--Update app.ToggleAssessments set PerformanceLevels = 6

IF NOT EXISTS(select 1 from app.GenerateConfigurations where GenerateConfigurationCategory = 'Metadata' and GenerateConfigurationKey = 'SchoolYear')
BEGIN
	INSERT INTO [App].[GenerateConfigurations]
			   ([GenerateConfigurationCategory]
			   ,[GenerateConfigurationKey]
			   ,[GenerateConfigurationValue])
		 VALUES('Metadata', 'SchoolYear', '2026')
END