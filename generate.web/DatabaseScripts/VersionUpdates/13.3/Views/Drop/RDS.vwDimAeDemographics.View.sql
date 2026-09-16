IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimAeDemographics]'))
DROP VIEW [RDS].[vwDimAeDemographics]