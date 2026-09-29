IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Staging].[Staging-To-DimK12Staff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Staging].[Staging-To-DimK12Staff]

