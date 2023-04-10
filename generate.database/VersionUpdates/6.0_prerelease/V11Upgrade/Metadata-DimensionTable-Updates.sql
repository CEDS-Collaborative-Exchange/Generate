IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAeDemographics')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAeDemographics', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAeProgramTypes')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAeProgramTypes', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAeProgramYears')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAeProgramYears', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAeProviders')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAeProviders', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAeStudentStatuses')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAeStudentStatuses', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAssessmentAccommodations')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAssessmentAccommodations', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAssessmentAdministrations')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAssessmentAdministrations', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAssessmentForms')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAssessmentForms', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAssessmentParticipationSessions')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAssessmentParticipationSessions', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAssessmentPerformanceLevels')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAssessmentPerformanceLevels', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAssessmentRegistrations')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAssessmentRegistrations', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAssessmentResults')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAssessmentResults', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAssessmentStatuses')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAssessmentStatuses', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAssessmentRegistrations')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAssessmentRegistrations', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAssessmentSubtests')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimAssessmentSubtests', 1)
END

IF EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimAttendance')
BEGIN
	Update [App].[DimensionTables] SET [DimensionTableName] = 'DimAttendances' WHERE [DimensionTableName] = 'DimAttendance'
END

IF EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimCharterSchoolStatus')
BEGIN
	Update [App].[DimensionTables] SET [DimensionTableName] = 'DimCharterSchoolStatuses' WHERE [DimensionTableName] = 'DimCharterSchoolStatus'
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimChildOutcomeSummaries')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimChildOutcomeSummaries', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimCompetencyDefinitions')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimCompetencyDefinitions', 1)
END

IF EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimComprehensiveSupportReasonApplicabilities')
BEGIN
	Update [App].[DimensionTables] SET [DimensionTableName] = 'DimReasonApplicabilities' WHERE [DimensionTableName] = 'DimComprehensiveSupportReasonApplicabilities'
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimDisabilityStatuses')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimDisabilityStatuses', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimEnglishLearnerStatuses')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimEnglishLearnerStatuses', 1)
END

IF EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimDisciplines')
BEGIN
	Update [App].[DimensionTables] SET [DimensionTableName] = 'DimDisciplineStatuses' WHERE [DimensionTableName] = 'DimDisciplines'
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimFosterCareStatuses')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimFosterCareStatuses', 1)
END

IF EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimIdeaStatuses')
BEGIN
	Update [App].[DimensionTables] SET [DimensionTableName] = 'DimIdeaDisabilityTypes' WHERE [DimensionTableName] = 'DimIdeaStatuses'
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimIeus')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimIeus', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimIncidentStatuses')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimIncidentStatuses', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimIndividualizedProgramStatuses')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimIndividualizedProgramStatuses', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimEconomicallyDisadvantagedStatuses')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimEconomicallyDisadvantagedStatuses', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimHomelessnessStatuses')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimHomelessnessStatuses', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimMilitaryStatuses')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimMilitaryStatuses', 1)
END

IF EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimK12Staff')
BEGIN
	Update [App].[DimensionTables] SET [DimensionTableName] = 'DimPeople' WHERE [DimensionTableName] = 'DimK12Staff'
END

IF EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimK12StudentStatuses')
BEGIN
	Update [App].[DimensionTables] SET [DimensionTableName] = 'DimK12AcademicAwardStatuses' WHERE [DimensionTableName] = 'DimK12StudentStatuses'
END

IF EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimMigrants')
BEGIN
	Update [App].[DimensionTables] SET [DimensionTableName] = 'DimMigrantStatuses' WHERE [DimensionTableName] = 'DimMigrants'
END

IF EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimNOrDProgramStatuses')
BEGIN
	Update [App].[DimensionTables] SET [DimensionTableName] = 'DimNOrDStatuses' WHERE [DimensionTableName] = 'DimNOrDProgramStatuses'
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimImmigrantStatuses')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimImmigrantStatuses', 1)
END

IF NOT EXISTS (SELECT 1 FROM app.[DimensionTables] WHERE [DimensionTableName] = 'DimPsDemographics')
BEGIN
	INSERT INTO [App].[DimensionTables]([DimensionTableName],[IsReportingDimension])
    VALUES('DimPsDemographics', 1)
END