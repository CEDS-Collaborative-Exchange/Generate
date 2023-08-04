--Staging to IDS scripts
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Migrate_StagingToIDS_CharterSchoolManagementOrganization'))
	drop procedure Staging.Migrate_StagingToIDS_CharterSchoolManagementOrganization
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Migrate_StagingToIDS_Discipline')) 
	drop procedure Staging.Migrate_StagingToIDS_Discipline
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Migrate_StagingToIDS_K12ProgramParticipation')) 
	drop procedure Staging.Migrate_StagingToIDS_K12ProgramParticipation
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Migrate_StagingToIDS_Migrant')) 
	drop procedure Staging.Migrate_StagingToIDS_Migrant
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Migrate_StagingToIDS_OrganizationAddress')) 
	drop procedure Staging.Migrate_StagingToIDS_OrganizationAddress
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Migrate_StagingToIDS_OrganizationCalendarSession')) 
	drop procedure Staging.Migrate_StagingToIDS_OrganizationCalendarSession
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Migrate_StagingToIDS_ProgramParticipationCTE')) 
	drop procedure Staging.Migrate_StagingToIDS_ProgramParticipationCTE
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Migrate_StagingToIDS_ProgramParticipationNorD')) 
	drop procedure Staging.Migrate_StagingToIDS_ProgramParticipationNorD
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Migrate_StagingToIDS_ProgramParticipationTitleI')) 
	drop procedure Staging.Migrate_StagingToIDS_ProgramParticipationTitleI
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Migrate_StagingToIDS_ProgramParticipationTitleIII')) 
	drop procedure Staging.Migrate_StagingToIDS_ProgramParticipationTitleIII
--Staging to IDS wrapper scripts
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_ChildCount_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_ChildCount_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_Chronic_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_Chronic_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_CTE_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_CTE_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_Directory_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_Directory_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_Discipline_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_Discipline_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_Dropout_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_Dropout_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_Exiting_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_Exiting_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_Grad_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_Grad_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_GradRate_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_Gradrate_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_Homeless_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_Homeless_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_HsGradEnroll_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_HsGradEnroll_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_Immigrant_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_Immigrant_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_Membership_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_Membership_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_Mep_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_Mep_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_NorD_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_NorD_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_TitleI_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_TitleI_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_TitleIIIELOCT_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_TitleIIIELOCT_to_IDS
IF EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND OBJECT_ID = OBJECT_ID('Staging.Wrapper_Migrate_TitleIIIELSY_to_IDS')) 
	drop procedure Staging.Wrapper_Migrate_TitleIIIELSY_to_IDS


