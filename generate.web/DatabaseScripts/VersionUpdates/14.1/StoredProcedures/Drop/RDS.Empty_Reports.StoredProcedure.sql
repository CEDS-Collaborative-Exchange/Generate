IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Empty_Reports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Empty_Reports]