IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[App].[Get_CategoriesByCategorySet]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [App].[Get_CategoriesByCategorySet]
