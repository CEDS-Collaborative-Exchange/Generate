IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ODS].[Get_GradeLevels]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ODS].[Get_GradeLevels]