IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Empty_RDS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [RDS].[Empty_RDS]

