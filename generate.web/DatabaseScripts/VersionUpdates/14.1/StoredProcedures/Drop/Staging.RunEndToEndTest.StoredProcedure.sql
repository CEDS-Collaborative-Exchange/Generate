IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Staging].[RunEndToEndTest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Staging].[RunEndToEndTest]
