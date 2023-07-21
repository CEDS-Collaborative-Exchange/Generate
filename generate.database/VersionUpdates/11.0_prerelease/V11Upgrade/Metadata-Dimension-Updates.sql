SET NOCOUNT ON;

DECLARE @dimensionTableId as INT, @categoryId as INT, @dimensionId as INT

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimEconomicallyDisadvantagedStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId WHERE DimensionFieldName = 'EconomicDisadvantageStatus'

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimEnglishLearnerStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId WHERE DimensionFieldName = 'EnglishLearnerStatus'

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimFosterCareStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId, DimensionFieldName = 'ProgramParticipationFosterCare'
WHERE DimensionFieldName = 'FosterCareProgram'

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimK12StaffStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId, DimensionFieldName = 'TeachingCredentialType'
WHERE DimensionFieldName = 'EmergencyOrProvisionalCredentialStatus'


SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimImmigrantStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId WHERE DimensionFieldName = 'TitleIIIImmigrantParticipationStatus'

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimImmigrantStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId, DimensionFieldName = 'TitleIIIImmigrantStatus'
WHERE DimensionFieldName = 'TitleIIIProgramParticipation'

Update app.Dimensions SET DimensionFieldName = 'AssessmentAcademicSubject' WHERE DimensionFieldName = 'AssessmentSubject'
SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimAssessmentStatuses'

--Drop Perkins LEP from DimCteStatuses
SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimCteStatuses'
SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionTableId = @dimensionTableId AND DimensionFieldName = 'PerkinsLEPStatus'
SELECT @categoryId = CategoryId FROM app.Category_Dimensions WHERE DimensionId = @dimensionId

DELETE FROM app.Categories WHERE CategoryId = @categoryId
DELETE FROM app.Category_Dimensions WHERE CategoryId = @categoryId
DELETE FROM app.Dimensions WHERE DimensionTableId = @dimensionTableId AND DimensionId = @dimensionId

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimAssessmentStatuses'
IF NOT EXISTS(SELECT 1 FROM app.Dimensions where DimensionFieldName = 'AssessmentTypeAdministered')
BEGIN
	INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific])
    VALUES('AssessmentTypeAdministered', @dimensionTableId, 0, 0)
END

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimAssessmentRegistrations'

IF NOT EXISTS(SELECT 1 FROM app.Dimensions where DimensionFieldName = 'LeaFullAcademicYear')
BEGIN
	INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific])
    VALUES('LeaFullAcademicYear', @dimensionTableId, 0, 0)
END
IF NOT EXISTS(SELECT 1 FROM app.Dimensions where DimensionFieldName = 'SchoolFullAcademicYear')
BEGIN
	INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific])
    VALUES('SchoolFullAcademicYear', @dimensionTableId, 0, 0)
END
IF NOT EXISTS(SELECT 1 FROM app.Dimensions where DimensionFieldName = 'StateFullAcademicYear')
BEGIN
	INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific])
    VALUES('StateFullAcademicYear', @dimensionTableId, 0, 0)
END

Update app.Dimensions SET DimensionTableId = @dimensionTableId, DimensionFieldName = 'AssessmentRegistrationParticipationIndicator'
WHERE DimensionFieldName = 'ParticipationStatus'


SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimAssessmentStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId, DimensionFieldName = 'AssessmentPerformanceLevelIdentifier'
WHERE DimensionFieldName = 'PerformanceLevel'

Update app.Dimensions SET DimensionFieldName = 'ProgressLevel' WHERE DimensionFieldName = 'AssessmentProgressLevel'

Update app.Dimensions SET DimensionFieldName = 'CteParticipant' WHERE DimensionFieldName = 'CteProgram'
Update app.Dimensions SET DimensionFieldName = 'PerkinsEnglishLearnerStatus' WHERE DimensionFieldName = 'LepPerkinsStatus'

Update app.Dimensions SET DimensionFieldName = 'SingleParentOrSinglePregnantWomanStatus' 
WHERE DimensionFieldName = 'SingleParentOrSinglePregnantWoman'

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimDisabilityStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId WHERE DimensionFieldName = 'Section504Status'

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimDisciplineStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId 
WHERE DimensionFieldName IN ('DisciplinaryActionTaken','DisciplineMethodOfChildrenWithDisabilities',
'EducationalServicesAfterRemoval', 'IdeaInterimRemoval', 'IdeaInterimRemovalReason')


Update app.Dimensions SET DimensionFieldName = 'IdeaEducationalEnvironmentForEarlyChildhood' 
WHERE DimensionFieldName = 'IdeaEducationalEnvironment'

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimIdeaStatuses'
IF NOT EXISTS(SELECT 1 FROM app.Dimensions where DimensionFieldName = 'IdeaEducationalEnvironmentForSchoolAge')
BEGIN
	INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific])
    VALUES('IdeaEducationalEnvironmentForSchoolAge', @dimensionTableId, 0, 0)
END

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimIdeaDisabilityTypes'
Update app.Dimensions SET DimensionTableId = @dimensionTableId, DimensionFieldName = 'IdeaDisabilityType'
WHERE DimensionFieldName = 'PrimaryDisabilityType'

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimIncidentStatuses'
IF NOT EXISTS(SELECT 1 FROM app.Dimensions where DimensionFieldName = 'DisciplineReason')
BEGIN
	INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific])
    VALUES('DisciplineReason', @dimensionTableId, 0, 0)
