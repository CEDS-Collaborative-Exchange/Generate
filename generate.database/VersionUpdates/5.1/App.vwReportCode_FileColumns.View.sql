CREATE VIEW [App].[vwReportCode_FileColumns]
AS
SELECT [ColumnLength] = afc.ColumnLength
		,[ColumnName] = afc.ColumnName
		,[DimensionFieldName] = ad.DimensionFieldName
		,[DisplayName] = afc.DisplayName
		,[XMLElementName] = afc.XMLElementName
		,[DataType] = afc.DataType
		,[EndPosition] = afsfc.EndPosition
		,[IsOptional] = afsfc.IsOptional
		,[SequenceNumber] = afsfc.SequenceNumber
		,[StartPosition] = afsfc.StartPosition
		,[SubmissionYear] = afs.SubmissionYear
		,[OrganizationLevelId] = afs.OrganizationLevelId
		,[ReportCode] = agr.ReportCode
  FROM App.GenerateReports agr
  INNER JOIN App.FileSubmissions afs ON agr.GenerateReportId = afs.GenerateReportId
  LEFT JOIN App.FileSubmission_FileColumns afsfc ON afs.FileSubmissionId = afsfc.FileSubmissionId
  LEFT JOIN App.FileColumns afc ON afsfc.FileColumnId = afc.FileColumnId
  LEFT JOIN App.Dimensions ad ON afc.DimensionId = ad.DimensionId
