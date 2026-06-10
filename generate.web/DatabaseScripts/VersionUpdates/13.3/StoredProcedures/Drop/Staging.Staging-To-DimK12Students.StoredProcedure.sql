IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Staging].[Staging-To-DimK12Students]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Staging].[Staging-To-DimK12Students]

