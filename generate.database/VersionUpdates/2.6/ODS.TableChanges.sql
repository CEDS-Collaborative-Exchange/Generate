-- Release-Specific table changes for the ODS schema
-- e.g. changes to the CEDS data model
----------------------------------


set nocount on
begin try
 
	begin transaction

	------------------------
	-- Place code here
	------------------------
	

	IF NOT EXISTS(SELECT 1 FROM sys.Tables WHERE Name = N'RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus' AND Type = N'U')
	BEGIN		
			CREATE TABLE [ODS].[RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus](
			    [RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId] [int] IDENTITY(1,1) NOT NULL,
				[Description] nvarchar(100) NULL, 
				[Code] nvarchar(50) NULL, 
				[Definition] nvarchar(max) NULL,
				[RefJurisdictionId] int NULL, 
				[SortOrder] [decimal](5, 2) NULL
			 CONSTRAINT [PK_RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus] PRIMARY KEY CLUSTERED 
			(
				[RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]


			
	END

	IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId' AND Object_ID = Object_ID(N'ODS.K12SchoolStatus'))
	BEGIN
		ALTER TABLE ODS.K12SchoolStatus  add RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId int, ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatus nvarchar(50)
		ALTER TABLE [ODS].[K12SchoolStatus]  WITH CHECK ADD  CONSTRAINT [FK_K12SchoolStatus_RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus] FOREIGN KEY([RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId])
			REFERENCES [ODS].[RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus] ([RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId])
		
		
			
	END

	If NOT EXISTS (select 1 from ODS.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus) 
	BEGIN
		insert into ODS.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus([Description], [Code], [Definition],[SortOrder]) values('State defined status','STTDEF' ,'A status defined by the state.  The state defined status is provided in a separate field in the file.',1.0)
		insert into ODS.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus([Description], [Code], [Definition],[SortOrder]) values('Too few students','TOOFEW','The number of students in the school was less than the minimum group size necessary required to reliably calculate the indicator',2.0)
		insert into ODS.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus([Description], [Code], [Definition],[SortOrder]) values('No students in the subgroup','NOSTUDENTS','If no students are in the school, the school should not be included in this file. If the school is included, then the status would be NOSTUDENTS. ',3.0)
	END

	
	if not exists (select * from ODS.RefOrganizationType where Code='LEANotFederal' and RefOrganizationElementTypeId=2)
		INSERT INTO ODS.RefOrganizationType VALUES (
			'Local Education Agency (LEA) Not Reported Federally', 
			'LEANotFederal', 
			'An administrative unit at the local level which exists primarily to operate schools or to contract for educational services. These units may or may not be co-extensive with county, city, or town boundaries that does not have reporting accountability at the federal level.', 
			null, 
			2, 
			46
		)

	if not exists (select * from ODS.RefOrganizationType where Code='K12SchoolNotFederal' and RefOrganizationElementTypeId=2)
		INSERT INTO ODS.RefOrganizationType VALUES (
			'K12 School Not Reported Federally', 
			'K12SchoolNotFederal', 'An institution that provides educational services; has one or more grade groups (PK through 12); has one or more teachers; is located in one or more buildings; has an assigned administrator(s); does not have reporting accountability at the federal level.', 
			null, 
			2, 
			48
		)


	commit transaction
 
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off
