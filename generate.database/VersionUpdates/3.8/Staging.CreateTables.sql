set nocount on
begin try
	begin transaction

IF NOT EXISTS(SELECT 1 
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_SCHEMA = 'Staging' and TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME = 'SourceSystemReferenceData' )
BEGIN

	/****** Object:  Table [Staging].[Assessment]    Script Date: 12/3/2020 11:58:18 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[Assessment](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[AssessmentIdentifier] [varchar](50) NULL,
		[AssessmentTitle] [varchar](100) NULL,
		[AssessmentShortName] [varchar](100) NULL,
		[AssessmentAcademicSubject] [varchar](100) NULL,
		[AssessmentPurpose] [varchar](100) NULL,
		[AssessmentType] [varchar](100) NULL,
		[AssessmentTypeAdministeredToChildrenWithDisabilities] [varchar](100) NULL,
		[AssessmentFamilyTitle] [varchar](100) NULL,
		[AssessmentFamilyShortName] [varchar](100) NULL,
		[AssessmentAdministrationStartDate] [date] NULL,
		[AssessmentAdministrationFinishDate] [date] NULL,
		[AssessmentPerformanceLevelIdentifier] [varchar](100) NULL,
		[AssessmentPerformanceLevelLabel] [varchar](100) NULL,
		[AssessmentTypeAdministeredToEnglishLearners] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[AssessmentId] [int] NULL,
		[AssessmentAdministrationId] [int] NULL,
		[AssessmentSubtestId] [int] NULL,
		[AssessmentFormId] [int] NULL,
		[AssessmentPerformanceLevelId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_Assessment] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[AssessmentResult]    Script Date: 12/3/2020 11:58:18 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[AssessmentResult](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Student_Identifier_State] [varchar](100) NULL,
		[LEA_Identifier_State] [varchar](100) NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[AssessmentTitle] [varchar](100) NULL,
		[AssessmentAcademicSubject] [varchar](100) NULL,
		[AssessmentPurpose] [varchar](100) NULL,
		[AssessmentType] [varchar](100) NULL,
		[AssessmentTypeAdministeredToChildrenWithDisabilities] [varchar](100) NULL,
		[AssessmentTypeAdministeredToEnglishLearners] [varchar](100) NULL,
		[AssessmentAdministrationStartDate] [date] NULL,
		[AssessmentAdministrationFinishDate] [date] NULL,
		[AssessmentRegistrationParticipationIndicator] [bit] NULL,
		[GradeLevelWhenAssessed] [varchar](100) NULL,
		[ScoreValue] [varchar](50) NULL,
		[StateFullAcademicYear] [varchar](100) NULL,
		[LEAFullAcademicYear] [varchar](100) NULL,
		[SchoolFullAcademicYear] [varchar](100) NULL,
		[AssessmentRegistrationReasonNotCompleting] [varchar](100) NULL,
		[AssessmentPerformanceLevelIdentifier] [varchar](100) NULL,
		[AssessmentPerformanceLevelLabel] [varchar](100) NULL,		
		[AssessmentScoreMetricType] [varchar](100) NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[AssessmentRegistrationId] [int] NULL,
		[AssessmentAdministrationId] [int] NULL,
		[AssessmentId] [int] NULL,
		[PersonId] [int] NULL,
		[AssessmentFormId] [int] NULL,
		[AssessmentSubtestId] [int] NULL,
		[AssessmentPerformanceLevelId] [int] NULL,
		[AssessmentResultId] [int] NULL,
		[AssessmentResult_PerformanceLevelId] [int] NULL,
		[OrganizationID_LEA] [int] NULL,
		[OrganizationPersonRoleId_LEA] [int] NULL,
		[OrganizationID_School] [int] NULL,
		[OrganizationPersonRoleId_School] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_AssessmentResult] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[CharterSchoolAuthorizer]    Script Date: 12/3/2020 11:58:18 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[CharterSchoolAuthorizer](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[CharterSchoolAuthorizer_Identifier_State] [varchar](100) NULL,
		[CharterSchoolAuthorizerType] [varchar](100) NULL,
		[CharterSchoolAuthorizer_Name] [varchar](100) NULL,
		[RecordStartDateTime] [datetime] NULL,
		[RecordEndDateTime] [datetime] NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[CharterSchoolAuthorizerOrganizationId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[CharterSchoolManagementOrganization]    Script Date: 12/3/2020 11:58:18 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[CharterSchoolManagementOrganization] (
		[Id] [int] IDENTITY (1, 1) NOT NULL,
		[CharterSchoolManagementOrganization_Identifier_EIN] [varchar](100) NULL,
		[CharterSchoolManagementOrganization_Name] [varchar](100) NULL,
		[CharterSchoolManagementOrganization_Type] [varchar](100) NULL,
		[OrganizationIdentifier] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[CharterSchoolManagementOrganizationId] [int] NULL,
		[CharterSchoolId] [int] NULL,
		[RunDateTime] [datetime] NULL,
		CONSTRAINT [PK_CharterSchoolManagementOrganization] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC)
	);

	/****** Object:  Table [Staging].[DataCollection]    Script Date: 12/3/2020 11:58:18 AM ******/
	--SET ANSI_NULLS ON

	--SET QUOTED_IDENTIFIER ON

	--CREATE TABLE [Staging].[DataCollection](
	--	[Id] [int] IDENTITY(1,1) NOT NULL,
	--	[SourceSystemDataCollectionIdentifier] [int] NULL,
	--	[SourceSystemName] [varchar](100) NULL,
	--	[DataCollectionName] [varchar](100) NULL,
	--	[DataCollectionDescription] [varchar](800) NULL,
	--	[DataCollectionOpenDate] [datetime] NULL,
	--	[DataCollectionCloseDate] [datetime] NULL,
	--	[DataCollectionAcademicSchoolYear] [varchar](50) NULL,
	--	[DataCollectionSchoolYear] [varchar](50) NULL,
	-- CONSTRAINT [PK_DataCollection] PRIMARY KEY CLUSTERED 
	--(
	--	[Id] ASC
	--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	--) ON [PRIMARY]

	/****** Object:  Table [Staging].[Discipline]    Script Date: 12/3/2020 11:58:18 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[Discipline](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Student_Identifier_State] [varchar](100) NULL,
		[LEA_Identifier_State] [varchar](100) NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[DisciplineActionIdentifier] [varchar](100) NULL,
		[IncidentIdentifier] [varchar](40) NULL,
		[IncidentDate] [date] NULL,
		[IncidentTime] [time](7) NULL,
		[DisciplinaryActionTaken] [varchar](100) NULL,
		[DisciplineReason] [varchar](100) NULL,
		[DisciplinaryActionStartDate] [date] NULL,
		[DisciplinaryActionEndDate] [date] NULL,
		[DurationOfDisciplinaryAction] [varchar](100) NULL,
		[IdeaInterimRemoval] [varchar](100) NULL,
		[IdeaInterimRemovalReason] [varchar](100) NULL,
		[EducationalServicesAfterRemoval] [bit] NULL,
		[DisciplineMethodFirearm] [varchar](100) NULL,
		[IDEADisciplineMethodFirearm] [varchar](100) NULL,
		[DisciplineMethodOfCwd] [varchar](100) NULL,
		[WeaponType] [varchar](100) NULL,
		[FirearmType] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[PersonId] [int] NULL,
		[OrganizationID_LEA] [int] NULL,
		[OrganizationPersonRoleId_LEA] [int] NULL,
		[OrganizationID_School] [int] NULL,
		[OrganizationPersonRoleId_School] [int] NULL,
		[IncidentId_LEA] [int] NULL,
		[IncidentId_School] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_Discipline] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[EarlyLearninrganization]    Script Date: 12/3/2020 11:58:18 AM ******/
	--SET ANSI_NULLS ON

	--SET QUOTED_IDENTIFIER ON

	--CREATE TABLE [Staging].[EarlyLearninrganization](
	--	[Id] [int] IDENTITY(1,1) NOT NULL,
	--	[OrganizationIdentifier_State] [varchar](100) NULL,
	--	[WebSiteAddress] [varchar](300) NULL,
	--	[OperationalStatusEffectiveDate] [datetime] NULL,
	--	[OrganizationName] [varchar](100) NULL,
	--	[OrganizationOperationalStatus] [varchar](100) NULL,
	--	[DataCollectionName] [nvarchar](100) NULL,
	--	[DataCollectionId] [int] NULL,
	--	[OrganizationId] [int] NULL,
	--	[OrganizationOperationalStatusId] [int] NULL,
	--	[RunDateTime] [datetime] NULL,
	-- CONSTRAINT [PK_EarlyLearninrganization] PRIMARY KEY CLUSTERED 
	--(
	--	[Id] ASC
	--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
	--) ON [PRIMARY]

	/****** Object:  Table [Staging].[FipsCounty]    Script Date: 12/3/2020 11:58:18 AM ******/
	--SET ANSI_NULLS ON

	--SET QUOTED_IDENTIFIER ON

	--CREATE TABLE [Staging].[FipsCounty](
	--	[Id] [int] IDENTITY(1,1) NOT NULL,
	--	[State] [varchar](50) NULL,
	--	[StateFipsCode] [varchar](50) NULL,
	--	[CountyFipsCode] [varchar](50) NULL,
	--	[CountyName] [varchar](50) NULL
	-- CONSTRAINT [PK_FipsCounty] PRIMARY KEY CLUSTERED 
	--(
	--	[Id] ASC
	--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
	--) ON [PRIMARY]

	/****** Object:  Table [Staging].[FIPSCountyNew]    Script Date: 12/3/2020 11:58:18 AM ******/
	--SET ANSI_NULLS ON

	--SET QUOTED_IDENTIFIER ON

	--CREATE TABLE [Staging].[FIPSCountyNew](
	--	[Id] [int] IDENTITY(1,1) NOT NULL,
	--	[State] [varchar](50) NULL,
	--	[StateFipsCode1] [varchar](50) NULL,
	--	[StateFipsCode2] [varchar](50) NULL,
	--	[CountyName] [varchar](255) NULL,
	--	[SubdivisionCode] [varchar](50) NULL,
	--	[SubdivisionName] [varchar](255) NULL,
	--	[Status] [varchar](50) NULL
	-- CONSTRAINT [PK_FipsCountyNew] PRIMARY KEY CLUSTERED 
	--(
	--	[Id] ASC
	--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
	--) ON [PRIMARY]

	/****** Object:  Table [Staging].[IndicatorStatusCustomType]    Script Date: 12/3/2020 11:58:18 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[IndicatorStatusCustomType](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Description] [nvarchar](100) NULL,
		[Code] [nvarchar](50) NULL,
		[Definition] [nvarchar](max) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
	 CONSTRAINT [PK_IndicatorStatusCustomType] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	/****** Object:  Table [Staging].[K12Enrollment]    Script Date: 12/3/2020 11:58:18 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[K12Enrollment] (
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Student_Identifier_State] [varchar](100) NULL,
		[LEA_Identifier_State] [varchar](100) NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[FirstName] [varchar](100) NULL,
		[LastName] [varchar](100) NULL,
		[MiddleName] [varchar](100) NULL,
		[Birthdate] [date] NULL,
		[Sex] [varchar](30) NULL,
		[HispanicLatinoEthnicity] [bit] NULL,
		[EnrollmentEntryDate] [date] NULL,
		[EnrollmentExitDate] [date] NULL,
		[ExitOrWithdrawalType] [varchar](100) NULL,
		[GradeLevel] [varchar](100) NULL,
		[CohortYear] [nchar](4) NULL,
		[CohortGraduationYear] [nchar](4) NULL,
		[CohortDescription] [nchar](1024) NULL,
		[ProjectedGraduationDate] [varchar](8) NULL,
		[HighSchoolDiplomaType] [varchar](100) NULL,
		[NumberOfSchoolDays] [decimal](9, 2) NULL,
		[NumberOfDaysAbsent] [decimal](9, 2) NULL,
		[AttendanceRate] [decimal](5, 4) NULL,
		[PostSecondaryEnrollment] [bit] NULL,
		[DiplomaOrCredentialAwardDate] [date] NULL,
		[FoodServiceEligibility] [varchar](100) NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[PersonId] [int] NULL,
		[OrganizationID_LEA] [int] NULL,
		[OrganizationPersonRoleId_LEA] [int] NULL,
		[OrganizationID_School] [int] NULL,
		[OrganizationPersonRoleId_School] [int] NULL,
		[OrganizationPersonRoleRelationshipId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_K12Enrollment] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[K12Organization]    Script Date: 12/3/2020 11:58:18 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[K12Organization](												
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[IEU_Identifier_State] [nvarchar](100) NULL,
		[IEU_Name] [nvarchar](256) NULL,
		[IEU_OrganizationOperationalStatus] [varchar](100) NULL,
		[IEU_OperationalStatusEffectiveDate] [datetime] NULL,
		[IEU_WebSiteAddress] [nvarchar](300) NULL,
		[IEU_RecordStartDateTime] [datetime] NULL,
		[IEU_RecordEndDateTime] [datetime] NULL,
		[LEA_Identifier_State] [varchar](100) NULL,								
		[LEA_Identifier_NCES] [varchar](100) NULL,
		[LEA_SupervisoryUnionIdentificationNumber] [varchar](100) NULL,
		[LEA_Name] [varchar](256) NULL,
		[LEA_WebSiteAddress] [varchar](300) NULL,
		[LEA_OperationalStatus] [varchar](100) NULL,
		[LEA_OperationalStatusEffectiveDate] [datetime] NULL,
		[LEA_CharterLeaStatus] [varchar](100) NULL,
		[LEA_CharterSchoolIndicator] [bit] NULL,
		[LEA_Type] [varchar](100) NULL,
		[LEA_McKinneyVentoSubgrantRecipient] [bit] NULL,
		[LEA_GunFreeSchoolsActReportingStatus] [varchar](100) NULL,
		[LEA_TitleIinstructionalService] [varchar](100) NULL,
		[LEA_TitleIProgramType] [varchar](100) NULL,
		[LEA_K12LeaTitleISupportService] [varchar](100) NULL,
		[LEA_MepProjectType] [varchar](100) NULL,
		[LEA_IsReportedFederally] [bit] NULL,
		[LEA_RecordStartDateTime] [datetime] NULL,
		[LEA_RecordEndDateTime] [datetime] NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[School_Identifier_NCES] [varchar](100) NULL,
		[School_Name] [varchar](256) NULL,
		[School_WebSiteAddress] [varchar](300) NULL,
		[School_OperationalStatus] [varchar](100) NULL,
		[School_OperationalStatusEffectiveDate] [datetime] NULL,
		[School_Type] [varchar](100) NULL,
		[School_MagnetOrSpecialProgramEmphasisSchool] [varchar](100) NULL,
		[School_SharedTimeIndicator] [varchar](100) NULL,
		[School_VirtualSchoolStatus] [varchar](100) NULL,
		[School_NationalSchoolLunchProgramStatus] [varchar](100) NULL,
		[School_ReconstitutedStatus] [varchar](100) NULL,
		[School_CharterSchoolApprovalAgencyType] [varchar](100) NULL,
		[School_CharterSchoolIndicator] [bit] NULL,
		[School_CharterSchoolOpenEnrollmentIndicator] [bit] NULL,
		[School_CharterSchoolFEIN] [varchar](100) NULL,
		[School_CharterSchoolFEIN_Update] [varchar](100) NULL,
		[School_CharterContractIDNumber] [varchar](100) NULL,
		[School_CharterContractApprovalDate] [datetime] NULL,
		[School_CharterContractRenewalDate] [datetime] NULL,
		[School_CharterPrimaryAuthorizer] [varchar](100) NULL,
		[School_CharterSecondaryAuthorizer] [varchar](100) NULL,
		[School_StatePovertyDesignation] [varchar](100) NULL,
		[SchoolImprovementAllocation] [money] NULL,
		[School_IndicatorStatusType] [varchar](100) NULL,
		[School_GunFreeSchoolsActReportingStatus] [varchar](100) NULL,
		[School_ProgressAchievingEnglishLanguageProficiencyIndicatorStatus] [varchar](100) NULL,
		[School_ProgressAchievingEnglishLanguageProficiencyStateDefinedStatus] [varchar](100) NULL,
		[School_SchoolDangerousStatus] [varchar](100) NULL,
		[TitleIPartASchoolDesignation] [varchar](100) NULL,
		[School_ComprehensiveAndTargetedSupport] [varchar](100) NULL,
		[School_ComprehensiveSupport] [varchar](100) NULL,
		[School_TargetedSupport] [varchar](100) NULL,
		[ConsolidatedMepFundsStatus] [bit] NULL,
		[School_MepProjectType] [varchar](100) NULL,
		[AdministrativeFundingControl] [nvarchar](100) NULL,
		[School_IsReportedFederally] [bit] NULL,
		[School_RecordStartDateTime] [datetime] NULL,
		[School_RecordEndDateTime] [datetime] NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[OrganizationId_SEA] [int] NULL,								
		[OrganizationId_IEU] [int] NULL,								
		[OrganizationId_LEA] [int] NULL,								
		[OrganizationId_School] [int] NULL,								
		[K12ProgramOrServiceId_LEA] [int] NULL,							
		[K12LeaTitleISupportServiceId] [int] NULL,					
		[K12ProgramOrServiceId_School] [int] NULL,						
		[NewIEU] [bit] NULL,											
		[NewLEA] [bit] NULL,											
		[NewSchool] [bit] NULL,											
		[IEU_Identifier_State_ChangedIdentifier] [bit] NULL,			
		[IEU_Identifier_State_Identifier_Old] [varchar](100) NULL,		
		[LEA_Identifier_State_ChangedIdentifier] [bit] NULL,		
		[LEA_Identifier_State_Identifier_Old] [varchar](100) NULL,		
		[School_Identifier_State_ChangedIdentifier] [bit] NULL,			
		[School_Identifier_State_Identifier_Old] [varchar](100) NULL,	
		[OrganizationRelationshipId_SEAToIEU] [int] NULL,				
		[OrganizationRelationshipId_IEUToLEA] [int] NULL,				
		[OrganizationRelationshipId_SEAToLEA] [int] NULL,				
		[OrganizationRelationshipId_LEAToSchool] [int] NULL,			
		[OrganizationRelationshipId_SchoolToPrimaryCharterSchoolAuthorizer] [int] NULL,
		[OrganizationRelationshipId_SchoolToSecondaryCharterSchoolAuthorizer] [int] NULL,
		[OrganizationWebsiteId_LEA] [int] NULL,							
		[OrganizationWebsiteId_School] [int] NULL,						
		[OrganizationOperationalStatusId_IEU] [int] NULL,				
		[OrganizationOperationalStatusId_LEA] [int] NULL,				
		[OrganizationOperationalStatusId_School] [int] NULL,		
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_K12Organization] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[K12ProgramEnrollment]    Script Date: 12/3/2020 11:58:18 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[K12ProgramParticipation](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[OrganizationIdentifier] [nvarchar](60) NOT NULL,
		[OrganizationType] [nvarchar](100) NULL,
		[Student_Identifier_State] [nvarchar](100) NULL,
		[ProgramType] [nvarchar](100) NULL,
		[EntryDate] [datetime] NULL,
		[ExitDate] [datetime] NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[OrganizationId] [int] NULL,
		[PersonId] [int] NULL,
		[ProgramOrganizationId] [int] NULL,
		[OrganizationPersonRoleId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_K12ProgramParticipation] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]


	/****** Object:  Table [Staging].[K12SchoolComprehensiveSupportIdentificationType]    Script Date: 5/19/2021 10:47:36 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[K12SchoolComprehensiveSupportIdentificationType](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[SchoolYear] [varchar](4) NULL,
		[LEA_Identifier_State] [varchar](100) NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[ComprehensiveSupport] [varchar](20) NULL,
		[ComprehensiveSupportReasonApplicability] [varchar](20) NULL,
		[RecordStartDateTime] [datetime] NULL,
		[RecordEndDateTime] [datetime] NULL,
		[OrganizationId] [int] NULL,
		[K12SchoolId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[K12SchoolTargetedSupportIdentificationType]    Script Date: 5/19/2021 10:50:54 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[K12SchoolTargetedSupportIdentificationType](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[SchoolYear] [varchar](4) NULL,
		[LEA_Identifier_State] [varchar](100) NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[Subgroup] [varchar](100) NULL,
		[ComprehensiveSupportReasonApplicability] [varchar](20) NULL,
		[RecordStartDateTime] [datetime] NULL,
		[RecordEndDateTime] [datetime] NULL,
		[OrganizationId] [int] NULL,
		[K12SchoolId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[K12StaffAssignment]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[K12StaffAssignment](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Personnel_Identifier_State] [varchar](100) NULL,
		[LEA_Identifier_State] [varchar](100) NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[FirstName] [varchar](100) NULL,
		[LastName] [varchar](100) NULL,
		[MiddleName] [varchar](100) NULL,
		[Sex] [varchar](30) NULL,
		[FullTimeEquivalency] [decimal](5, 4) NULL,
		[SpecialEducationStaffCategory] [varchar](100) NULL,
		[K12StaffClassification] [varchar](100) NULL,
		[TitleIProgramStaffCategory] [varchar](100) NULL,
		[CredentialType] [varchar](100) NULL,
		[CredentialIssuanceDate] [date] NULL,
		[CredentialExpirationDate] [date] NULL,
		[ParaprofessionalQualification] [varchar](100) NULL,
		[SpecialEducationAgeGroupTaught] [varchar](100) NULL,
		[HighlyQualifiedTeacherIndicator] [bit] NULL,
		[AssignmentStartDate] [date] NULL,
		[AssignmentEndDate] [date] NULL,
		[InexperiencedStatus] [varchar](100) NULL,
		[EmergencyorProvisionalCredentialStatus] [varchar](100) NULL,
		[OutOfFieldStatus] [varchar](100) NULL,
		[ProgramTypeCode] [varchar](100) NULL,
		[RecordStartDateTime] [date] NULL,
		[RecordEndDateTime] [date] NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[PersonId] [int] NULL,
		[OrganizationId_IEU] [int] NULL,
		[OrganizationId_LEA] [int] NULL,
		[OrganizationId_School] [int] NULL,
		[OrganizationPersonRoleId_IEU] [int] NULL,
		[OrganizationPersonRoleId_LEA] [int] NULL,
		[OrganizationPersonRoleId_School] [int] NULL,
		[OrganizationPersonRoleRelationshipId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_K12StaffAssignment] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[K12StudentCourseSection]    Script Date: 12/3/2020 11:58:18 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[K12StudentCourseSection](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Student_Identifier_State] [varchar](100) NULL,
		[LEA_Identifier_State] [varchar](100) NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[CourseGradeLevel] [varchar](100) NULL,
		[ScedCourseCode] [nvarchar](50) NULL,
		[CourseRecordStartDateTime] [datetime] NULL,
		[CourseLevelCharacteristic] [nvarchar](50) NULL,
		[EntryDate] [datetime] NULL,
		[ExitDate] [datetime] NULL,
		[SchoolYear] [int] NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[PersonId] [int] NULL,
		[OrganizationID_LEA] [int] NULL,
		[OrganizationPersonRoleId_LEA] [int] NULL,
		[OrganizationID_School] [int] NULL,
		[OrganizationPersonRoleId_School] [int] NULL,
		[OrganizationID_Course] [int] NULL,
		[OrganizationID_CourseSection] [int] NULL,
		[OrganizationPersonRoleId_CourseSection] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_K12CourseSection] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[Migrant]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[Migrant](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[LEA_Identifier_State] [varchar](100) NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[Student_Identifier_State] [varchar](100) NULL,
		[MigrantStatus] [varchar](100) NULL,
		[MigrantEducationProgramEnrollmentType] [varchar](100) NULL,
		[MigrantEducationProgramServicesType] [varchar](100) NULL,
		[MigrantEducationProgramContinuationOfServicesStatus] [bit] NULL,
		[ContinuationOfServicesReason] [varchar](100) NULL,
		[MigrantStudentQualifyingArrivalDate] [date] NULL,
		[LastQualifyingMoveDate] [date] NULL,
		[MigrantPrioritizedForServices] [bit] NULL,
		[ProgramParticipationStartDate] [date] NULL,
		[ProgramParticipationExitDate] [date] NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[PersonID] [int] NULL,
		[OrganizationID_LEA] [int] NULL,
		[OrganizationID_School] [int] NULL,
		[LEAOrganizationPersonRoleID_MigrantProgram] [int] NULL,
		[LEAOrganizationID_MigrantProgram] [int] NULL,
		[SchoolOrganizationPersonRoleID_MigrantProgram] [int] NULL,
		[SchoolOrganizationID_MigrantProgram] [int] NULL,
		[PersonProgramParticipationId] [int] NULL,
		[ProgramParticipationMigrantId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_Migrant] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[OrganizationAddress]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[OrganizationAddress](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[OrganizationIdentifier] [varchar](60) NULL,
		[OrganizationType] [varchar](100) NULL,
		[AddressTypeForOrganization] [varchar](50) NULL,
		[AddressStreetNumberAndName] [varchar](150) NULL,
		[AddressApartmentRoomOrSuite] [varchar](50) NULL,
		[AddressCity] [varchar](30) NULL,
		[AddressCountyAnsiCode] [nvarchar](7) NULL,
		[StateAbbreviation] [varchar](2) NULL,
		[AddressPostalCode] [varchar](17) NULL,
		[Latitude] [nvarchar](100) NULL,
		[Longitude] [nvarchar](100) NULL,
		[SchoolYear] [varchar](100) NULL,
		[RecordStartDateTime] [datetime] NULL,
		[RecordEndDateTime] [datetime] NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[RefStateId] [int] NULL,
		[OrganizationId] [int] NULL,
		[LocationId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_OrganizationAddress] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[OrganizationCalendarSession]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[OrganizationCalendarSession](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[OrganizationIdentifier] [nvarchar](100) NULL,
		[OrganizationType] [nvarchar](50) NULL,
		[CalendarYear] [nvarchar](50) NULL,
		[BeginDate] [datetime] NULL,
		[EndDate] [datetime] NULL,
		[SessionType] [nvarchar](100) NULL,
		[AcademicTermDesignator] [nvarchar](100) NULL,
		[DataCollectionName] [nvarchar](50) NULL,
		[DataCollectionId] [int] NULL,
		[OrganizationId] [int] NULL,
		[OrganizationCalendarId] [int] NULL,
		[OrganizationCalendarSessionId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_Session] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[OrganizationCustomSchoolIndicatorStatusType]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[OrganizationCustomSchoolIndicatorStatusType](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[School_Identifier_State] [varchar](100) NOT NULL,
		[IndicatorStatusType] [varchar](100) NULL,
		[IndicatorStatus] [varchar](100) NULL,
		[IndicatorStatusSubgroupType] [varchar](100) NULL,
		[IndicatorStatusSubgroup] [varchar](100) NULL,
		[StatedDefinedIndicatorStatus] [varchar](100) NULL,
		[StatedDefinedCustomIndicatorStatusType] [varchar](100) NULL,
		[RecordStartDateTime] [date] NULL,
		[RecordEndDateTime] [date] NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_OrganizationCustomSchoolIndicatorStatusType] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[OrganizationFederalFunding]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[OrganizationFederalFunding](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[OrganizationIdentifier] [varchar](60) NULL,
		[OrganizationType] [varchar](100) NULL,
		[FederalProgramCode] [varchar](10) NULL,
		[FederalProgramsFundingAllocation] [numeric](12, 2) NULL,
		[ParentalInvolvementReservationFunds] [numeric](12, 2) NULL,
		[REAPAlternativeFundingStatusCode] [varchar](100) NULL,
		[FederalProgramFundingAllocationType] [varchar](100) NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_OrganizationFederalFunding] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[OrganizationGradeOffered]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[OrganizationGradeOffered](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[OrganizationIdentifier] [varchar](100) NULL,
		[GradeOffered] [varchar](100) NULL,
		[RecordStartDateTime] [datetime] NULL,
		[RecordEndDateTime] [datetime] NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[OrganizationId] [int] NULL,
		[K12SchoolGradeOfferedId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_OrganizationGradeOffered] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[OrganizationPhone]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[OrganizationPhone](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[OrganizationIdentifier] [varchar](100) NULL,
		[OrganizationType] [varchar](100) NULL,
		[InstitutionTelephoneNumberType] [varchar](100) NULL,
		[TelephoneNumber] [varchar](100) NULL,
		[PrimaryTelephoneNumberIndicator] [bit] NULL,
		[RecordStartDateTime] [datetime] NULL,
		[RecordEndDateTime] [datetime] NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[OrganizationId] [int] NULL,
		[OrganizationTelephoneId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_OrganizationPhone] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[OrganizationProgramType]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[OrganizationProgramType](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[OrganizationIdentifier] [nvarchar](60) NULL,
		[OrganizationType] [nvarchar](100) NULL,
		[OrganizationName] [nvarchar](100) NULL,
		[ProgramType] [nvarchar](50) NULL,
		[RecordStartDateTime] [datetime] NULL,
		[RecordEndDateTime] [datetime] NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [varchar](50) NULL,
		[DataCollectionId] [int] NULL,
		[OrganizationId] [int] NULL,
		[ProgramOrganizationId] [int] NULL,
		[ProgramTypeId] [int] NULL,
		[OrganizationProgramTypeId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_OrganizationProgramType] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[OrganizationSchoolComprehensiveAndTargetedSupport]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[OrganizationSchoolComprehensiveAndTargetedSupport](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[School_Identifier_State] [varchar](100) NOT NULL,
		[School_ComprehensiveAndTargetedSupport] [varchar](100) NULL,
		[School_ComprehensiveSupport] [varchar](100) NULL,
		[School_TargetedSupport] [varchar](100) NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_OrganizationSchoolComprehensiveAndTargetedSupport] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[OrganizationSchoolIndicatorStatus]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[OrganizationSchoolIndicatorStatus](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[School_Identifier_State] [varchar](100) NOT NULL,
		[IndicatorStatusType] [varchar](100) NULL,
		[IndicatorStatus] [varchar](100) NULL,
		[IndicatorStatusSubgroupType] [varchar](100) NULL,
		[IndicatorStatusSubgroup] [varchar](100) NULL,
		[StatedDefinedIndicatorStatus] [varchar](100) NULL,
		[RecordStartDateTime] [datetime] NULL,
		[RecordEndDateTime] [datetime] NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_OrganizationSchoolIndicatorStatus] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]


	/****** Object:  Table [Staging].[PersonRace]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[PersonRace](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Student_Identifier_State] [varchar](100) NULL,
		[OrganizationIdentifier] [varchar](60) NULL,
		[OrganizationType] [varchar](100) NULL,
		[RaceType] [varchar](100) NULL,
		[AcademicTermDesignator] [varchar](100) NULL,
		[RecordStartDateTime] [datetime] NULL,
		[RecordEndDateTime] [datetime] NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[PersonId] [int] NULL,
		[PersonDemographicRaceId] [int] NULL,
		[OrganizationId] [int] NULL,
		[RefRaceId] [int] NULL,
		[RefAcademicTermDesignatorId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_PersonRace] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[PersonStatus]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[PersonStatus](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Student_Identifier_State] [varchar](100) NULL,
		[LEA_Identifier_State] [varchar](100) NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[HomelessnessStatus] [bit] NULL,
		[Homelessness_StatusStartDate] [date] NULL,
		[Homelessness_StatusEndDate] [date] NULL,
		[HomelessNightTimeResidence] [varchar](100) NULL,
		[HomelessNightTimeResidence_StartDate] [date] NULL,
		[HomelessNightTimeResidence_EndDate] [date] NULL,
		[HomelessUnaccompaniedYouth] [bit] NULL,
		[HomelessServicedIndicator] [bit] NULL,
		[EconomicDisadvantageStatus] [bit] NULL,
		[EconomicDisadvantage_StatusStartDate] [date] NULL,
		[EconomicDisadvantage_StatusEndDate] [date] NULL,
		[EligibilityStatusForSchoolFoodServicePrograms] [varchar](100) NULL,
		[NationalSchoolLunchProgramDirectCertificationIndicator] [bit] NULL,
		[MigrantStatus] [bit] NULL,
		[Migrant_StatusStartDate] [date] NULL,
		[Migrant_StatusEndDate] [date] NULL,
		[MilitaryConnectedStudentIndicator] [varchar](100) NULL,
		[MilitaryConnected_StatusStartDate] [date] NULL,
		[MilitaryConnected_StatusEndDate] [date] NULL,
		[ProgramType_FosterCare] [bit] NULL,
		[FosterCare_ProgramParticipationStartDate] [date] NULL,
		[FosterCare_ProgramParticipationEndDate] [date] NULL,
		[ProgramType_Section504] [bit] NULL,
		[Section504_ProgramParticipationStartDate] [date] NULL,
		[Section504_ProgramParticipationEndDate] [date] NULL,
		[ProgramType_Immigrant] [bit] NULL,
		[Immigrant_ProgramParticipationStartDate] [date] NULL,
		[Immigrant_ProgramParticipationEndDate] [date] NULL,
		[EnglishLearnerStatus] [bit] NULL,
		[EnglishLearner_StatusStartDate] [date] NULL,
		[EnglishLearner_StatusEndDate] [date] NULL,
		[ISO_639_2_NativeLanguage] [varchar](100) NULL,
		[PerkinsLEPStatus] [varchar](100) NULL,
		[PerkinsLEPStatus_StatusStartDate] [date] NULL,
		[PerkinsLEPStatus_StatusEndDate] [date] NULL,
		[IDEAIndicator] [bit] NULL,
		[IDEA_StatusStartDate] [date] NULL,
		[IDEA_StatusEndDate] [date] NULL,
		[PrimaryDisabilityType] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[PersonId] [int] NULL,
		[OrganizationID_IEU] [int] NULL,
		[OrganizationPersonRoleID_IEU] [int] NULL,
		[OrganizationID_LEA] [int] NULL,
		[OrganizationPersonRoleID_LEA] [int] NULL,
		[OrganizationID_School] [int] NULL,
		[OrganizationPersonRoleID_School] [int] NULL,
		[OrganizationID_IEU_Program_Foster] [int] NULL,
		[OrganizationPersonRoleID_IEU_Program_Foster] [int] NULL,
		[OrganizationID_LEA_Program_Foster] [int] NULL,
		[OrganizationPersonRoleID_LEA_Program_Foster] [int] NULL,
		[OrganizationID_School_Program_Foster] [int] NULL,
		[OrganizationPersonRoleID_School_Program_Foster] [int] NULL,
		[OrganizationID_IEU_Program_Section504] [int] NULL,
		[OrganizationPersonRoleID_IEU_Program_Section504] [int] NULL,
		[OrganizationID_LEA_Program_Section504] [int] NULL,
		[OrganizationPersonRoleID_LEA_Program_Section504] [int] NULL,
		[OrganizationID_School_Program_Section504] [int] NULL,
		[OrganizationPersonRoleID_School_Program_Section504] [int] NULL,
		[OrganizationID_IEU_Program_Immigrant] [int] NULL,
		[OrganizationPersonRoleID_IEU_Program_Immigrant] [int] NULL,
		[OrganizationID_LEA_Program_Immigrant] [int] NULL,
		[OrganizationPersonRoleID_LEA_Program_Immigrant] [int] NULL,
		[OrganizationID_School_Program_Immigrant] [int] NULL,
		[OrganizationPersonRoleID_School_Program_Immigrant] [int] NULL,
		[OrganizationPersonRoleID_IEU_SPED] [int] NULL,
		[OrganizationPersonRoleID_LEA_SPED] [int] NULL,
		[OrganizationPersonRoleID_School_SPED] [int] NULL,
		[OrganizationID_IEU_Program_Homeless] [int] NULL,
		[OrganizationPersonRoleID_IEU_Program_Homeless] [int] NULL,
		[OrganizationID_LEA_Program_Homeless] [int] NULL,
		[OrganizationPersonRoleID_LEA_Program_Homeless] [int] NULL,
		[OrganizationID_School_Program_Homeless] [int] NULL,
		[OrganizationPersonRoleID_School_Program_Homeless] [int] NULL,
		[PersonStatusId_Homeless] [int] NULL,
		[PersonHomelessNightTimeResidenceId] [int] NULL,
		[PersonStatusId_EconomicDisadvantage] [int] NULL,
		[PersonStatusId_IDEA] [int] NULL,
		[PersonStatusId_EnglishLearner] [int] NULL,
		[PersonStatusId_PerkinsLEP] [int] NULL,
		[PersonLanguageId] [int] NULL,
		[PersonStatusId_Migrant] [int] NULL,
		[PersonMilitaryId] [int] NULL,
		[PersonHomelessnessId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_PersonStatus] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[ProgramParticipationCTE]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[ProgramParticipationCTE](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Student_Identifier_State] [varchar](100) NULL,
		[LEA_Identifier_State] [varchar](100) NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[IEU_Identifier_State] [varchar](100) NULL,
		[ProgramParticipationBeginDate] [date] NULL,
		[ProgramParticipationEndDate] [date] NULL,
/*		[DiplomaCredentialType] [varchar](100) NULL,
		[DiplomaCredentialType_2] [varchar](100) NULL,*/
		[DiplomaCredentialAwardDate] [date] NULL,
		[CteParticipant] [bit] NULL,
		[CteConcentrator] [bit] NULL,
		[CteCompleter] [bit] NULL,
		[CteExitReason] [varchar](100) NULL,
		[SingleParentIndicator] [bit] NULL,
		[SingleParent_StatusStartDate] [date] NULL,
		[SingleParent_StatusEndDate] [date] NULL,
		[DisplacedHomeMakerIndicator] [bit] NULL,
		[DisplacedHomeMaker_StatusStartDate] [date] NULL,
		[DisplacedHomeMaker_StatusEndDate] [date] NULL,
		[AdvancedTrainingEnrollmentDate] [date] NULL,
		[PlacementType] [varchar](100) NULL,
		[TechnicalSkillsAssessmentType] [varchar](100) NULL,
		[NonTraditionalGenderStatus] [bit] NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[PersonID] [int] NULL,
		[OrganizationID_IEU] [int] NULL,
		[OrganizationPersonRoleID_IEU] [int] NULL,
		[OrganizationID_LEA] [int] NULL,
		[OrganizationPersonRoleID_LEA] [int] NULL,
		[OrganizationID_School] [int] NULL,
		[OrganizationPersonRoleID_School] [int] NULL,
		[OrganizationPersonRoleID_CTEProgram_IEU] [int] NULL,
		[OrganizationPersonRoleID_CTEProgram_LEA] [int] NULL,
		[OrganizationPersonRoleID_CTEProgram_School] [int] NULL,
		[OrganizationID_CTEProgram_IEU] [int] NULL,
		[OrganizationID_CTEProgram_LEA] [int] NULL,
		[OrganizationID_CTEProgram_School] [int] NULL,
		[PersonProgramParticipationID_IEU] [int] NULL,
		[PersonProgramParticipationID_LEA] [int] NULL,
		[PersonProgramParticipationID_School] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_ProgramParticipationCTE] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]


	/****** Object:  Table [Staging].[ProgramParticipationNorD]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[ProgramParticipationNorD](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Student_Identifier_State] [varchar](100) NULL,
		[LEA_Identifier_State] [varchar](100) NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[ProgramParticipationBeginDate] [date] NULL,
		[ProgramParticipationEndDate] [date] NULL,
		[ProgramParticipationNorD] [varchar](100) NULL,
		[ProgressLevel_Reading] [varchar](100) NULL,
		[ProgressLevel_Math] [varchar](100) NULL,
		[Outcome] [varchar](100) NULL,
		[DiplomaCredentialAwardDate] [date] NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[PersonID] [int] NULL,
		[OrganizationID_IEU] [int] NULL,
		[OrganizationID_LEA] [int] NULL,
		[OrganizationID_School] [int] NULL,
		[OrganizationID_Program_IEU] [int] NULL,
		[OrganizationID_Program_LEA] [int] NULL,
		[OrganizationID_Program_School] [int] NULL,
		[OrganizationPersonRoleId_Program_IEU] [int] NULL,
		[OrganizationPersonRoleId_Program_LEA] [int] NULL,
		[OrganizationPersonRoleId_Program_School] [int] NULL,
		[PersonProgramParticipationID_IEU] [int] NULL,
		[PersonProgramParticipationID_LEA] [int] NULL,
		[PersonProgramParticipationID_School] [int] NULL,
		[RunDateTime] [datetime] NULL,
	PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[ProgramParticipationSpecialEducation]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[ProgramParticipationSpecialEducation](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Student_Identifier_State] [varchar](100) NULL,
		[LEA_Identifier_State] [varchar](100) NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[ProgramParticipationBeginDate] [date] NULL,
		[ProgramParticipationEndDate] [date] NULL,
		[SpecialEducationExitReason] [varchar](100) NULL,
		[IDEAEducationalEnvironmentForEarlyChildhood] [varchar](100) NULL,
		[IDEAEducationalEnvironmentForSchoolAge] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[PersonID] [int] NULL,
		[OrganizationID_IEU] [int] NULL,
		[OrganizationID_LEA] [int] NULL,
		[OrganizationID_School] [int] NULL,
		[OrganizationID_Program_IEU] [int] NULL,
		[OrganizationID_Program_LEA] [int] NULL,
		[OrganizationID_Program_School] [int] NULL,
		[OrganizationPersonRoleId_Program_IEU] [int] NULL,
		[OrganizationPersonRoleId_Program_LEA] [int] NULL,
		[OrganizationPersonRoleId_Program_School] [int] NULL,
		[PersonProgramParticipationID_IEU] [int] NULL,
		[PersonProgramParticipationID_LEA] [int] NULL,
		[PersonProgramParticipationID_School] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_ProgramParticipationSpecialEducation] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]



	/****** Object:  Table [Staging].[ProgramParticipationTitleI]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[ProgramParticipationTitleI](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Student_Identifier_State] [varchar](100) NULL,
		[LEA_Identifier_State] [varchar](100) NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[TitleIIndicator] [varchar](100) NULL,
		[ProgramParticipationBeginDate] [date] NULL,
		[ProgramParticipationEndDate] [date] NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[PersonID] [int] NULL,
		[RefTitleIIndicatorId] [int] NULL,
		[OrganizationID_IEU] [int] NULL,
		[OrganizationID_LEA] [int] NULL,
		[OrganizationID_School] [int] NULL,
		[OrganizationPersonRoleID_TitleIProgram_IEU] [int] NULL,
		[OrganizationPersonRoleID_TitleIProgram_LEA] [int] NULL,
		[OrganizationPersonRoleID_TitleIProgram_School] [int] NULL,
		[OrganizationID_TitleIProgram_IEU] [int] NULL,
		[OrganizationID_TitleIProgram_LEA] [int] NULL,
		[OrganizationID_TitleIProgram_School] [int] NULL,
		[PersonProgramParticipationId_IEU] [int] NULL,
		[PersonProgramParticipationId_LEA] [int] NULL,
		[PersonProgramParticipationId_School] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_ProgramParticipationTitleI] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[ProgramParticipationTitleIII]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[ProgramParticipationTitleIII](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Student_Identifier_State] [varchar](100) NULL,
		[LEA_Identifier_State] [varchar](100) NULL,
		[School_Identifier_State] [varchar](100) NULL,
		[ProgramParticipationBeginDate] [date] NULL,
		[ProgramParticipationEndDate] [date] NULL,
		[Participation_TitleIII] [varchar](100) NULL,
		[Proficiency_TitleIII] [varchar](100) NULL,
		[Progress_TitleIII] [varchar](100) NULL,
		[EnglishLearnerParticipation] [bit] NULL,
		[TitleIiiImmigrantStatus] [bit] NULL,
		[LanguageInstructionProgramServiceType] [varchar](100) NULL,
		[TitleIiiImmigrantStatus_StartDate] [date] NULL,
		[TitleIiiImmigrantStatus_EndDate] [date] NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[PersonID] [int] NULL,
		[PersonStatusId_Immigration] [int] NULL,
		[OrganizationID_IEU] [int] NULL,
		[OrganizationID_LEA] [int] NULL,
		[OrganizationID_School] [int] NULL,
		[OrganizationPersonRoleID_TitleIIIProgram_IEU] [int] NULL,
		[OrganizationPersonRoleID_TitleIIIProgram_LEA] [int] NULL,
		[OrganizationPersonRoleID_TitleIIIProgram_School] [int] NULL,
		[OrganizationID_TitleIIIProgram_IEU] [int] NULL,
		[OrganizationID_TitleIIIProgram_LEA] [int] NULL,
		[OrganizationID_TitleIIIProgram_School] [int] NULL,
		[PersonProgramParticipationId_IEU] [int] NULL,
		[PersonProgramParticipationId_LEA] [int] NULL,
		[PersonProgramParticipationId_School] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_ProgramParticipationTitleIII] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[PsInstitution]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[PsInstitution](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[OrganizationName] [varchar](200) NULL,
		[InstitutionIpedsUnitId] [nvarchar](50) NULL,
		[Website] [varchar](300) NULL,
		[OrganizationOperationalStatus] [varchar](100) NULL,
		[OperationalStatusEffectiveDate] [datetime] NULL,
		[MostPrevalentLevelOfInstitutionCode] [nvarchar](50) NULL,
		[PredominantCalendarSystem] [varchar](100) NULL,
		[RecordStartDateTime] [datetime] NULL,
		[RecordEndDateTime] [datetime] NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[OrganizationId] [int] NULL,
		[OrganizationOperationalStatusId] [int] NULL,
		[OperationalStatusId] [int] NULL,
		[MostPrevalentLevelOfInstitutionId] [int] NULL,
		[PredominantCalendarSystemId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_PsInstitution] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[PsStudentAcademicAward]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[PsStudentAcademicAward](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[InstitutionIpedsUnitId] [varchar](50) NULL,
		[Student_Identifier_State] [varchar](50) NULL,
		[ProfessionalOrTechnicalCredentialConferred] [nvarchar](50) NULL,
		[AcademicAwardDate] [datetime] NULL,
		[PescAwardLevelType] [nvarchar](200) NULL,
		[AcademicAwardTitle] [nvarchar](200) NULL,
		[EntryDate] [datetime] NULL,
		[ExitDate] [datetime] NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[OrganizationId] [int] NULL,
		[PersonId] [int] NULL,
		[OrganizationPersonRoleId] [int] NULL,
		[PsStudentAcademicAwardId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_PsStudentAcademicAward] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[PsStudentAcademicRecord]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[PsStudentAcademicRecord](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[InstitutionIpedsUnitId] [varchar](50) NULL,
		[Student_Identifier_State] [varchar](50) NULL,
		[DiplomaOrCredentialAwardDate] [datetime] NULL,
		[AcademicTermDesignator] [nvarchar](50) NULL,
		[ProfessionalOrTechnicalCredentialConferred] [varchar](50) NULL,
		[EntryDate] [datetime] NULL,
		[ExitDate] [datetime] NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[OrganizationId] [int] NULL,
		[PersonId] [int] NULL,
		[OrganizationPersonRoleId] [int] NULL,
		[PsStudentAcademicRecordId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_PsStudentAcademicRecord] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[PsStudentEnrollment]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[PsStudentEnrollment](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Student_Identifier_State] [nvarchar](100) NULL,
		[InstitutionIpedsUnitId] [nvarchar](100) NULL,
		[FirstName] [varchar](100) NULL,
		[LastName] [varchar](100) NULL,
		[MiddleName] [varchar](100) NULL,
		[Birthdate] [date] NULL,
		[Sex] [varchar](30) NULL,
		[HispanicLatinoEthnicity] [bit] NULL,
		[PostsecondaryExitOrWithdrawalType] [nvarchar](100) NULL,
		[EntryDateIntoPostsecondary] [datetime] NULL,
		[EntryDate] [datetime] NULL,
		[ExitDate] [datetime] NULL,
		[AcademicTermDesignator] [varchar](100) NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[OrganizationId_PsInstitution] [int] NULL,
		[PersonId] [int] NULL,
		[OrganizationPersonRoleId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_PsTermEnrollment] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[SourceSystemReferenceData]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	IF EXISTS(SELECT 1 
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_SCHEMA = 'ODS' and TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME = 'SourceSystemReferenceData' )
	BEGIN

		ALTER SCHEMA Staging TRANSFER [ODS].[SourceSystemReferenceData]

	END

	/****** Object:  Table [Staging].[StateDefinedCustomIndicator]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[StateDefinedCustomIndicator](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Code] [nvarchar](50) NULL,
		[Description] [nvarchar](100) NULL,
		[Definition] [nvarchar](max) NULL,
		[RefIndicatorStatusCustomTypeId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_StateDefinedCustomIndicator] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	/****** Object:  Table [Staging].[StateDetail]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[StateDetail](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[StateCode] [char](2) NULL,
		[SeaName] [varchar](250) NULL,
		[SeaShortName] [varchar](20) NULL,
		[SeaStateIdentifier] [varchar](7) NULL,
		[Sea_WebSiteAddress] [varchar](300) NULL,
		[SeaContact_FirstName] [varchar](100) NULL,
		[SeaContact_LastOrSurname] [varchar](100) NULL,
		[SeaContact_PersonalTitleOrPrefix] [varchar](100) NULL,
		[SeaContact_ElectronicMailAddress] [varchar](100) NULL,
		[SeaContact_PhoneNumber] [varchar](100) NULL,
		[SeaContact_Identifier] [varchar](100) NULL,
		[SeaContact_PositionTitle] [varchar](100) NULL,
		[RecordStartDateTime] [datetime] NULL,
		[RecordEndDateTime] [datetime] NULL,
		[SchoolYear] [varchar](100) NULL,
		[DataCollectionName] [nvarchar](100) NULL,
		[DataCollectionId] [int] NULL,
		[PersonId] [int] NULL,
		[OrganizationId] [int] NULL,
		[RunDateTime] [datetime] NULL,
	 CONSTRAINT [PK_StateDetail] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	/****** Object:  Table [Staging].[ValidationErrors]    Script Date: 12/3/2020 11:58:19 AM ******/
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON

	CREATE TABLE [Staging].[ValidationErrors](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[ProcessName] [varchar](100) NULL,
		[TableName] [varchar](100) NULL,
		[ElementName] [varchar](100) NULL,
		[ErrorSimple] [varchar](500) NULL,
		[ErrorDetail] [varchar](500) NULL,
		[ErrorGroup] [int] NULL,
		[Identifier] [varchar](100) NULL,
		[CreateDate] [datetime] NULL,
	 CONSTRAINT [PK_ValidationErrors] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
	) ON [PRIMARY]

	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefAcademicSubject' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Assessment', @level2type=N'COLUMN',@level2name=N'AssessmentAcademicSubject'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefAssessmentPurpose' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Assessment', @level2type=N'COLUMN',@level2name=N'AssessmentPurpose'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefAssessmentType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Assessment', @level2type=N'COLUMN',@level2name=N'AssessmentType'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefAssessmentTypeChildrenWithDisabilities' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Assessment', @level2type=N'COLUMN',@level2name=N'AssessmentTypeAdministeredToChildrenWithDisabilities'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Assessment', @level2type=N'COLUMN',@level2name=N'AssessmentId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Assessment', @level2type=N'COLUMN',@level2name=N'AssessmentAdministrationId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Assessment', @level2type=N'COLUMN',@level2name=N'AssessmentSubtestId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Assessment', @level2type=N'COLUMN',@level2name=N'AssessmentFormId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Assessment', @level2type=N'COLUMN',@level2name=N'AssessmentPerformanceLevelId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Assessment'
	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefAcademicSubject' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'AssessmentAcademicSubject'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefAssessmentPurpose' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'AssessmentPurpose'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefAssessmentType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'AssessmentType'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefAssessmentTypeChildrenWithDisabilities' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'AssessmentTypeAdministeredToChildrenWithDisabilities'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefGradeLevel' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'GradeLevelWhenAssessed'
	EXEC sys.sp_addextendedproperty @name=N'TableFilter', @value=N'000126' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'GradeLevelWhenAssessed'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefAssessmentReasonNotCompleting' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'AssessmentRegistrationReasonNotCompleting'
	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'AssessmentRegistrationReasonNotCompleting'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'AssessmentRegistrationId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'AssessmentId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'AssessmentAdministrationId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'PersonId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'AssessmentFormId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'AssessmentSubtestId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'AssessmentPerformanceLevelId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'AssessmentResultId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'AssessmentResult_PerformanceLevelId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'OrganizationID_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_School'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'AssessmentResult'
	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefCharterSchoolApprovalAgencyType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'CharterSchoolAuthorizer', @level2type=N'COLUMN',@level2name=N'CharterSchoolAuthorizerType'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'CharterSchoolAuthorizer', @level2type=N'COLUMN',@level2name=N'CharterSchoolAuthorizerOrganizationId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'CharterSchoolAuthorizer'
	--
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'CharterSchoolManagementOrganization', @level2type=N'COLUMN',@level2name=N'CharterSchoolManagementOrganizationId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'CharterSchoolManagementOrganization', @level2type=N'COLUMN',@level2name=N'CharterSchoolId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'CharterSchoolManagementOrganization'
	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefDisciplinaryActionTaken' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Discipline', @level2type=N'COLUMN',@level2name=N'DisciplinaryActionTaken'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefDisciplineReason' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Discipline', @level2type=N'COLUMN',@level2name=N'DisciplineReason'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefIdeaInterimRemoval' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Discipline', @level2type=N'COLUMN',@level2name=N'IdeaInterimRemoval'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefIDEAInterimRemovalReason' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Discipline', @level2type=N'COLUMN',@level2name=N'IdeaInterimRemovalReason'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefDisciplineMethodOfCwd' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Discipline', @level2type=N'COLUMN',@level2name=N'DisciplineMethodOfCwd'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Discipline', @level2type=N'COLUMN',@level2name=N'PersonId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Discipline', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Discipline', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Discipline', @level2type=N'COLUMN',@level2name=N'OrganizationID_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Discipline', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Discipline', @level2type=N'COLUMN',@level2name=N'IncidentId_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Discipline', @level2type=N'COLUMN',@level2name=N'IncidentId_School'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Discipline'
	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefExitOrWithdrawalType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'ExitOrWithdrawalType'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefGradeLevel' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'GradeLevel'
	EXEC sys.sp_addextendedproperty @name=N'TableFilter', @value=N'000100' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'GradeLevel'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefHighSchoolDiplomaType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'HighSchoolDiplomaType'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'PersonId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'OrganizationID_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleRelationshipId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Enrollment'
	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefMepEnrollmentType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Migrant', @level2type=N'COLUMN',@level2name=N'MigrantEducationProgramEnrollmentType'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefMepServiceType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Migrant', @level2type=N'COLUMN',@level2name=N'MigrantEducationProgramServicesType'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefContinuationOfServices' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Migrant', @level2type=N'COLUMN',@level2name=N'ContinuationOfServicesReason'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Migrant', @level2type=N'COLUMN',@level2name=N'PersonID'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Migrant', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Migrant', @level2type=N'COLUMN',@level2name=N'OrganizationID_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Migrant', @level2type=N'COLUMN',@level2name=N'LEAOrganizationPersonRoleID_MigrantProgram'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Migrant', @level2type=N'COLUMN',@level2name=N'LEAOrganizationID_MigrantProgram'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Migrant', @level2type=N'COLUMN',@level2name=N'SchoolOrganizationPersonRoleID_MigrantProgram'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Migrant', @level2type=N'COLUMN',@level2name=N'SchoolOrganizationID_MigrantProgram'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Migrant', @level2type=N'COLUMN',@level2name=N'PersonProgramParticipationId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Migrant', @level2type=N'COLUMN',@level2name=N'ProgramParticipationMigrantId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'Migrant'
	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefOperationalStatus' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'LEA_OperationalStatus'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefLeaType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'LEA_Type'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefOperationalStatus' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_OperationalStatus'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefSchoolType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_Type'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefReconstitutedStatus' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_ReconstitutedStatus'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'OrganizationId_SEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'OrganizationId_IEU'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'OrganizationId_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'OrganizationId_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'K12ProgramOrServiceId_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'K12LeaTitleISupportServiceId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'K12ProgramOrServiceId_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'NewIEU'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'NewLEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'NewSchool'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'IEU_Identifier_State_ChangedIdentifier'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'IEU_Identifier_State_Identifier_Old'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'LEA_Identifier_State_ChangedIdentifier'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'LEA_Identifier_State_Identifier_Old'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_Identifier_State_ChangedIdentifier'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'School_Identifier_State_Identifier_Old'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'OrganizationRelationshipId_SEAToIEU'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'OrganizationRelationshipId_IEUToLEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'OrganizationRelationshipId_SEAToLEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'OrganizationRelationshipId_LEAToSchool'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'OrganizationWebsiteId_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'OrganizationWebsiteId_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'OrganizationOperationalStatusId_IEU'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'OrganizationOperationalStatusId_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization', @level2type=N'COLUMN',@level2name=N'OrganizationOperationalStatusId_School'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12Organization'
	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefSpecialEducationStaffCategory' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'SpecialEducationStaffCategory'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefK12StaffClassification' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'K12StaffClassification'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefTitleIProgramStaffCategory' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'TitleIProgramStaffCategory'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefTitleIProgramStaffCategory' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'CredentialType'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefParaprofessionalQualification' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'ParaprofessionalQualification'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefSpecialEducationAgeGroupTaught' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'SpecialEducationAgeGroupTaught'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'PersonId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'OrganizationId_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'OrganizationId_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleRelationshipId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StaffAssignment'
	--
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationAddress', @level2type=N'COLUMN',@level2name=N'OrganizationId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationAddress', @level2type=N'COLUMN',@level2name=N'LocationId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationAddress'
	--
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationCustomSchoolIndicatorStatusType'
	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefOrganizationType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'OrganizationType'
	EXEC sys.sp_addextendedproperty @name=N'TableFilter', @value=N'001156' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding', @level2type=N'COLUMN',@level2name=N'OrganizationType'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationFederalFunding'
	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefStateANSICode' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationGradeOffered', @level2type=N'COLUMN',@level2name=N'GradeOffered'
	EXEC sys.sp_addextendedproperty @name=N'TableFilter', @value=N'000100' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationGradeOffered', @level2type=N'COLUMN',@level2name=N'GradeOffered'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationGradeOffered', @level2type=N'COLUMN',@level2name=N'OrganizationId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationGradeOffered', @level2type=N'COLUMN',@level2name=N'K12SchoolGradeOfferedId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationGradeOffered'
	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefOrganizationType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationPhone', @level2type=N'COLUMN',@level2name=N'OrganizationType'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefInstitutionTelephoneType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationPhone', @level2type=N'COLUMN',@level2name=N'InstitutionTelephoneNumberType'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationPhone', @level2type=N'COLUMN',@level2name=N'OrganizationId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationPhone', @level2type=N'COLUMN',@level2name=N'OrganizationTelephoneId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationPhone'
	--
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationSchoolComprehensiveAndTargetedSupport'
	--
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'OrganizationSchoolIndicatorStatus'
	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefRace' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonRace', @level2type=N'COLUMN',@level2name=N'RaceType'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonRace', @level2type=N'COLUMN',@level2name=N'PersonDemographicRaceId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonRace'
	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefMilitaryConnectedStudentIndicator' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'MilitaryConnectedStudentIndicator'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefDisabilityType' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'PrimaryDisabilityType'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'PersonId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationID_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA_Program_Foster'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_LEA_Program_Foster'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationID_School_Program_Foster'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_School_Program_Foster'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA_Program_Section504'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_LEA_Program_Section504'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationID_School_Program_Section504'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_School_Program_Section504'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA_Program_Immigrant'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_LEA_Program_Immigrant'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationID_School_Program_Immigrant'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_School_Program_Immigrant'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_LEA_SPED'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_School_SPED'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA_Program_Homeless'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationID_School_Program_Homeless'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_LEA_Program_Homeless'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_School_Program_Homeless'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'PersonStatusId_Homeless'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'PersonHomelessNightTimeResidenceId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'PersonStatusId_EconomicDisadvantage'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'PersonStatusId_IDEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'PersonStatusId_EnglishLearner'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'PersonLanguageId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'PersonStatusId_Migrant'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'PersonMilitaryId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus', @level2type=N'COLUMN',@level2name=N'PersonHomelessnessId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'PersonStatus'
	--
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationCTE', @level2type=N'COLUMN',@level2name=N'PersonID'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationCTE', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationCTE', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationCTE', @level2type=N'COLUMN',@level2name=N'OrganizationID_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationCTE', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationCTE', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_CTEProgram_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationCTE', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_CTEProgram_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationCTE', @level2type=N'COLUMN',@level2name=N'OrganizationID_CTEProgram_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationCTE', @level2type=N'COLUMN',@level2name=N'OrganizationID_CTEProgram_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationCTE', @level2type=N'COLUMN',@level2name=N'PersonProgramParticipationId_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationCTE', @level2type=N'COLUMN',@level2name=N'PersonProgramParticipationId_School'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationCTE'
	--
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'PersonID'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'OrganizationID_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'OrganizationID_Program_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'OrganizationID_Program_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_Program_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_Program_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'PersonProgramParticipationID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD', @level2type=N'COLUMN',@level2name=N'PersonProgramParticipationID_School'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationNorD'
	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefSpecialEducationExitReason' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'SpecialEducationExitReason'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefIDEAEducationalEnvironmentEC' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'IDEAEducationalEnvironmentForEarlyChildhood'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefIDEAEducationalEnvironmentSchoolAge' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'IDEAEducationalEnvironmentForSchoolAge'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'PersonID'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'OrganizationID_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'OrganizationID_Program_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'OrganizationID_Program_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_Program_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_Program_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'PersonProgramParticipationID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation', @level2type=N'COLUMN',@level2name=N'PersonProgramParticipationID_School'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationSpecialEducation'
	--
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefTitleIIndicator' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'TitleIIndicator'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'PersonID'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'OrganizationID_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_TitleIProgram_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'OrganizationID_TitleIProgram_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'PersonProgramParticipationId_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_TitleIProgram_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'OrganizationID_TitleIProgram_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'PersonProgramParticipationId_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI', @level2type=N'COLUMN',@level2name=N'RefTitleIIndicatorId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleI'
	--
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'PersonID'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'OrganizationID_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_TitleIIIProgram_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleID_TitleIIIProgram_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'OrganizationID_TitleIIIProgram_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'OrganizationID_TitleIIIProgram_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'PersonProgramParticipationId_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'PersonProgramParticipationId_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII', @level2type=N'COLUMN',@level2name=N'PersonStatusId_Immigration'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'ProgramParticipationTitleIII'
	--
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'StateDefinedCustomIndicator'
	--
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'StateDetail', @level2type=N'COLUMN',@level2name=N'OrganizationId'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefState' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'StateDetail', @level2type=N'COLUMN',@level2name=N'StateCode'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefStateANSICode' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'StateDetail', @level2type=N'COLUMN',@level2name=N'SeaStateIdentifier'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'StateDetail', @level2type=N'COLUMN',@level2name=N'PersonId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'StateDetail'
	--
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'PersonId'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'OrganizationID_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_LEA'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'OrganizationID_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_School'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'OrganizationID_Course'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'OrganizationID_CourseSection'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection', @level2type=N'COLUMN',@level2name=N'OrganizationPersonRoleId_CourseSection'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12StudentCourseSection'


	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'SchoolYear'
	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'LEA_Identifier_State'
	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'School_Identifier_State'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefComprehensiveSupport' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'ComprehensiveSupport'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefComprehensiveSupportReasonApplicability' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'ComprehensiveSupportReasonApplicability'
	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'ComprehensiveSupportReasonApplicability'
	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'OrganizationId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType'

	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'SchoolYear'
	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'LEA_Identifier_State'
	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'School_Identifier_State'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefSubgroup' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'Subgroup'
	EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefComprehensiveSupportReasonApplicability' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'ComprehensiveSupportReasonApplicability'
	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'ComprehensiveSupportReasonApplicability'
	EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'
	EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'OrganizationId'
	EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'SchoolYear'))
		EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'SchoolYear'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'LEA_Identifier_State'))
		EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'LEA_Identifier_State'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'School_Identifier_State'))
		EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'School_Identifier_State'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Lookup' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'ComprehensiveSupport'))
		EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefComprehensiveSupport' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'ComprehensiveSupport'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Lookup' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'ComprehensiveSupportReasonApplicability'))
		EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefComprehensiveSupportReasonApplicability' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'ComprehensiveSupportReasonApplicability'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'ComprehensiveSupportReasonApplicability'))
		EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'ComprehensiveSupportReasonApplicability'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'RecordStartDateTime'))
		EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Identifier' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', N'COLUMN',N'OrganizationId'))
		EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'OrganizationId'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'TableType' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolComprehensiveSupportIdentificationType', NULL,NULL))
		EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolComprehensiveSupportIdentificationType'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolTargetedSupportIdentificationType', N'COLUMN',N'SchoolYear'))
		EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'SchoolYear'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolTargetedSupportIdentificationType', N'COLUMN',N'LEA_Identifier_State'))
		EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'LEA_Identifier_State'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolTargetedSupportIdentificationType', N'COLUMN',N'School_Identifier_State'))
		EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'School_Identifier_State'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Lookup' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolTargetedSupportIdentificationType', N'COLUMN',N'Subgroup'))
		EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefSubgroup' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'Subgroup'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Lookup' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolTargetedSupportIdentificationType', N'COLUMN',N'ComprehensiveSupportReasonApplicability'))
		EXEC sys.sp_addextendedproperty @name=N'Lookup', @value=N'RefComprehensiveSupportReasonApplicability' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'ComprehensiveSupportReasonApplicability'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolTargetedSupportIdentificationType', N'COLUMN',N'ComprehensiveSupportReasonApplicability'))
		EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'ComprehensiveSupportReasonApplicability'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Required' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolTargetedSupportIdentificationType', N'COLUMN',N'RecordStartDateTime'))
		EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'RecordStartDateTime'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Identifier' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolTargetedSupportIdentificationType', N'COLUMN',N'OrganizationId'))
		EXEC sys.sp_addextendedproperty @name=N'Identifier', @value=N'IDS' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType', @level2type=N'COLUMN',@level2name=N'OrganizationId'


	IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'TableType' , N'SCHEMA',N'Staging', N'TABLE',N'K12SchoolTargetedSupportIdentificationType', NULL,NULL))
		EXEC sys.sp_addextendedproperty @name=N'TableType', @value=N'Migration' , @level0type=N'SCHEMA',@level0name=N'Staging', @level1type=N'TABLE',@level1name=N'K12SchoolTargetedSupportIdentificationType'
	END

		IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'PersonStatus' and i.name = 'IX_PersonStatus_IDEAIndicator') 
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_PersonStatus_IDEAIndicator]
				ON [Staging].[PersonStatus]([IDEAIndicator] ASC)
				INCLUDE([IDEA_StatusStartDate], [IDEA_StatusEndDate], [PersonId], [OrganizationID_School]);
		END
		
		IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'ProgramParticipationSpecialEducation' and i.name = 'IX_ProgramParticipationSpecialEducation_PersonId_LeaOrganizationID_Program') 
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_ProgramParticipationSpecialEducation_PersonId_OrganizationID_Program_LEA]
				ON [Staging].[ProgramParticipationSpecialEducation]([PersonID] ASC, [OrganizationID_Program_LEA] ASC)
				INCLUDE([ProgramParticipationBeginDate], [ProgramParticipationEndDate]);
		END

		IF NOT EXISTS (SELECT * FROM sys.indexes i JOIN sys.objects o ON i.object_id = o.object_id WHERE o.name = 'ProgramParticipationSpecialEducation' and i.name = 'IX_ProgramParticipationSpecialEducation_PersonId_SchoolOrganizationID_Program') 
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_ProgramParticipationSpecialEducation_PersonId_OrganizationID_Program_School]
				ON [Staging].[ProgramParticipationSpecialEducation]([PersonID] ASC, [OrganizationID_Program_School] ASC)
				INCLUDE([ProgramParticipationBeginDate], [ProgramParticipationEndDate]);
		END

		IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_K12ProgramParticipation_OrganizationType_ProgramType') 
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_K12ProgramParticipation_OrganizationType_ProgramType]
			ON [Staging].[K12ProgramParticipation] ([OrganizationType],[ProgramType])
			INCLUDE ([OrganizationIdentifier],[SchoolYear]) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
		END

		IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_K12ProgramParticipation_ProgramType') 
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_K12ProgramParticipation_ProgramType]
			ON [Staging].[K12ProgramParticipation] ([ProgramType])
			INCLUDE ([SchoolYear],[OrganizationId],[DataCollectionId]) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
		END

		IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_K12ProgramParticipation_Student_Identifier_State')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_K12ProgramParticipation_Student_Identifier_State]
			ON [Staging].[K12ProgramParticipation] ([Student_Identifier_State]) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
		END

		IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_K12ProgramParticipation_EntryDate_PersonId_ProgramOrganizationId_DataCollectionId')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_K12ProgramParticipation_EntryDate_PersonId_ProgramOrganizationId_DataCollectionId]
			ON [Staging].[K12ProgramParticipation] ([EntryDate],[PersonId],[ProgramOrganizationId],[DataCollectionId]) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
		END

		IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_K12ProgramParticipation_DataCollectionName')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_K12ProgramParticipation_DataCollectionName]
			ON [Staging].[K12ProgramParticipation] ([DataCollectionName]) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE)
		END

		IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_PersonStatus_LEA_Identifier_State_PersonId')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_PersonStatus_LEA_Identifier_State_PersonId]
			ON [Staging].[PersonStatus] ([LEA_Identifier_State],[PersonId])
		END

		IF NOT EXISTS(SELECT 1 FROM sys.indexes WHERE name='IX_PersonStatus_School_Identifier_State_PersonId')
		BEGIN
			CREATE NONCLUSTERED INDEX [IX_PersonStatus_School_Identifier_State_PersonId]
			ON [Staging].[PersonStatus] ([School_Identifier_State],[PersonId])
		END
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