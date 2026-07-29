IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[App].[Run_Before_Tests]') AND type in (N'P', N'PC'))
DROP PROCEDURE [App].[Run_Before_Tests]