END
Update app.Dimensions SET DimensionTableId = @dimensionTableId WHERE DimensionFieldName = 'IdeaInterimRemovalReason'
IF NOT EXISTS(SELECT 1 FROM app.Dimensions where DimensionFieldName = 'IncidentBehavior')
BEGIN
	INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific])
    VALUES('IncidentBehavior', @dimensionTableId, 0, 0)
END
IF NOT EXISTS(SELECT 1 FROM app.Dimensions where DimensionFieldName = 'IncidentInjuryType')
BEGIN
	INSERT INTO [App].[Dimensions]([DimensionFieldName],[DimensionTableId],[IsCalculated],[IsOrganizationLevelSpecific])
    VALUES('IncidentInjuryType', @dimensionTableId, 0, 0)
END


SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimHomelessnessStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId
WHERE DimensionFieldName IN ('HomelessnessStatus','HomelessPrimaryNighttimeResidence', 'HomelessUnaccompaniedYouthStatus', 
                             'HomelessServicedIndicator')

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimMigrantStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId
WHERE DimensionFieldName IN ('MigrantStatus')

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimMilitaryStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId
WHERE DimensionFieldName IN ('MilitaryConnectedStudentIndicator')

Update app.Dimensions SET DimensionFieldName = 'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType' 
WHERE DimensionFieldName = 'AcademicOrVocationalExitOutcome'

Update app.Dimensions SET DimensionFieldName = 'EdFactsAcademicOrCareerAndTechnicalOutcomeType' 
WHERE DimensionFieldName = 'AcademicOrVocationalOutcome'

Update app.Dimensions SET DimensionFieldName = 'EdFactsCertificationStatus' 
WHERE DimensionFieldName = 'CertificationStatus'

Update app.Dimensions SET DimensionFieldName = 'EdFactsTeacherOutOfFieldStatus' 
WHERE DimensionFieldName = 'OutOfFieldStatus'

Update app.Dimensions SET DimensionFieldName = 'SpecialEducationTeacherQualificationStatus' 
WHERE DimensionFieldName = 'QualificationStatus'

Update app.Dimensions SET DimensionFieldName = 'EdFactsTeacherInexperiencedStatus' 
WHERE DimensionFieldName = 'UnexperiencedStatus'

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimK12Demographics'
Update app.Dimensions SET DimensionTableId = @dimensionTableId
WHERE DimensionFieldName = 'Sex'

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimK12AcademicAwardStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId
WHERE DimensionFieldName = 'HighSchoolDiplomaType'

Update app.Dimensions SET DimensionFieldName = 'NationalSchoolLunchProgramDirectCertificationIndicator' 
WHERE DimensionFieldName = 'NSLPDirectCertificationIndicator'

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimMigrantStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId
WHERE DimensionFieldName IN ('ConsolidatedMepFundsStatus', 'ContinuationOfServicesReason', 'MigrantPrioritizedForServices')

Update app.Dimensions SET DimensionTableId = @dimensionTableId, DimensionFieldName = 'MigrantEducationProgramEnrollmentType'
WHERE DimensionFieldName IN ('MepEnrollmentType')

Update app.Dimensions SET DimensionTableId = @dimensionTableId, DimensionFieldName = 'MigrantEducationProgramServicesType'
WHERE DimensionFieldName IN ('MepServicesType')

Update app.Dimensions SET DimensionFieldName = 'NeglectedOrDelinquentLongTermStatus'
WHERE DimensionFieldName IN ('LongTermStatus')

Update app.Dimensions SET DimensionFieldName = 'ISO6392LanguageCode'
where DimensionFieldName in ('ISO6392Language')

SELECT @dimensionTableId = DimensionTableId FROM app.DimensionTables WHERE DimensionTableName = 'DimEconomicallyDisadvantagedStatuses'
Update app.Dimensions SET DimensionTableId = @dimensionTableId, DimensionFieldName = 'EligibilityStatusForSchoolFoodServicePrograms'
WHERE DimensionFieldName = 'EligibilityStatusForSchoolFoodServiceProgram'

Update app.Dimensions SET DimensionFieldName = 'TitleIIILanguageInstructionProgramType'
WHERE DimensionFieldName = 'TitleiiiLanguageInstruction'

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'EnglishLearnerStatus'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'LEPDISC'

Update app.Category_Dimensions set dimensionId = @dimensionId where CategoryId = @categoryId

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'IdeaEducationalEnvironmentForSchoolAge'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'EDENVIRIDEASA'

Update app.Category_Dimensions set dimensionId = @dimensionId where CategoryId = @categoryId

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'DisciplineReason'
SELECT @categoryId = CategoryId FROM app.Categories WHERE CategoryCode = 'DSCLPR'

IF NOT EXISTS(SELECT 1 from app.Category_Dimensions where CategoryId = @categoryId and DimensionId = @dimensionId)
BEGIN
    INSERT INTO [App].[Category_Dimensions]([CategoryId],[DimensionId])
    VALUES (@categoryId, @dimensionId)
END
ELSE
BEGIN
    Update app.Category_Dimensions set dimensionId = @dimensionId where CategoryId = @categoryId
END

SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'PlacementStatus'
DELETE FROM app.Category_Dimensions WHERE DimensionId = @dimensionId
DELETE FROM app.Dimensions WHERE DimensionId = @dimensionId


SELECT @dimensionId = DimensionId FROM app.Dimensions WHERE DimensionFieldName = 'PlacementType'
DELETE FROM app.Category_Dimensions WHERE DimensionId = @dimensionId
DELETE FROM app.Dimensions WHERE DimensionId = @dimensionId