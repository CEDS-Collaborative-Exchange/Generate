SET NOCOUNT ON;
DECLARE @from int = 2026, @to int = 2027;
IF EXISTS (SELECT 1 FROM App.CategorySets WHERE SubmissionYear = @to)
BEGIN
    PRINT 'Metadata already present for target year ' + CAST(@to AS varchar) + ' - skipping clone.';
    RETURN;
END

IF OBJECT_ID('tempdb..#map') IS NOT NULL DROP TABLE #map;
CREATE TABLE #map (oldId int, newId int);

MERGE App.CategorySets AS tgt
USING (SELECT * FROM App.CategorySets WHERE SubmissionYear = @from) AS src
ON 1 = 0
WHEN NOT MATCHED THEN
  INSERT (CategorySetCode, CategorySetName, CategorySetSequence, EdFactsTableTypeGroupId, ExcludeOnFilter,
          GenerateReportId, IncludeOnFilter, OrganizationLevelId, SubmissionYear, TableTypeId, ViewDefinition, EdFactsTableTypeId)
  VALUES (src.CategorySetCode, src.CategorySetName, src.CategorySetSequence, src.EdFactsTableTypeGroupId, src.ExcludeOnFilter,
          src.GenerateReportId, src.IncludeOnFilter, src.OrganizationLevelId, @to, src.TableTypeId, src.ViewDefinition, src.EdFactsTableTypeId)
  OUTPUT src.CategorySetId, inserted.CategorySetId INTO #map(oldId, newId);

DECLARE @cs int = @@ROWCOUNT;

INSERT INTO App.CategorySet_Categories (CategorySetId, CategoryId, GenerateReportDisplayTypeID)
SELECT m.newId, csc.CategoryId, csc.GenerateReportDisplayTypeID
FROM App.CategorySet_Categories csc JOIN #map m ON csc.CategorySetId = m.oldId;
DECLARE @csc int = @@ROWCOUNT;

INSERT INTO App.CategoryOptions (CategoryId, CategoryOptionCode, CategoryOptionName, CategoryOptionSequence, CategorySetId, EdFactsCategoryCodeId)
SELECT co.CategoryId, co.CategoryOptionCode, co.CategoryOptionName, co.CategoryOptionSequence, m.newId, co.EdFactsCategoryCodeId
FROM App.CategoryOptions co JOIN #map m ON co.CategorySetId = m.oldId;
DECLARE @co int = @@ROWCOUNT;

PRINT 'Cloned ' + CAST(@from AS varchar) + ' -> ' + CAST(@to AS varchar)
    + ': CategorySets=' + CAST(@cs AS varchar) + ', CategorySet_Categories=' + CAST(@csc AS varchar) + ', CategoryOptions=' + CAST(@co AS varchar);
