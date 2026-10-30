IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwGraduationRate_FactTable]'))
    DROP VIEW [Debug].[vwGraduationRate_FactTable]
