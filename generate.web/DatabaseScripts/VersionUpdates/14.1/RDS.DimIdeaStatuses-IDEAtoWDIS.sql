/**********************************************************************
  14.1 - Correct RDS.DimIdeaStatuses.IdeaIndicatorEdFactsCode: 'IDEA' -> 'WDIS'.

  DATA-PRESERVING UPGRADE: strictly an UPDATE of an existing reference-data
  column value. No drop, truncate, or rebuild -- surrogate keys
  (DimIdeaStatusId) are untouched, so all Fact* rows that reference this dim
  keep their foreign keys.

  Why: 'IDEA' was never a valid EDFacts permitted value. Every EDFacts count
  report that breaks out by IDEA disability status uses the permitted value
  'WDIS' (children with disability). The legacy dynamic-SQL path
  (RDS.Get_CountSQL) translated the dim's 'IDEA' -> 'WDIS' per report, so
  production submissions were correct; but the new view-based migration path
  (RDS.Insert_CountsIntoReportTable) joins the dim's EdFactsCode directly to the
  report's permitted value, so 'IDEA' never matched 'WDIS' and the disability
  breakout came out empty on the new path.

  Storing the correct EdFacts value ('WDIS') in the dim fixes the new path AND
  keeps the legacy path working -- RDS.Get_CountSQL's 13 references were updated
  in lockstep from = 'IDEA' to = 'WDIS' (same version).

  Idempotent: re-running is a no-op once no 'IDEA' rows remain.
************************************************************************/

UPDATE RDS.DimIdeaStatuses
SET IdeaIndicatorEdFactsCode = 'WDIS'
WHERE IdeaIndicatorEdFactsCode = 'IDEA';
