IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ODS].[Get_AssessmentTypeChildrenWithDisabilities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ODS].[Get_AssessmentTypeChildrenWithDisabilities]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Get_AssessmentTypeChildrenWithDisabilities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Get_AssessmentTypeChildrenWithDisabilities]