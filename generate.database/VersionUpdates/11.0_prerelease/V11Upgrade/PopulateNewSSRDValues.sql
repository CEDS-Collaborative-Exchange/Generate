if not exists (select top 1 * from Staging.SourceSystemReferenceData where SchoolYear = 2023 and TableName = 'RefTitleIIILanguageInstructionProgramType')
	begin
		insert into staging.SourceSystemReferenceData
		select 2023, 'RefTitleIIILanguageInstructionProgramType', NULL, Code, Code
		from dbo.RefTitleIIILanguageInstructionProgramType
	end

if not exists (select top 1 * from Staging.SourceSystemReferenceData where SchoolYear = 2023 and TableName = 'RefProficiencyStatus')
	begin
		insert into staging.SourceSystemReferenceData
		select 2023, 'RefProficiencyStatus', NULL, Code, Code
		from dbo.RefProficiencyStatus
	end

 if not exists (select top 1 * from Staging.SourceSystemReferenceData where SchoolYear = 2023 and TableName = 'RefTitleIIIAccountability')
	begin
		insert into staging.SourceSystemReferenceData
		select 2023, 'RefTitleIIIAccountability', NULL, Code, Code
		from dbo.RefTitleIIIAccountability
	end
