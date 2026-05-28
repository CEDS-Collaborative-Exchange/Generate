IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwAssessmentsSummaryByRace]'))
    DROP VIEW [RDS].[vwAssessmentsSummaryByRace]