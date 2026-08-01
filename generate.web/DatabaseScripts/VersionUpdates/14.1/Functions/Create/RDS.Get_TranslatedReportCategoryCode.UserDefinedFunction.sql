-- RDS.Get_TranslatedReportCategoryCode
-- Central, data-driven translation of a fact/dim EDFacts code into a report's permitted
-- CategoryOptionCode, backed by App.EdFactsCategoryCodeMap. Used by the new view-based report path
-- (RDS.Insert_CountsIntoReportTable, actual side) and the e2e harness (Staging.RunEndToEndTest,
-- expected side) so both sides land on the same permitted value -- replacing the per-report inline
-- CASE translations that the legacy dynamic-SQL engine RDS.Get_CountSQL hard-codes.
--
-- Resolution order: a row whose ReportCode matches wins over a NULL (all-reports) row for the same
-- (CategoryCode, SourceEdFactsCode). When no row matches, the source code passes through unchanged,
-- so codes that already equal their permitted value cost nothing and need no map entry (the function
-- is a no-op until the map is seeded -- a behavior-preserving rollout).

CREATE FUNCTION [RDS].[Get_TranslatedReportCategoryCode]
(
	@ReportCode VARCHAR(10),
	@CategoryCode VARCHAR(50),
	@SourceEdFactsCode VARCHAR(50)
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @Target VARCHAR(50);

	SELECT TOP (1) @Target = m.TargetCategoryOptionCode
	FROM App.EdFactsCategoryCodeMap m
	WHERE m.CategoryCode = @CategoryCode
		AND m.SourceEdFactsCode = @SourceEdFactsCode
		AND (m.ReportCode = @ReportCode OR m.ReportCode IS NULL)
	ORDER BY CASE WHEN m.ReportCode = @ReportCode THEN 0 ELSE 1 END;  -- report-specific beats all-reports

	RETURN ISNULL(@Target, @SourceEdFactsCode);  -- passthrough when unmapped
END
