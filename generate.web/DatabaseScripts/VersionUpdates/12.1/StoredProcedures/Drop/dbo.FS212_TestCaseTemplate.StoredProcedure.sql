IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FS212_TestCaseTemplate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[FS212_TestCaseTemplate]
