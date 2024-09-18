set nocount on

begin try
	CREATE NONCLUSTERED INDEX [IX_K12StudentAcademicRecord_OrganizationPersonRoleId_WithIncludes]
	ON [dbo].[K12StudentAcademicRecord] ([OrganizationPersonRoleId])
	INCLUDE ([DiplomaOrCredentialAwardDate],[RefHighSchoolDiplomaTypeId])

	CREATE NONCLUSTERED INDEX [IX_PersonMilitary_PersonId_WithIncludes]
	ON [dbo].[PersonMilitary] ([PersonId])
	INCLUDE ([RefMilitaryConnectedStudentIndicatorId])

	CREATE NONCLUSTERED INDEX [IX_DimCteStatuses_AllCodes]
	ON [RDS].[DimCteStatuses] ([CteProgramCode],[CteAeDisplacedHomemakerIndicatorCode],[CteNontraditionalGenderStatusCode],[RepresentationStatusCode],[SingleParentOrSinglePregnantWomanCode],[CteGraduationRateInclusionCode],[LepPerkinsStatusCode])

	CREATE NONCLUSTERED INDEX [IX_K12SchoolStatus_K12SchoolId_WithIncludes]
	ON [dbo].[K12SchoolStatus] ([K12SchoolId])
	INCLUDE ([RefTitleISchoolStatusId],[DataCollectionId])

	CREATE NONCLUSTERED INDEX [IX_K12School_OrganizationId_WithIncludes]
	ON [dbo].[K12School] ([OrganizationId])
	INCLUDE ([K12SchoolId],[DataCollectionId])

	CREATE NONCLUSTERED INDEX [IX_AssessmentResult_PerformanceLevel_AssessmentResultId_WithIncludes]
	ON [dbo].[AssessmentResult_PerformanceLevel] ([AssessmentResultId])
	INCLUDE ([AssessmentPerformanceLevelId],[DataCollectionId])

	CREATE NONCLUSTERED INDEX [IX_ProgramParticipationSpecialEducation_PersonProgramParticipationId_WithIncludes]
	ON [dbo].[ProgramParticipationSpecialEducation] ([PersonProgramParticipationId])
	INCLUDE ([SpecialEducationServicesExitDate],[RefIDEAEducationalEnvironmentECId],[RefIDEAEducationalEnvironmentSchoolAgeId],[RefSpecialEducationExitReasonId],[RecordStartDateTime],[RecordEndDateTime])

	CREATE NONCLUSTERED INDEX [IX_AssessmentResult_AssessmentRegistrationId_WithIncludes]
	ON [dbo].[AssessmentResult] ([AssessmentRegistrationId])
	INCLUDE ([DataCollectionId])

	CREATE NONCLUSTERED INDEX [IX_OrganizationRelationship_ParentOrganizationId_WithIncludes]
	ON [dbo].[OrganizationRelationship] ([Parent_OrganizationId])
	INCLUDE ([OrganizationId],[DataCollectionId])

	CREATE NONCLUSTERED INDEX [IX_PersonDisability_PersonId_RecordStartDateTime_WithIncludes]
	ON [dbo].[PersonDisability] ([PersonId],[RecordStartDateTime])
	INCLUDE ([PrimaryDisabilityTypeId],[DisabilityStatus],[RecordEndDateTime],[DataCollectionId])

	CREATE NONCLUSTERED INDEX [IX_PersonHomelessness_PersonId_RecordStartDateTime_WithIncludes]
	ON [dbo].[PersonHomelessness] ([PersonId],[RecordStartDateTime])
	INCLUDE ([RecordEndDateTime],[RefHomelessNighttimeResidenceId])

	CREATE NONCLUSTERED INDEX [IX_DimDisciplines_DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode_WithIdeaInterimRemovalEdFactsCodeInclude]
	ON [RDS].[DimDisciplines] ([DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode])
	INCLUDE ([IdeaInterimRemovalEdFactsCode])

	CREATE NONCLUSTERED INDEX [IX_DimK12Students_SexEdFactsCode]
ON [RDS].[DimK12Students] ([SexEdFactsCode])

CREATE NONCLUSTERED INDEX [IX_FactK12StudentDisciplines_SchoolYearId_K12DemographicId_FactTypeId_WithIncludes]
ON [RDS].[FactK12StudentDisciplines] ([SchoolYearId],[K12DemographicId],[FactTypeId])
INCLUDE ([DisciplineId],[IdeaStatusId],[K12StudentId],[DisciplineCount],[DisciplineDuration],[SeaId])

