CREATE TRIGGER [App].[trgVwReportCode_CategoryOptions]
   ON  [App].[vwReportCode_CategoryOptions]
   INSTEAD OF INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --Assumes App.GenerateReports is populated

	MERGE INTO App.FileSubmissions afs
	USING (
		SELECT agr.GenerateReportId
				,i.FileSubmissionDescription
				,i.OrganizationLevelId
				,i.SubmissionYear
		FROM inserted i
		INNER JOIN App.GenerateReports agr
			ON i.ReportCode = agr.ReportCode
	) i2 
	ON afs.GenerateReportId = i2.GenerateReportId
		AND afs.OrganizationLevelId = i2.OrganizationLevelId
		AND afs.SubmissionYear = i2.SubmissionYear
	WHEN MATCHED THEN 
		UPDATE SET FileSubmissionDescription = i2.FileSubmissionDescription
	WHEN NOT MATCHED THEN 
		INSERT (
			GenerateReportId
			,FileSubmissionDescription
			,OrganizationLevelId
			,SubmissionYear
		)
		VALUES (
			i2.GenerateReportId
			,i2.FileSubmissionDescription
			,i2.OrganizationLevelId
			,i2.SubmissionYear
		);

	MERGE INTO App.TableTypes att
	USING (
		SELECT EdFactsTableTypeId
			,TableTypeAbbrv
			,TableTypeName
		FROM inserted
	) i
	ON att.EdFactsTableTypeID = i.EdFactsTableTypeID
	WHEN MATCHED THEN
		UPDATE SET TableTypeAbbrv = i.TableTypeAbbrv
					,TableTypeName = i.TableTypeName
	WHEN NOT MATCHED THEN
		INSERT (
			TableTypeAbbrv
			,TableTypeName
			,EdFactsTableTypeId
		)
		VALUES (
			i.TableTypeAbbrv
			,i.TableTypeName
			,i.EdFactsTableTypeId
		);

	MERGE INTO App.CategorySets acs
	USING (
		SELECT i.CategorySetCode
			,i.CategorySetName
			,i.EdFactsTableTypeGroupId
			,agr.GenerateReportId
			,i.OrganizationLevelId
			,i.SubmissionYear
			,att.TableTypeId
			,i.EdFactsTableTypeId
		FROM inserted i
		INNER JOIN App.GenerateReports agr 
			ON i.ReportCode = agr.ReportCode
		INNER JOIN App.TableTypes att
			ON i.EdFactsTableTypeId = att.EdFactsTableTypeId 

	) i2
	ON acs.GenerateReportId = i2.GenerateReportId
		AND acs.OrganizationLevelId = i2.OrganizationLevelId
		AND acs.SubmissionYear = i2.SubmissionYear
		AND acs.TableTypeId = i2.TableTypeId
		AND acs.CategorySetCode = i2.CategorySetCode
	WHEN MATCHED THEN
		UPDATE SET CategorySetName = i2.CategorySetName
				,EdFactsTableTypeGroupId = i2.EdFactsTableTypeGroupId
				,EdFactsTableTypeId = i2.EdFactsTableTypeId
	WHEN NOT MATCHED THEN
		INSERT(
			CategorySetCode
			,CategorySetName
			,EdFactsTableTypeGroupId
			,GenerateReportId
			,OrganizationLevelId
			,SubmissionYear
			,TableTypeId
			,EdFactsTableTypeId
		)
		VALUES(
			i2.CategorySetCode
			,i2.CategorySetName
			,i2.EdFactsTableTypeGroupId
			,i2.GenerateReportId
			,i2.OrganizationLevelId
			,i2.SubmissionYear
			,i2.TableTypeId
			,i2.EdFactsTableTypeId
		);

	MERGE INTO App.Categories ac
	USING (
		SELECT CategoryCode
			,CategoryName
			,EdFactsCategoryId
		FROM inserted
	) i
	ON ac.CategoryCode = i.CategoryCode
		AND ac.EdFactsCategoryId = i.EdFactsCategoryId
	WHEN MATCHED THEN
		UPDATE SET CategoryName = i.CategoryName
	WHEN NOT MATCHED THEN
		INSERT(
			CategoryCode
			,CategoryName
			,EdFactsCategoryId
		)
		VALUES(
			i.CategoryCode
			,i.CategoryName
			,i.EdFactsCategoryId
		);

	MERGE INTO App.CategorySet_Categories acsc
	USING (
		SELECT acs.CategorySetId
			,ac.CategoryId
		FROM inserted i
		INNER JOIN App.GenerateReports agr
			ON i.ReportCode = agr.ReportCode
		INNER JOIN App.TableTypes att
			ON i.TableTypeAbbrv = att.TableTypeAbbrv
		INNER JOIN App.CategorySets acs
			ON agr.GenerateReportId = acs.GenerateReportId
				AND i.OrganizationLevelId = acs.OrganizationLevelId
				AND i.SubmissionYear = acs.SubmissionYear
				AND att.TableTypeId = acs.TableTypeId
				AND i.CategorySetCode = acs.CategorySetCode
		INNER JOIN App.Categories ac
			ON i.CategoryCode = ac.CategoryCode
				AND i.EdFactsCategoryId = ac.EdFactsCategoryId
	) i2
	ON acsc.CategorySetId = i2.CategorySetId
		AND acsc.CategoryId = i2.CategoryId
	WHEN NOT MATCHED THEN
		INSERT (
			CategorySetId
			,CategoryId
		)
		VALUES(
			i2.CategorySetId
			,i2.CategoryId
		);
	
	MERGE INTO App.CategoryOptions aco
	USING (
		SELECT ac.CategoryId
			,i.CategoryOptionCode
			,i.CategoryOptionName
			,acs.CategorySetId
			,i.EdFactsCategoryCodeId
		FROM inserted i
		INNER JOIN App.GenerateReports agr
			ON i.ReportCode = agr.ReportCode
		INNER JOIN App.TableTypes att
			ON i.TableTypeAbbrv = att.TableTypeAbbrv
		INNER JOIN App.CategorySets acs
			ON agr.GenerateReportId = acs.GenerateReportId
				AND i.OrganizationLevelId = acs.OrganizationLevelId
				AND i.SubmissionYear = acs.SubmissionYear
				AND att.TableTypeId = acs.TableTypeId
				AND i.CategorySetCode = acs.CategorySetCode
		INNER JOIN App.Categories ac
			ON i.CategoryCode = ac.CategoryCode
				AND i.EdFactsCategoryId = ac.EdFactsCategoryId
	) i2
	ON aco.CategoryId = i2.CategoryId
		AND aco.CategoryOptionCode = i2.CategoryOptionCode
		AND aco.CategorySetId = i2.CategorySetId 
	WHEN MATCHED THEN 
		UPDATE SET CategoryOptionName = i2.CategoryOptionName 
					,EdFactsCategoryCodeId = i2.EdFactsCategoryCodeId
	WHEN NOT MATCHED THEN
		INSERT(
			CategoryId
			,CategoryOptionCode
			,CategoryOptionName
			,CategorySetId
			,EdFactsCategoryCodeId
		)
		VALUES(
			i2.CategoryId
			,i2.CategoryOptionCode
			,i2.CategoryOptionName
			,i2.CategorySetId
			,i2.EdFactsCategoryCodeId
		);


END
