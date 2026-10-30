IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDS].[Insert_CountsIntoReportTable]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [RDS].[Insert_CountsIntoReportTable]