CREATE NONCLUSTERED INDEX [IX_FactK12StudentDisciplines_IdeaStatusId_WithIncludes]
ON [RDS].[FactK12StudentDisciplines] ([IdeaStatusId])
INCLUDE ([DisciplineId],[K12StudentId],[DisciplineDuration])

CREATE NONCLUSTERED INDEX [IX_DimDisciplines_DisciplineMethodOfChildrenWithDisabilitiesEdFactsCodes_WithIncludes]
ON [RDS].[DimDisciplines] ([DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode])
INCLUDE ([IdeaInterimRemovalEdFactsCode])

CREATE NONCLUSTERED INDEX [IX_FactK12StudentDisciplines_SchoolYearId_DisciplineId_FactTypeId_WithIncludes]
ON [RDS].[FactK12StudentDisciplines] ([SchoolYearId],[DisciplineId],[FactTypeId])
INCLUDE ([IdeaStatusId],[K12StudentId],[DisciplineCount],[DisciplineDuration],[RaceId],[SeaId])

CREATE NONCLUSTERED INDEX [IX_FactK12StudentDisciplines_SchoolYearId_FactTypeId_WithIncludes]
ON [RDS].[FactK12StudentDisciplines] ([SchoolYearId],[FactTypeId])
INCLUDE ([K12SchoolId],[LeaId])

CREATE NONCLUSTERED INDEX [IX_FactK12StudentDisciplines_AgeId_SchoolYearId_FactTypeId_WithIncludes]
ON [RDS].[FactK12StudentDisciplines] ([AgeId],[SchoolYearId],[FactTypeId])
INCLUDE ([DisciplineId],[IdeaStatusId],[K12SchoolId],[K12StudentId],[LeaId],[SeaId])

CREATE NONCLUSTERED INDEX [IX_FactK12StudentDisciplines_SchoolYearId_FactTypeId_IdeaStatusId_K12StudentId]
ON [RDS].[FactK12StudentDisciplines] ([SchoolYearId],[FactTypeId],[IdeaStatusId],[K12StudentId])
INCLUDE ([DisciplineId],[DisciplineCount],[DisciplineDuration],[SeaId])

CREATE NONCLUSTERED INDEX [IX_DimIdeaStatuses_IdeaIndicatorEdFactsCode]
ON [RDS].[DimIdeaStatuses] ([IdeaIndicatorEdFactsCode])


If IndexProperty(Object_Id('RDS.DimK12Students'), 'IX_DimStudents_StateStudentIdentifier', 'IndexID') Is NOT Null
BEGIN
	 DROP INDEX [IX_DimStudents_StateStudentIdentifier] ON RDS.DimK12Students
END	
CREATE NONCLUSTERED INDEX [IX_DimStudents_StateStudentIdentifier] ON [RDS].[DimK12Students]
(
	[StateStudentIdentifier] ASC,
	[BirthDate] ASC,
	[FirstName] ASC,
	[LastName] ASC,
	[MiddleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


If IndexProperty(Object_Id('Staging.Discipline'), 'IX_Discipline_StudentIdentifier', 'IndexID') Is NOT Null
BEGIN
	 DROP INDEX [IX_Discipline_StudentIdentifier] ON Staging.Discipline
END	
CREATE NONCLUSTERED INDEX [IX_Discipline_StudentIdentifier] ON [Staging].[Discipline]
(
	[Student_Identifier_State] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


If IndexProperty(Object_Id('Staging.K12Enrollment'), 'IX_K12Enrollment_StudentIdentifier_First_Middle_Last_DOB', 'IndexID') Is NOT Null
BEGIN
	 DROP INDEX [IX_K12Enrollment_StudentIdentifier_First_Middle_Last_DOB] ON Staging.K12Enrollment
END	
CREATE NONCLUSTERED INDEX [IX_K12Enrollment_StudentIdentifier_First_Middle_Last_DOB] ON [Staging].[K12Enrollment]
(
	[Student_Identifier_State] ASC,
	[FirstName] ASC,
	[LastName] ASC,
	[MiddleName] ASC,
	[Birthdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

If IndexProperty(Object_Id('Staging.PersonRace'), 'IX_PersonRace_StudentIdentifierState_SchoolYear_OrganizationIdentifier_OrganizationType', 'IndexID') Is NOT Null
BEGIN
	 DROP INDEX [IX_PersonRace_StudentIdentifierState_SchoolYear_OrganizationIdentifier_OrganizationType] ON Staging.PersonRace
END	
CREATE NONCLUSTERED INDEX [IX_PersonRace_StudentIdentifierState_SchoolYear_OrganizationIdentifier_OrganizationType] ON [Staging].[PersonRace]
(
	[Student_Identifier_State] ASC,
	[SchoolYear] ASC,
	[OrganizationType] ASC,
	[OrganizationIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


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