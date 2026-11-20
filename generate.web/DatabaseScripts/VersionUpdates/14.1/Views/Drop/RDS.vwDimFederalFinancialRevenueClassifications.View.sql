IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[RDS].[vwDimFederalFinancialRevenueClassifications]'))
DROP VIEW [RDS].[vwDimFederalFinancialRevenueClassifications]