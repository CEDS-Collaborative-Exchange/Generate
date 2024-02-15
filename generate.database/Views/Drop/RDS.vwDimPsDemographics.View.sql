IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimPsDemographics]'))
    DROP VIEW [RDS].[vwDimPsDemographics]