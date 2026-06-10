IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[Debug].[vwGraduatesCompleters_FactTable]'))
    DROP VIEW [Debug].[vwGraduatesCompleters_FactTable]
