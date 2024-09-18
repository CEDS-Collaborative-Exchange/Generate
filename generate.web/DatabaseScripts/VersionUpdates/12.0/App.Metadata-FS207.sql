  DECLARE @DimFactTypeId INT
  SELECT @DimFactTypeId = [DimFactTypeId]
  FROM [RDS].[DimFactTypes]
  WHERE [FactTypeCode] = 'directory'

  UPDATE gft
  SET [FactTypeId] = @DimFactTypeId
  FROM [App].[GenerateReport_FactType] gft
  JOIN [App].[GenerateReports] gr ON gft.GenerateReportId = gr.GenerateReportId
  WHERE GR.ReportCode = 'C207'

  UPDATE [RDS].[DimFactTypes]
  SET [FactTypeDescription] = 'Directory related reports - 029,035,039,129,130,131,163,170,190,193,196,197,198,205,206,207,223'
  WHERE [FactTypeCode] = 'directory'