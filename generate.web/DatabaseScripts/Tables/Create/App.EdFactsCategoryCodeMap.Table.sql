-- App.EdFactsCategoryCodeMap
-- The single, data-driven "one shared place" that translates a fact/dim EDFacts code into a
-- report's permitted CategoryOptionCode for the NEW view-based report path
-- (RDS.Insert_CountsIntoReportTable + Staging.RunEndToEndTest).
--
-- Background: the legacy engine RDS.Get_CountSQL applies these translations inline via per-report
-- dynamic-SQL CASE expressions (e.g. IdeaIndicator 'IDEA' -> 'WDIS', Section 504 'SECTION504' ->
-- 'DISAB504STAT', homeless -> 'H' for FS037, 'NLEP'/'NoEdFactsEquivalent' -> 'MISSING'). The new
-- path joins the fact view's <Dim>EdFactsCode directly to the permitted value, so it needs those
-- same translations. This table holds them once; both the actual side (Insert) and the expected
-- side (RunEndToEndTest) apply them via RDS.Get_TranslatedReportCategoryCode, so they stay matched.
--
-- Resolution: a row with a specific ReportCode wins over a NULL ReportCode (all-reports) row for the
-- same (CategoryCode, SourceEdFactsCode). No matching row => the source code passes through unchanged
-- (so codes that already equal their permitted value need no entry).

CREATE TABLE [App].[EdFactsCategoryCodeMap](
	[EdFactsCategoryCodeMapId] [int] IDENTITY(1,1) NOT NULL,
	[ReportCode] [varchar](10) NULL,                    -- NULL = applies to every report that uses this category
	[CategoryCode] [varchar](50) NOT NULL,
	[SourceEdFactsCode] [varchar](50) NOT NULL,         -- the value the fact/staging view surfaces
	[TargetCategoryOptionCode] [varchar](50) NOT NULL,  -- the report's permitted CategoryOptionCode
 CONSTRAINT [PK_EdFactsCategoryCodeMap] PRIMARY KEY CLUSTERED
(
	[EdFactsCategoryCodeMapId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Lookup index for the translation function (report-or-all, by category + source code).
CREATE NONCLUSTERED INDEX [IX_EdFactsCategoryCodeMap_Lookup]
	ON [App].[EdFactsCategoryCodeMap] ([CategoryCode], [SourceEdFactsCode], [ReportCode])
	INCLUDE ([TargetCategoryOptionCode])
GO
