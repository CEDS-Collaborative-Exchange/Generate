IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwSchoolPerformanceIndicators_FactTable]'))
    DROP VIEW [Debug].[vwSchoolPerformanceIndicators_FactTable]
