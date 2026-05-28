IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ODS].[Get_Organizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ODS].[Get_Organizations]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_Organizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Get_Organizations]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[app].[Get_Organizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [App].[Get_Organizations]