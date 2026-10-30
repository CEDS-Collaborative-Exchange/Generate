/*
This script is installed on the EDENDB in the EDFacts development environment.  
This script should NOT be installed on a CEDS/Generate database.
*/ 

USE [EDENDB]
GO

/****** Object:  StoredProcedure [dbo].[Generate_ExportMetadata_OneFile]    Script Date: 1/24/2023 6:15:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Generate_ExportMetadata_OneFile]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Generate_ExportMetadata_OneFile] AS' 
END
GO


ALTER PROCEDURE [dbo].[Generate_ExportMetadata_OneFile]
	@ReportCode varchar(4)
	,@SchoolYear smallint /*e.g. for SY2021-2022, use 2022*/
AS

BEGIN TRAN
	BEGIN TRY
		DECLARE @FileSpecificationDocumentNumber varchar(5) 
			,@strSchoolYear varchar(4)
			,@strSchoolYearName varchar(9)

		--Set intermediate values
		SET @strSchoolYear = CAST(@SchoolYear AS varchar(4))
		SET @strSchoolYearName = CAST((@SchoolYear - 1) AS varchar(4)) + '-' + CAST(@SchoolYear AS varchar(4))
		SET @FileSpecificationDocumentNumber = RIGHT(@ReportCode,3)

		--Delete existing md from GenerateOptions and GenerateColumns (and GenerateMetadata?) for ReportCode and SchoolYear
		DELETE FROM dbo.GenerateOptions
		WHERE ReportCode = @ReportCode
			AND SubmissionYear = @SchoolYear

		DELETE FROM dbo.GenerateColumns
		WHERE ReportCode = @ReportCode
			AND SubmissionYear = @SchoolYear

		--Insert new md
		
	INSERT INTO GenerateOptions(
			ReportCode
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
			,CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
			,CategoryCode
			,CategoryName
			,EdFactsCategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,EdFactsCategoryCodeId
		) 
