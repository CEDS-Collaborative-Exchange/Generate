IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[BI].[vwAssessmentsSummaryByRace]'))
    DROP VIEW [BI].[vwAssessmentsSummaryByRace]