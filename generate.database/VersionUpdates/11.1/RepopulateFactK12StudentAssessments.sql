PRINT N'Copying existing data back into Factk12StudentAssessments';

-- temp table for inserting race into BridgeK12StudentAssessmentRaces table
    DECLARE
    @student_Assessment_xwalk TABLE (
        NewFactK12StudentAssessmentId INT
        , RaceId VARCHAR(100)
    );

-- Create CTE with the data to be inserted into RDS.FactK12StudentAssessments
    WITH distinctFactRecords AS (
        SELECT DISTINCT
            ISNULL(DimSchoolYearId, -1) AS [SchoolYearId]
            , ISNULL(edft.DimFactTypeId, -1) AS [FactTypeId]
            , ISNULL(DimSeaId, -1) AS [SeaId]
            , ISNULL(DimIeuId, -1) AS [IeuId]
            , ISNULL(DimLeaId, -1) AS [LeaId]
            , ISNULL(DimK12SchoolId, -1) AS [K12SchoolId]
            , ISNULL(DimPersonId, -1) AS [K12StudentId]
            , ISNULL(rdr.DimRaceId, -1)		AS [RaceId]
            , ISNULL(rda.DimAssessmentId, -1)  AS [AssessmentId]
            , -1	AS [AssessmentSubtestId]
            , -1	AS [AssessmentAdministrationId]
            , -1	AS [AssessmentRegistrationId]
            , -1	AS [AssessmentParticipationSessionId]
            , -1	AS [AssessmentResultId]
            , ISNULL(rdap.DimAssessmentPerformanceLevelId, -1) AS [AssessmentPerformanceLevelId]
            , -1	AS [CompetencyDefinitionId]
            , ISNULL(rdctes.DimCteStatusId, -1) AS [CteStatusId]
            , ISNULL(rdgl.DimGradeLevelId, -1) AS [GradeLevelWhenAssessedId]
            , ISNULL(rdis.DimIdeaStatusId, -1) AS [IdeaStatusId]
            , ISNULL(rdkdemo.DimK12DemographicId, -1)  AS [K12DemographicId]
            , ISNULL(DimNOrDStatusId, -1) AS [NOrDStatusId]
            , ISNULL(rdtiiis.DimTitleIIIStatusId, -1) AS [TitleIIIStatusId]
            , ISNULL(f.AssessmentCount, -1) AS [AssessmentCount]
            , -1	AS [AssessmentResultScoreValueRawScore]
            , -1	AS [AssessmentResultScoreValueScaleScore]
            , -1	AS [AssessmentResultScoreValuePercentile]
            , -1	AS [AssessmentResultScoreValueTScore]
            , -1	AS [AssessmentResultScoreValueZScore]
            , -1	AS [AssessmentResultScoreValueACTScore]
            , -1	AS [AssessmentResultScoreValueSATScore]
            , -1	AS [FactK12StudentAssessmentAccommodationId]
        FROM Upgrade.FactK12StudentAssessments f
        LEFT JOIN RDS.DimSchoolYears rdsy 
            ON f.SchoolYear = rdsy.SchoolYear
        LEFT JOIN RDS.DimFactTypes edft
            ON edft.FactTypeCode = 'Assessment'
        LEFT JOIN RDS.DimSeas rdsea 
            ON f.SeaIdentifierState = rdsea.SeaOrganizationIdentifierSea
            AND f.SEA_RecordStartDateTime = rdsea.RecordStartDateTime
            AND ISNULL(f.SEA_RecordEndDateTime, '1/1/1900') = ISNULL(rdsea.RecordEndDateTime, '1/1/1900') 
        LEFT JOIN RDS.DimIeus rdi 
            ON f.IeuIdentifierState = rdi.IeuOrganizationIdentifierSea
            AND f.IEU_RecordStartDateTime = rdi.RecordStartDateTime
            AND ISNULL(f.IEU_RecordEndDateTime, '1/1/1900') = ISNULL(rdi.RecordEndDateTime, '1/1/1900') 
        LEFT JOIN RDS.DimLeas rdl 
            ON f.LeaIdentifierState = rdl.LeaIdentifierSea
            AND f.LEA_RecordStartDateTime = rdl.RecordStartDateTime
            AND ISNULL(f.LEA_RecordEndDateTime, '1/1/1900') = ISNULL(rdl.RecordEndDateTime, '1/1/1900') 
        LEFT JOIN RDS.DimK12Schools dks
            ON dks.SchoolIdentifierSea = SchoolIdentifierState 
        LEFT JOIN RDS.DimPeople rdp
            ON f.StateStudentIdentifier = rdp.K12StudentStudentIdentifierState 
            AND rdp.IsActiveK12Student = 1
        LEFT JOIN RDS.DimRaces rdr 
            ON f.RaceCode = rdr.RaceCode
        LEFT JOIN RDS.DimAssessments rda
            ON f.AssessmentTypeCode = rda.AssessmentTypeCode
            AND f.AssessmentSubjectCode = rda.AssessmentTypeCode
            AND f.ParticipationStatusCode = rda.AssessmentAcademicSubjectCode
            AND f.AssessmentTypeAdministeredToEnglishLearnersCode = rda.AssessmentTypeAdministeredToEnglishLearnersCode
        LEFT JOIN RDS.DimAssessmentPerformanceLevels rdap
            ON f.PerformanceLevelCode = rdap.AssessmentPerformanceLevelIdentifier
        LEFT JOIN RDS.DimCteStatuses rdctes 
            ON  CASE f.CteAeDisplacedHomemakerIndicatorCode
                    WHEN 'DH' THEN 'Yes'
                    ELSE 'MISSING'
                END = rdctes.CteAeDisplacedHomemakerIndicatorCode
            AND CASE f.RepresentationStatusCode
                    WHEN 'MEM' THEN 'Underrepresented'
                    WHEN 'NM' THEN 'NotUnderrepresented'
                    ELSE 'MISSING'
                END = rdctes.CteNontraditionalGenderStatusCode
            AND CASE f.CteNontraditionalGenderStatusCode
                    WHEN 'NTE' THEN 'Yes'
                    ELSE 'MISSING'
                END = rdctes.CteNontraditionalCompletionCode
            AND CASE f.SingleParentOrSinglePregnantWomanCode
                    WHEN 'SPPT' THEN 'Yes'
                    ELSE 'MISSING'
                END = rdctes.SingleParentOrSinglePregnantWomanStatusCode
            AND CASE f.CteGraduationRateInclusionCode
                    WHEN 'GRAD' THEN 'IncludedAsGraduated'
                    WHEN 'NOTG' THEN 'NotIncludedAsGraduated'
                    ELSE 'MISSING'
                END = rdctes.CteGraduationRateInclusionCode
            AND CASE f.CteProgramCode 
                    WHEN 'CTEPART' THEN 'Yes'
                    WHEN 'NONCTEPART' THEN 'No'
                    ELSE 'MISSING'
                END = rdctes.CteParticipantCode
            AND CASE f.CteProgramCode 
                    WHEN 'CTECONC' THEN 'Yes'
                    WHEN 'NONCTEPART' THEN 'No'
                    ELSE 'MISSING'
                END = rdctes.CteConcentratorCode
        LEFT JOIN RDS.DimGradeLevels rdgl 
            ON f.GradeLevelCode = rdgl.GradeLevelCode
        LEFT JOIN RDS.DimIdeaStatuses rdis
            ON   rdis.SpecialEducationExitReasonCode = 'Missing' --Codes are the same
            AND CASE f.IdeaIndicatorCode
                    WHEN 'IDEA' THEN 'Yes'
                    ELSE 'MISSING'
                END = rdis.IdeaIndicatorCode
                AND rdis.IdeaEducationalEnvironmentForSchoolAgeCode = 'Missing'
            AND  rdis.IdeaEducationalEnvironmentForEarlyChildhoodCode = 'Missing'
        LEFT JOIN RDS.DimK12Demographics rdkdemo 
            ON f.SexCode = rdkdemo.SexCode
        LEFT JOIN RDS.DimNOrDStatuses rdnords
            ON  CASE f.NeglectedOrDelinquentProgramTypeCode
                    WHEN 'ADLTCORR' THEN 'AdultCorrection'
                    WHEN 'ATRISK' THEN 'AtRiskPrograms'
                    WHEN 'JUVCORR' THEN 'JuvenileCorrection'
                    WHEN 'JUVDET' THEN 'JuvenileDetention'
                    WHEN 'NEGLECT' THEN 'NeglectedPrograms'
                    WHEN 'OTHER' THEN 'OtherPrograms'
                    ELSE 'MISSING'
                END = rdnords.NeglectedOrDelinquentProgramTypeCode
        LEFT JOIN RDS.DimTitleIIIStatuses rdtiiis
            ON  f.TitleiiiProgramParticipationCode = rdtiiis.ProgramParticipationTitleIIILiepCode
            AND f.TitleIIIImmigrantParticipationStatusCode = rdtiiis.TitleIIIImmigrantParticipationStatusCode
            AND f.ProficiencyStatusCode = rdtiiis.ProficiencyStatusCode
            AND f.TitleiiiAccountabilityProgressStatusCode = rdtiiis.TitleIIIAccountabilityProgressStatusCode
            AND f.TitleiiiLanguageInstructionCode = rdtiiis.TitleIIILanguageInstructionProgramTypeCode
    )