SELECT	
[ReportCode] ,
[FileSubmissionDescription] ,
[OrganizationLevelId]  =CAST([OrganizationLevelId] AS varchar(1)) ,
[SubmissionYear] ,
[CategorySetCode] ,
[CategorySetName] ,
[EdFactsTableTypeGroupId]  =CAST([EdFactsTableTypeGroupId] AS varchar(10)) ,
[EdFactsTableTypeId]  = CAST([EdFactsTableTypeId] AS varchar(10)) ,
[TableTypeAbbrv] ,
[TableTypeName] ,
[CategoryCode] ,
[CategoryName] ,
[EdFactsCategoryId] = CAST([EdFactsCategoryId] AS varchar(10)) ,
[CategoryOptionCode],
[CategoryOptionName],
[EdFactsCategoryCodeId] = CAST([EdFactsCategoryCodeId] AS varchar(10)) 

	FROM (
	  select --* 
	  [ReportCode] = REPLACE(fsd.FileSpecificationDocumentNumber,'N','c')	--'c' + RIGHT('000' + CAST(FS_Number AS varchar(5)),3)
			,[FileSubmissionDescription] = frl.FileTypeDescription
			,[OrganizationLevelId] = frl.EducationLevelID
			,[SubmissionYear] = RIGHT(syfrl.Name,4)
			,[CategorySetCode] = ttg.TableTypeGroupName
			,[CategorySetName] = CASE LEFT(ttg.TableTypeGroupName,2) WHEN 'EU' THEN 'Education Unit Total'
																		WHEN 'CS' THEN 'Category Set ' + RIGHT(ttg.TableTypeGroupName,1)
																		WHEN 'ST' THEN 'Subtotal ' + RIGHT(ttg.TableTypeGroupName,1)
																	END
			,[EdFactsTableTypeGroupId] = ttg.TableTypeGroupID
			,[EdFactsTableTypeId] = tt.TableTypeID
			,[TableTypeAbbrv] = tt.TableTypeAbbrv
			,[TableTypeName] = tt.TableTypeName
			,[CategoryCode] = c.CategoryAbbrv
			,[CategoryName] = c.CategoryName
			,[EdFactsCategoryId] = c.CategoryID
			,[CategoryOptionCode] = cc.CategoryCodeAbbrv
			,[CategoryOptionName] = cc.CategoryCodeValue
			,[EdFactsCategoryCodeId] = cc.CategoryCodeID
	FROM FileSpecificationDocument fsd
		INNER JOIN FileRecordLayout_x_FileSpecificationDocument frlfsd ON fsd.FileSpecificationDocumentID = frlfsd.FileSpecificationDocumentID
		INNER JOIN FileRecordLayout frl ON frlfsd.FileRecordLayoutID = frl.FileRecordLayoutID
			INNER JOIN ReportingPeriod rpfrl ON frl.ReportingPeriodID = rpfrl.ReportingPeriodID
				INNER JOIN SchoolYear syfrl ON rpfrl.SchoolYearID = syfrl.SchoolYearID
		INNER JOIN FileRecordLayout_x_TableType frltt ON frl.FileRecordLayoutID = frltt.FileRecordLayoutID
			LEFT JOIN ReportingPeriod rpfrltt ON frltt.ReportingPeriodID = rpfrltt.ReportingPeriodID
				INNER JOIN SchoolYear syfrltt ON rpfrltt.SchoolYearID = syfrltt.SchoolYearID
												AND syfrl.SchoolYearID = syfrltt.SchoolYearID
		INNER JOIN TableType tt ON frltt.TableTypeID = tt.TableTypeID
		INNER JOIN TableTypeGroup ttg ON frltt.TableTypeID = ttg.TableTypeID
			AND frl.EducationLevelID = ttg.EducationLevelID
			INNER JOIN ReportingPeriod rpttg ON ttg.ReportingPeriodID = rpttg.ReportingPeriodID
				INNER JOIN SchoolYear syttg ON rpttg.SchoolYearID = syttg.SchoolYearID
											AND syfrl.SchoolYearID = syttg.SchoolYearID
		INNER JOIN TableTypeGroup_x_CategoryCode ttgcc ON ttg.TableTypeGroupID = ttgcc.TableTypeGroupID
		INNER JOIN Category c ON ttgcc.CategoryID = c.CategoryID
		INNER JOIN CategoryCode cc ON ttgcc.CategoryCodeID = cc.CategoryCodeID
	WHERE fsd.FileSpecificationDocumentNumber = 'N' + @FileSpecificationDocumentNumber --'N002'
		AND RIGHT(syfrl.Name,4) =  @strSchoolYear --'2021'

	) x

	DECLARE @dims TABLE (
		DimensionFieldName varchar(100)
		,ColumnName varchar(100)
		,GenerateReportCode varchar(5)
		,FileSpecificationDocumentNumber varchar(5)
	)

	DECLARE @uniformDims TABLE (
		DimensionFieldName varchar(100)
		,ColumnName varchar(100)
	)

	DECLARE @fsDims TABLE (
		DimensionFieldName varchar(100)
		,ColumnName varchar(100)
		,GenerateReportCode varchar(5)
		,FileSpecificationDocumentNumber varchar(5)
	)

	DECLARE @essMd TABLE (
		ColumnLength smallint
		,ColumnName varchar(50)
		,DisplayName varchar(100)
		,XMLElementName varchar(200)
		,DataType varchar(50)
		,EndPosition smallint
		,IsOptional smallint
		,SequenceNumber int
		,StartPosition smallint
		,SubmissionYear smallint
		,OrganizationLevelId smallint
		,ReportCode varchar(5)
	)

	INSERT @dims
	SELECT [DimensionFieldName] = gd.DimensionFieldName
		,[ColumnName] = gd.ColumnName
		,[GenerateReportCode] = gdfsd.GenerateReportCode
		,[FileSpecificationDocumentNumber] = gdfsd.FileSpecificationDocumentNumber
	FROM Generate_Dimension gd 
	LEFT JOIN Generate_Dimension_x_FileSpecificationDocument gdfsd ON gd.DimensionFieldName = gdfsd.DimensionFieldName

	INSERT @uniformDims
	SELECT [DimensionFieldName] = DimensionFieldName
		,[ColumnName] = ColumnName
	FROM @dims
	WHERE GenerateReportCode IS NULL

	INSERT @fsDims
	SELECT [DimensionFieldName] = DimensionFieldName
		,[ColumnName] = ColumnName
		,[GenerateReportCode] = GenerateReportCode
		,[FileSpecificationDocumentNumber] = FileSpecificationDocumentNumber
	FROM @dims
	WHERE GenerateReportCode IS NOT NULL

	INSERT @essMd
	SELECT
	[ColumnLength] = frle.ColumnLength,
	[ColumnName] = frle.ColumnName,
	[DisplayName] = ISNULL(frle.DisplayName,''),
	[XMLElementName] = ISNULL(frle.XMLElementName,''),
	[DataType] = CASE frle.ColumnName WHEN 'FileRecordNumber' THEN 'Number' 
										WHEN 'CarriageReturn/LineFeed' THEN 'Control Character'
										WHEN 'Amount' THEN CASE WHEN amountIsDec.DataElementID IS NOT NULL THEN 'Decimal2'
																ELSE 'Number'
															END
										ELSE 'String'
				END,
	[EndPosition] = frle.EndPosition,
	[IsOptional] = CASE frle.Optionality WHEN 'M' THEN 1 ELSE 0 END,
	[SequenceNumber] = frle.SeqNumber,
	[StartPosition] = frle.StartPosition
	,[SubmissionYear] = RIGHT(syfrl.Name,4)
	,[OrganizationLevelId] = frl.EducationLevelID
	,[ReportCode] = REPLACE(fsd.FileSpecificationDocumentNumber,'N','c')
	from FileSpecificationDocument fsd
	inner join DataElement_x_FileSpecificationDocument defsd on fsd.FileSpecificationDocumentID = defsd.FileSpecificationDocumentID
		inner join ReportingPeriod rpdefsd ON defsd.ReportingPeriodID = rpdefsd.ReportingPeriodID
		inner join SchoolYear sydefsd on rpdefsd.SchoolYearID = sydefsd.SchoolYearID
	inner join DataElement de on defsd.DataElementID = de.DataElementID
	inner join FileRecordLayout_x_FileSpecificationDocument frlfsd on fsd.FileSpecificationDocumentID = frlfsd.FileSpecificationDocumentID
	inner join FileRecordLayout frl on frlfsd.FileRecordLayoutID = frl.FileRecordLayoutID
		inner join ReportingPeriod rpfrl On frl.ReportingPeriodID = rpfrl.ReportingPeriodID
		inner join SchoolYear syfrl on rpfrl.SchoolYearID = syfrl.SchoolYearID
									and sydefsd.SchoolYearID = syfrl.SchoolYearID
	INNER join FileRecordLayoutElement frle ON frl.FileRecordLayoutID = frle.FileRecordLayoutID
	LEFT JOIN (
		select DISTINCT de.DataElementID --,de.DataElementName,'Decimal2'
		from DataElement de
		inner join DataElement_x_FileRecordLayoutElement defrle on de.DataElementID = defrle.DataElementID
		inner join Error_x_FileRecordLayoutElement efrle on defrle.FileRecordLayoutElementID = efrle.FileRecordLayoutElementID
		where efrle.ErrorID in (118,90) --ErrorIDs 118 and 90 ('DECIMAL2' and 'DECIMALCHECK') are only used in files that collect decimal metrics
	) amountIsDec ON defsd.DataElementID = amountIsDec.DataElementID
	WHERE sydefsd.Name = @strSchoolYearName --'2020-2021'
	AND fsd.FileSpecificationDocumentNumber = 'N' + @FileSpecificationDocumentNumber --'N002'

	INSERT dbo.GenerateColumns (
		ColumnLength
		,ColumnName
		,DimensionFieldName
		,DisplayName
		,XMLElementName
		,DataType
		,EndPosition
		,IsOptional
		,SequenceNumber
		,StartPosition
		,SubmissionYear
		,OrganizationLevelId
		,ReportCode
	)
	SELECT ColumnLength
			,ColumnName
			,DimensionFieldName
			,DisplayName
			,XMLElementName
			,DataType
			,EndPosition
			,IsOptional
			,SequenceNumber
			,StartPosition
			,SubmissionYear
			,OrganizationLevelId
			,ReportCode
	FROM (
		SELECT ColumnLength
				,e.ColumnName
				,DimensionFieldName
				,DisplayName
				,XMLElementName
				,DataType
				,EndPosition
				,IsOptional
				,SequenceNumber
				,StartPosition
				,SubmissionYear
				,OrganizationLevelId
				,ReportCode
		FROM @essMd e
		INNER JOIN @uniformDims ud ON e.ColumnName = ud.ColumnName

		UNION SELECT ColumnLength
				,e.ColumnName
				,DimensionFieldName
				,DisplayName
				,XMLElementName
				,DataType
				,EndPosition
				,IsOptional
				,SequenceNumber
				,StartPosition
				,SubmissionYear
				,OrganizationLevelId
				,e.ReportCode
		FROM @essMd e
		INNER JOIN @fsDims fd ON e.ColumnName = fd.ColumnName
			AND e.ReportCode = fd.GenerateReportCode

		UNION SELECT ColumnLength
				,e.ColumnName
				,[DimensionFieldName] = NULL
				,DisplayName
				,XMLElementName
				,DataType
				,EndPosition
				,IsOptional
				,SequenceNumber
				,StartPosition
				,SubmissionYear
				,OrganizationLevelId
				,e.ReportCode
		FROM @essMd e
		LEFT JOIN (
			SELECT ColumnName
			FROM @dims
		) d ON e.ColumnName = d.ColumnName
		WHERE d.ColumnName IS NULL
	) x
	ORDER BY x.ReportCode,x.SubmissionYear,x.OrganizationLevelId,x.SequenceNumber

		COMMIT
	END TRY
	BEGIN CATCH
		THROW
		ROLLBACK TRAN
	END CATCH
GO


