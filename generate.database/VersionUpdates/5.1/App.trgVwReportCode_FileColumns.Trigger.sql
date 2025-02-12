﻿CREATE TRIGGER [App].[trgVwReportCode_FileColumns]
   ON  [App].[vwReportCode_FileColumns]
   INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	
	MERGE INTO App.FileColumns afc
	USING (
		SELECT i1.ColumnLength,
				i1.ColumnName,
				ad.DimensionId,
				i1.DisplayName,
				i1.XMLElementName,
				i1.DataType
		FROM inserted i1
		LEFT JOIN App.Dimensions ad
			ON i1.DimensionFieldName = ad.DimensionFieldName
	) i ON (
		afc.ColumnLength = i.ColumnLength
		AND afc.ColumnName = i.ColumnName
		AND ISNULL(afc.DimensionId,0) = ISNULL(i.DimensionId,0)
		AND afc.DisplayName = i.DisplayName
		AND afc.XMLElementName = i.XMLElementName
		AND afc.DataType = i.DataType
		)
	WHEN NOT MATCHED THEN INSERT (
		ColumnLength,
		ColumnName,
		DimensionId,
		DisplayName,
		XMLElementName,
		DataType
	)
	VALUES (
		i.ColumnLength,
		i.ColumnName,
		i.DimensionId,
		i.DisplayName,
		i.XMLElementName,
		i.DataType
	);

	MERGE INTO App.FileSubmission_FileColumns afsfc
	USING (
		SELECT afs.FileSubmissionId
				,afc.FileColumnId
				,i.EndPosition
				,i.IsOptional
				,i.SequenceNumber
				,i.StartPosition
		FROM (
			SELECT i1.*
					,ad.DimensionId
			FROM inserted i1
			LEFT JOIN App.Dimensions ad
				ON i1.DimensionFieldName = ad.DimensionFieldName
		) i
		INNER JOIN App.GenerateReports agr ON i.ReportCode = agr.ReportCode
		INNER JOIN App.FileSubmissions afs ON agr.GenerateReportId = afs.GenerateReportId
											AND i.SubmissionYear = afs.SubmissionYear
											AND i.OrganizationLevelId = afs.OrganizationLevelId
		INNER JOIN App.FileColumns afc 
			ON i.ColumnLength = afc.ColumnLength
			AND i.ColumnName = afc.ColumnName
			AND i.DisplayName = afc.DisplayName
			AND i.XMLElementName = afc.XMLElementName
			AND i.DataType = afc.DataType
			AND ISNULL(i.DimensionId,0) = ISNULL(afc.DimensionId,0)
	) i2 ON (
			afsfc.FileSubmissionId = i2.FileSubmissionId
			AND afsfc.FileColumnId = i2.FileColumnId
			AND afsfc.StartPosition = i2.StartPosition
		)
	WHEN MATCHED THEN UPDATE
		SET EndPosition = i2.EndPosition
			,IsOptional = i2.IsOptional
			,SequenceNumber = i2.SequenceNumber
			,StartPosition = i2.StartPosition
		
	WHEN NOT MATCHED THEN 
		INSERT (
			FileSubmissionId
			,FileColumnId
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
		)
		VALUES (
			i2.FileSubmissionId
			,i2.FileColumnId
			,i2.EndPosition
			,i2.IsOptional
			,i2.SequenceNumber
			,i2.StartPosition
		);
	
END