-- Insert and get the new table id from RDS.FactK12StudentAssessments and the Race ID from CTE distinctFactRecords and insert it into @student_Assessment_xwalk 
    MERGE INTO RDS.FactK12StudentAssessments TARGET
        USING distinctFactRecords AS distinctIDs
        ON TARGET.SchoolYearId = 0 --Set this to something that will not match
    WHEN NOT MATCHED THEN 
        INSERT ( 
            [SchoolYearId]
            , [FactTypeId]
            , [SeaId]
            , [IeuId]
            , [LeaId]
            , [K12SchoolId]
            , [K12StudentId]
            , [AssessmentId]
            , [AssessmentSubtestId]
            , [AssessmentAdministrationId]
            , [AssessmentRegistrationId]
            , [AssessmentParticipationSessionId]
            , [AssessmentResultId]
            , [AssessmentPerformanceLevelId]
            , [CompetencyDefinitionId]
            , [CteStatusId]
            , [GradeLevelWhenAssessedId]
            , [IdeaStatusId]
            , [K12DemographicId]
            , [NOrDStatusId]
            , [TitleIIIStatusId]
            , [AssessmentCount]
            , [AssessmentResultScoreValueRawScore]
            , [AssessmentResultScoreValueScaleScore]
            , [AssessmentResultScoreValuePercentile]
            , [AssessmentResultScoreValueTScore]
            , [AssessmentResultScoreValueZScore]
            , [AssessmentResultScoreValueACTScore]
            , [AssessmentResultScoreValueSATScore]
            , [FactK12StudentAssessmentAccommodationId]
        )  
        VALUES ( 
            [SchoolYearId]
            , [FactTypeId]
            , [SeaId]
            , [IeuId]
            , [LeaId]
            , [K12SchoolId]
            , [K12StudentId]
            , [AssessmentId]
            , [AssessmentSubtestId]
            , [AssessmentAdministrationId]
            , [AssessmentRegistrationId]
            , [AssessmentParticipationSessionId]
            , [AssessmentResultId]
            , [AssessmentPerformanceLevelId]
            , [CompetencyDefinitionId]
            , [CteStatusId]
            , [GradeLevelWhenAssessedId]
            , [IdeaStatusId]
            , [K12DemographicId]
            , [NOrDStatusId]
            , [TitleIIIStatusId]
            , [AssessmentCount]
            , [AssessmentResultScoreValueRawScore]
            , [AssessmentResultScoreValueScaleScore]
            , [AssessmentResultScoreValuePercentile]
            , [AssessmentResultScoreValueTScore]
            , [AssessmentResultScoreValueZScore]
            , [AssessmentResultScoreValueACTScore]
            , [AssessmentResultScoreValueSATScore]
            , [FactK12StudentAssessmentAccommodationId]
        )   
    OUTPUT	INSERTED.FactK12StudentAssessmentId
            ,distinctIDs.RaceID
    INTO @student_Assessment_xwalk (NewFactK12StudentAssessmentId, RaceId);

-- Insert the new RDS.FactK12StudentAssessment and raceID into RDS.BridgeK12StudentAssessmentRaces
    INSERT INTO RDS.BridgeK12StudentAssessmentRaces
    SELECT
        NewFactK12StudentAssessmentId,
        DimRaceId
    FROM @student_Assessment_xwalk xw
    JOIN RDS.DimRaces r
        ON xw.RaceId = r.DimRaceId


