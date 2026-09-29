IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimPSDemographics]'))
DROP VIEW [RDS].[vwDimPSDemographics]