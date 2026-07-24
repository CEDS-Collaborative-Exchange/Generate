# Staging columns needing guidance (141)

| Table | Column | Type | Top suggestion | Alt 1 | Alt 2 |
|---|---|---|---|---|---|
| PsInstitution | MostPrevalentLevelOfInstitutionCode | nvarchar | Level of Institution (000178) · 0.90 | Most Prevalent Level of Institution (002025) · 0.85 | School Type (000242) · 0.78 |
| K12Organization | LEA_K12LeaTitleISupportService | varchar | Title I Support Services (000289) · 0.90 | Has Local Education Agency Title I Support Service (600253) · 0.86 | Local Education Agency Title I Support Service (200196) · 0.86 |
| K12StudentCourseSection | DataCollectionId | int | Source System Data Collection Identifier (001964) · 0.89 | Data Collection Description (001967) · 0.86 | Data Collection Status (001990) · 0.84 |
| OrganizationSchoolIndicatorStatus | DataCollectionId | int | Source System Data Collection Identifier (001964) · 0.89 | Data Collection Description (001967) · 0.86 | Data Collection Status (001990) · 0.84 |
| EarlyLearningOrganization | OrganizationOperationalStatusId | int | Organization Operational Status (001418) · 0.89 | School Operational Status (000533) · 0.86 | Local Education Agency Operational Status (000174) · 0.85 |
| K12StaffAssignment | SpecialEducationStaffCategory | nvarchar | Special Education Related Services Personnel (000262) · 0.89 | K12 Staff Classification (000087) · 0.88 | Special Education Teacher (000264) · 0.84 |
| OrganizationGradeOffered | GradeOffered | varchar | Has Grades Offered (000131) · 0.89 | Course Academic Grade (000053) · 0.76 | Has Course Academic Grade Status Code (001299) · 0.72 |
| EducationOrganizationNetwork | EducationOrganizationNetworkTypeCode | nvarchar | Education Organization Network (200389) · 0.89 | Organization Type (001156) · 0.72 | Organization Identifier Type (200416) · 0.65 |
| PersonStatus | HomelessNightTimeResidence_StartDate | date | Homeless Primary Nighttime Residence (000146) · 0.89 | Status Start Date (001227) · 0.83 | Homelessness Status (000149) · 0.78 |
| FipsCounty | State | varchar | State Abbreviation (000267) · 0.88 | State Poverty Designation (000585) · 0.62 | State ANSI Code (000424) · 0.62 |
| PersonStatus | Section504_ProgramParticipationEndDate | date | Program Participation Exit Date (000591) · 0.88 | Workforce Program Participation End Date (000999) · 0.88 | Program Participation Start Date (000590) · 0.85 |
| ProgramParticipationCTE | DisplacedHomeMakerIndicator | bit | Career-Technical-Adult Education Displaced Homemaker Indicator (000084) · 0.88 | Status End Date (001228) · 0.83 | Status Start Date (001227) · 0.82 |
| EducationOrganizationNetwork | EducationOrganizationNetworkTypeDescription | nvarchar | Education Organization Network (200389) · 0.88 | Organization Type (001156) · 0.72 | Local Education Agency Type (000537) · 0.63 |
| PersonStatus | FosterCare_ProgramParticipationEndDate | date | Program Participation Exit Date (000591) · 0.88 | Workforce Program Participation End Date (000999) · 0.87 | Program Participation Start Date (000590) · 0.84 |
| ProgramParticipationTitleIII | Proficiency_TitleIII | varchar | Proficiency Status (000573) · 0.88 | Has Title III English Learner Participation Status (000565) · 0.75 | Has Proficiency Target Status for Math (000221) · 0.73 |
| IdeaDisabilityType | IsSecondaryDisability | bit | Primary Disability Type (000218) · 0.87 | Disability Status (000577) · 0.79 | Person Disability (200285) · 0.79 |
| PersonStatus | HomelessNightTimeResidence_EndDate | date | Status End Date (001228) · 0.87 | Homeless Primary Nighttime Residence (000146) · 0.85 | Homelessness Status (000149) · 0.77 |
| K12StudentAddress | CountryDescription | nvarchar | Country Code (000050) · 0.87 | Has Military Country (002034) · 0.68 | Region (200394) · 0.66 |
| K12Organization | School_IsReportedFederally | bit | Has Local Education Agency Federal Reporting (600241) · 0.87 | Local Education Agency Federal Reporting (200190) · 0.86 | Federal School Code (000111) · 0.82 |
| OrganizationCalendarSession | BeginDate | datetime | Session Begin Date (000251) · 0.86 | Status Start Date (001227) · 0.86 | Competency Framework Valid Start Date (000700) · 0.86 |
| K12StudentCourseSection | OrganizationID_Course | int | Course Code System (000056) · 0.85 | Course Identifier (000055) · 0.84 | Course Number (001314) · 0.82 |
| K12StudentCourseSection | OrganizationPersonRoleId_School | int | K12 Staff Classification (000087) · 0.85 | Has Job Position Identification (600185) · 0.83 | Job Position Identification (200182) · 0.82 |
| K12Enrollment | FoodServiceEligibility | nvarchar | Eligibility Status for School Food Service Programs (000092) · 0.85 | Program Participation Food Service (200319) · 0.85 | Has Program Participation Food Service (600192) · 0.81 |
| K12StudentCourseSection | OrganizationID_LEA | int | Has Organization Identifier (600502) · 0.85 | Organization Identifier (000826) · 0.85 | Has Organization Identifier Type (600567) · 0.82 |
| ProgramParticipationTitleIII | EnglishLearnerParticipation | bit | English Learner Status (000180) · 0.85 | Title III English Learner Participation Status (000565) · 0.84 | Program Participation Title III English Learner (200325) · 0.83 |
| StateDetail | SeaContact_Identifier | nvarchar | Local Education Agency Identifier (001068) · 0.85 | Organization Identifier (000826) · 0.82 | State Agency Identifier (001490) · 0.81 |
| K12Enrollment | LanguageNative | nvarchar | Person Language (200293) · 0.84 | Has Person Language (600052) · 0.83 | Has Language Type (000316) · 0.80 |
| K12StudentAddress | CountyAnsiDescription | nvarchar | County ANSI Code (001209) · 0.84 | Responsible District Type (000594) · 0.65 | Address County Name (000190) · 0.62 |
| K12Organization | School_IndicatorStatusType | varchar | School Type (000242) · 0.84 | Title I School Status (000285) · 0.83 | K12 School Status (200203) · 0.83 |
| ProgramParticipationCTE | SingleParentIndicator | bit | Single Parent or Single Pregnant Woman Status (000580) · 0.83 | Has Teen Parent Indicator (002062) · 0.82 | Has Custodial Parent or Guardian Indicator (000329) · 0.81 |
| OrganizationCalendarSession | CalendarYear | nvarchar | School Year (000243) · 0.82 | Calendar Event Date (001275) · 0.77 | Fiscal Year (001639) · 0.77 |
| Discipline | DisciplineActionIdentifier | nvarchar | Disciplinary Action Taken (000488) · 0.81 | Has Corrective Action Type (000049) · 0.78 | Learner Action (200225) · 0.76 |
| K12Organization | LEA_IsReportedFederally | bit | Has Local Education Agency Federal Reporting (600241) · 0.81 | Local Education Agency Federal Reporting (200190) · 0.79 | Gun Free Schools Act Reporting Status (000134) · 0.71 |
| K12SchoolComprehensiveSupportIdentificationType | ComprehensiveSupportReasonApplicability | varchar | Discipline Reason (000545) · 0.81 | Has Program Entry Reason (001922) · 0.76 | Special Education Exit Reason (000260) · 0.75 |
| K12StudentAddress | LocationId | nvarchar | School Identifier (001069) · 0.80 | Responsible School Identifier (000638) · 0.80 | School Identification System (001073) · 0.79 |
| OrganizationCustomSchoolIndicatorStatusType | IndicatorStatus | varchar | Elementary-Middle Additional Indicator Status (000091) · 0.80 | English Learner Status (000180) · 0.74 | Has Exit or Withdrawal Status (000108) · 0.73 |
| OrganizationSchoolIndicatorStatus | IndicatorStatus | varchar | Elementary-Middle Additional Indicator Status (000091) · 0.80 | English Learner Status (000180) · 0.74 | Has Exit or Withdrawal Status (000108) · 0.73 |
| K12StudentAddress | RefStateId | int | State Abbreviation (000267) · 0.79 | State ANSI Code (000424) · 0.76 | Has State Agency Identification System (001491) · 0.72 |
| IndicatorStatusCustomType | Definition | nvarchar | Competency Definition (200065) · 0.79 | Competency Definition URL (000874) · 0.78 | Competency Definition Notes (001249) · 0.76 |
| StateDefinedCustomIndicator | Definition | nvarchar | Competency Definition (200065) · 0.79 | Competency Definition URL (000874) · 0.78 | Competency Definition Notes (001249) · 0.76 |
| K12StudentCourseSection | OrganizationPersonRoleId_LEA | int | Job Position Identification (200182) · 0.79 | K12 Staff Assignment (200207) · 0.79 | Has Job Position Identification (600185) · 0.78 |
| StateDetail | SeaContact_PhoneNumber | nvarchar | Web Site Address (000704) · 0.79 | Electronic Mail Address (000088) · 0.78 | Organization Identifier (000826) · 0.75 |
| OrganizationCustomSchoolIndicatorStatusType | IndicatorStatusType | varchar | Elementary-Middle Additional Indicator Status (000091) · 0.78 | English Learner Status (000180) · 0.73 | IDEA Indicator (000151) · 0.72 |
| OrganizationSchoolIndicatorStatus | IndicatorStatusType | varchar | Elementary-Middle Additional Indicator Status (000091) · 0.78 | English Learner Status (000180) · 0.73 | IDEA Indicator (000151) · 0.72 |
| K12Organization | School_TargetedSupport | varchar | Targeted Support and Improvement Status (001924) · 0.78 | Additional Targeted Support and Improvement Status (001925) · 0.75 | Responsible School Type (000595) · 0.72 |
| OrganizationSchoolComprehensiveAndTargetedSupport | School_TargetedSupport | varchar | Targeted Support and Improvement Status (001924) · 0.78 | Additional Targeted Support and Improvement Status (001925) · 0.75 | Responsible School Type (000595) · 0.72 |
| OrganizationCustomSchoolIndicatorStatusType | StatedDefinedIndicatorStatus | varchar | Elementary-Middle Additional Indicator Status (000091) · 0.78 | English Learner Status (000180) · 0.74 | IDEA Indicator (000151) · 0.74 |
| OrganizationSchoolIndicatorStatus | StatedDefinedIndicatorStatus | varchar | Elementary-Middle Additional Indicator Status (000091) · 0.78 | English Learner Status (000180) · 0.74 | IDEA Indicator (000151) · 0.74 |
| SchoolPerformanceIndicators | SchoolPerformanceIndicatorType | varchar | Assessment Performance Level Score Metric (000417) · 0.78 | School Quality or Student Success Indicator Type (002140) · 0.78 | Assessment Performance Level Label (000718) · 0.76 |
| K12Organization | LEA_TitleIinstructionalService | varchar | Title I Instructional Services (000282) · 0.78 | Title I Support Services (000289) · 0.77 | Local Education Agency Title I Support Service (200196) · 0.75 |
| SchoolPerformanceIndicatorStateDefinedStatus | SchoolPerformanceIndicatorStateDefinedStatusDescription | nvarchar | School Quality or Student Success Indicator Type (002140) · 0.77 | Progress Achieving English Language Proficiency State Defined Status (001916) · 0.76 | Progress Achieving English Language Proficiency Indicator Type (001915) · 0.73 |
| K12StudentCourseSection | OrganizationPersonRoleId_CourseSection | int | Has Professional Development Session Instructor (600119) · 0.77 | K12 Staff Classification (000087) · 0.75 | Course Certification Description (001302) · 0.74 |
| K12Organization | School_ComprehensiveAndTargetedSupport | varchar | Targeted Support and Improvement Status (001924) · 0.77 | Additional Targeted Support and Improvement Status (001925) · 0.75 | Responsible School Type (000595) · 0.71 |
| OrganizationSchoolComprehensiveAndTargetedSupport | School_ComprehensiveAndTargetedSupport | varchar | Targeted Support and Improvement Status (001924) · 0.77 | Additional Targeted Support and Improvement Status (001925) · 0.75 | Responsible School Type (000595) · 0.71 |
| K12SchoolComprehensiveSupportIdentificationType | ComprehensiveSupport | varchar | Comprehensive Support and Improvement Status (001923) · 0.76 | Has Comprehensive Support and Improvement Identification Type (002182) · 0.75 | Student Support Service Type (000273) · 0.73 |
| SchoolPerformanceIndicators | SchoolPerformanceIndicatorStateDefinedStatus | varchar | School Quality or Student Success Indicator Type (002140) · 0.76 | Progress Achieving English Language Proficiency State Defined Status (001916) · 0.76 | Progress Achieving English Language Proficiency Indicator Type (001915) · 0.73 |
| K12Organization | School_SchoolDangerousStatus | varchar | Persistently Dangerous Status (000210) · 0.76 | Has Facility Hazard (600018) · 0.73 | Facility Hazard (200131) · 0.72 |
| K12Organization | School_ComprehensiveSupport | varchar | Has K12 Program Or Service (600257) · 0.76 | Student Support Service Type (000273) · 0.74 | Responsible School Type (000595) · 0.73 |
| OrganizationSchoolComprehensiveAndTargetedSupport | School_ComprehensiveSupport | varchar | Has K12 Program Or Service (600257) · 0.76 | Student Support Service Type (000273) · 0.74 | Responsible School Type (000595) · 0.73 |
| SchoolPerformanceIndicatorStateDefinedStatus | SchoolPerformanceIndicatorStateDefinedStatusDefinition | nvarchar | School Quality or Student Success Indicator Type (002140) · 0.76 | Progress Achieving English Language Proficiency State Defined Status (001916) · 0.75 | Progress Achieving English Language Proficiency Indicator Type (001915) · 0.72 |
| IndicatorStatusCustomType | Code | nvarchar | ISO 639-2 Language Code (000317) · 0.76 | ISO 639-3 Language Code (001637) · 0.76 | Country Code (000050) · 0.75 |
| StateDefinedCustomIndicator | Code | nvarchar | ISO 639-2 Language Code (000317) · 0.76 | ISO 639-3 Language Code (001637) · 0.76 | Country Code (000050) · 0.75 |
| SchoolPerformanceIndicators | SchoolPerformanceIndicatorCategory | varchar | School Quality or Student Success Indicator Type (002140) · 0.76 | Assessment Performance Level Label (000718) · 0.72 | Assessment Performance Level Score Metric (000417) · 0.71 |
| PsInstitution | Website | varchar | Organization Website (200273) · 0.76 | Web Site Address (000704) · 0.70 | Has Organization Website (600518) · 0.62 |
| SchoolPerformanceIndicatorStateDefinedStatus | RefSchoolPerformanceIndicatorStateDefinedStatusId | int | School Quality or Student Success Indicator Type (002140) · 0.75 | Progress Achieving English Language Proficiency State Defined Status (001916) · 0.74 | Assessment Performance Level Label (000718) · 0.71 |
| K12Organization | LEA_CharterLeaStatus | varchar | Charter School Indicator (000039) · 0.75 | Local Education Agency Operational Status (000174) · 0.66 | Local Education Agency Type (000537) · 0.64 |
| Assessment | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| AssessmentResult | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| CharterSchoolAuthorizer | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| CharterSchoolManagementOrganization | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| Disability | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| Discipline | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| DisciplineReason | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| EducationOrganizationNetwork | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| FollowUp | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| IncidentBehavior | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| K12Enrollment | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| K12Organization | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| K12PersonRace | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| K12SchoolComprehensiveSupportIdentificationType | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| K12StaffAssignment | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| K12StudentAddress | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| K12StudentCourseSection | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| Migrant | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| Military | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| OrganizationAddress | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| OrganizationFederalFunding | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| OrganizationGradeOffered | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| OrganizationPhone | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| PersonStatus | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| ProgramParticipationCTE | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| ProgramParticipationSpecialEducation | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| ProgramParticipationTitleI | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| ProgramParticipationTitleIII | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| PsPersonRace | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| SchoolPerformanceIndicatorStateDefinedStatus | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| SchoolQualityOrStudentSuccessIndicatorType | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| StateDefinedCustomIndicator | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| StateDetail | RunDateTime | datetime | Start Time (001919) · 0.75 | Record Start Date Time (001917) · 0.74 | Activity Time Involved (001527) · 0.73 |
| K12Enrollment | HispanicLatinoEthnicity | bit | Race (001943) · 0.75 | Has Person Demographic Race (600035) · 0.67 | Person Demographic Race (200282) · 0.66 |
| PsStudentEnrollment | HispanicLatinoEthnicity | bit | Race (001943) · 0.75 | Has Person Demographic Race (600035) · 0.67 | Person Demographic Race (200282) · 0.66 |
| StagingValidationRules | Condition | varchar | Disability Condition Type (001320) · 0.75 | Has Disability Condition Status Type (001319) · 0.73 | English Learner Status (000180) · 0.64 |
| StagingValidationRules_ReportsXREF | CreatedDateTime | datetime | Learning Resource Date Created (000916) · 0.74 | Learner Activity Creation Date (000943) · 0.64 | Created By Person (201000) · 0.64 |
| SchoolPerformanceIndicatorStateDefinedStatus | SchoolPerformanceIndicatorStateDefinedStatusCode | nvarchar | Progress Achieving English Language Proficiency State Defined Status (001916) · 0.74 | School Quality or Student Success Indicator Type (002140) · 0.73 | Assessment Performance Level Label (000718) · 0.72 |
| K12Enrollment | LanguageHome | nvarchar | Language Type (000316) · 0.74 | ISO 639-2 Language Code (000317) · 0.74 | ISO 639-3 Language Code (001637) · 0.72 |
| K12Organization | School_CharterSchoolFEIN_Update | varchar | Charter School Open Enrollment Indicator (001548) · 0.74 | Charter School Indicator (000039) · 0.73 | Charter School Authorizer Type (001292) · 0.69 |
| IndicatorStatusCustomType | Description | nvarchar | Rubric Description (001479) · 0.73 | Entry Type (000099) · 0.73 | Incident Description (000508) · 0.72 |
| StateDefinedCustomIndicator | Description | nvarchar | Rubric Description (001479) · 0.73 | Entry Type (000099) · 0.73 | Incident Description (000508) · 0.72 |
| OrganizationCustomSchoolIndicatorStatusType | StatedDefinedCustomIndicatorStatusType | varchar | Elementary-Middle Additional Indicator Status (000091) · 0.73 | IDEA Indicator (000151) · 0.67 | Virtual Indicator (001160) · 0.66 |
| StagingValidationRules_ReportsXREF | GenerateReportId | int | Accountability Report Title (000005) · 0.73 | Reporter Identifier (000507) · 0.69 | Has Course Section Assessment Reporting Method (000027) · 0.68 |
| SchoolPerformanceIndicators | SubgroupElementName | varchar | Early Learning Class Group Name (000821) · 0.72 | Person Name (200377) · 0.67 | Union Membership Name (001497) · 0.66 |
| ProgramParticipationCTE | PlacementType | varchar | Perkins Post-Program Placement Indicator (002087) · 0.72 | IDEA Placement Rationale (001704) · 0.67 | Disciplinary Action IEP Placement Meeting Indicator (001322) · 0.66 |
| K12Organization | LEA_MepProjectType | varchar | Project-Based Learning Type (001992) · 0.71 | Migrant Education Program Project Type (000463) · 0.67 | Organization Project Based Learning (200264) · 0.67 |
| K12Organization | NewSchool | bit | School Type (000242) · 0.71 | School Identifier (001069) · 0.71 | School Identification System (001073) · 0.70 |
| OrganizationCustomSchoolIndicatorStatusType | IndicatorStatusSubgroup | varchar | Elementary-Middle Additional Indicator Status (000091) · 0.70 | English Learner Status (000180) · 0.70 | Participation Status for Reading and Language Arts (000209) · 0.66 |
| OrganizationSchoolIndicatorStatus | IndicatorStatusSubgroup | varchar | Elementary-Middle Additional Indicator Status (000091) · 0.70 | English Learner Status (000180) · 0.70 | Participation Status for Reading and Language Arts (000209) · 0.66 |
| AccessibleEducationMaterialProvider | OutOfStateIndicator | bit | State Abbreviation (000267) · 0.70 | State ANSI Code (000424) · 0.68 | Has Organization Indicator (600504) · 0.66 |
| OrganizationCustomSchoolIndicatorStatusType | IndicatorStatusSubgroupType | varchar | Elementary-Middle Additional Indicator Status (000091) · 0.69 | English Learner Status (000180) · 0.66 | Exit or Withdrawal Type (000110) · 0.63 |
| OrganizationSchoolIndicatorStatus | IndicatorStatusSubgroupType | varchar | Elementary-Middle Additional Indicator Status (000091) · 0.69 | English Learner Status (000180) · 0.66 | Exit or Withdrawal Type (000110) · 0.63 |
| Discipline | DisciplineMethodOfCwd | nvarchar | Discipline Method for Firearms Incidents (000555) · 0.69 | Discipline Method of Children with Disabilities (000538) · 0.68 | K12 Student Discipline (200215) · 0.65 |
| Migrant | RecordId | varchar | Has Record Reference Identification System (002030) · 0.68 | Record Status (200411) · 0.66 | Assessment Item Identifier (000630) · 0.66 |
| ProgramParticipationCTE | RecordId | varchar | Has Record Reference Identification System (002030) · 0.68 | Record Status (200411) · 0.66 | Assessment Item Identifier (000630) · 0.66 |
| OrganizationFederalFunding | ParentalInvolvementReservationFunds | numeric | Program Provides Parent Involvement Opportunity (000855) · 0.68 | Program Provides Parent Education (000856) · 0.62 | — |
| K12Organization | LEA_McKinneyVentoSubgrantRecipient | bit | Title IV Participant and Recipient (000292) · 0.68 | Has Program Participation Migrant (600193) · 0.67 | Program Participation Migrant (200320) · 0.67 |
| SchoolPerformanceIndicators | SubgroupCode | varchar | Early Learning Class Group Identifier (000820) · 0.67 | Carnegie Basic Classification (000038) · 0.60 | Course Code System (000056) · 0.60 |
| StagingValidationRules | Severity | varchar | Persistently Dangerous Status (000210) · 0.66 | Discipline Method of Children with Disabilities (000538) · 0.65 | Has Full Year Expulsion (000513) · 0.63 |
| StagingValidationRules | StagingValidationRuleId | int | Assessment Subtest Rules (000719) · 0.65 | Procedural Safeguards Notice Indicator (002121) · 0.61 | Credential Definition Validation Method Description (001752) · 0.59 |
| StagingValidationRules_ReportsXREF | StagingValidationRuleId | int | Assessment Subtest Rules (000719) · 0.65 | Procedural Safeguards Notice Indicator (002121) · 0.61 | Credential Definition Validation Method Description (001752) · 0.59 |
| StagingValidationRules | ValidationMessage | varchar | Has Education Verification Method (001607) · 0.65 | Personal Information Verification (000618) · 0.62 | Early Learning Enrollment Application Verification Reason Type (001600) · 0.61 |
| AccessibleEducationMaterialProvider | AccessibleEducationMaterialProviderName | nvarchar | Authentication Identity Provider Name (001168) · 0.65 | Credential Award Issuer Name (000898) · 0.64 | Building Architectural Firm Name (001835) · 0.64 |
| FipsCounty | CountyFipsCode | varchar | County ANSI Code (001209) · 0.64 | Responsible School Type (000595) · 0.57 | — |
| StateDefinedCustomIndicator | RefIndicatorStatusCustomTypeId | int | Record Reference Identifier (002029) · 0.62 | Record Reference Identification System (002030) · 0.62 | IDEA Indicator (000151) · 0.61 |
| StagingValidationRules | CreateDateTime | datetime | Course Add Date (001300) · 0.61 | Session Start Time (000985) · 0.59 | School Year Minutes (000244) · 0.59 |
| K12Organization | NewIEU | bit | Organization Name (000204) · 0.58 | — | — |
| FollowUp | FollowUp | nvarchar | English Learner Status (000180) · 0.57 | Perkins English Learner Status (000581) · 0.56 | Role (001946) · 0.56 |
| StagingValidationRules | StagingColumnId | int | Course Level Characteristic (000061) · 0.57 | Assessment Item Identifier (000630) · 0.56 | Has Identification System for Assessment Form Section (001190) · 0.56 |
| K12Organization | NewLEA | bit | Local Education Agency Identifier (001068) · 0.56 | — | — |
| StagingValidationRules | RuleDscr | varchar | Assessment Subtest Rules (000719) · 0.55 | — | — |
| FipsCounty | StateFipsCode | varchar | — | — | — |
| StagingValidationRules | StagingTableId | int | — | — | — |
| StagingValidationRules_ReportsXREF | Enabled | bit | — | — | — |
