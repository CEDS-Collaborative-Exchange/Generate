# Blocked / needs-review EDFacts files

Files where I hit a problem I couldn't fully resolve autonomously and moved on (per instruction). Each entry: file, symptom, what I tried/fixed, and what remains.

---

## FS218 / FS219 / FS220 / FS221 (and FS119, FS127) — Neglected or Delinquent group

**Status:** fact side FIXED (facts now populate, 1682 NorD facts for 2027; `RDS.vwNeglectedOrDelinquent_FactTable_218` = 412 rows). Staging/test side still blocked.

**Fixes already made (committed, packaged in 14.1):**
1. `RDS.FactK12StudentCounts.CteOutcomeIndicatorId` column was dropped by the 14.0 rebuild but the NorD fact proc inserts it → added back with `DEFAULT(-1)` in `14.1/RDS.TableChanges.sql`. This also unbroke `debug.vwNeglectedOrDelinquent_FactTable` (it joins that column).
2. `Staging-to-FactK12StudentCounts_NeglectedOrDelinquent`: `CAST(... AS SMALLINT)` on NorD indicator columns failed on the text sentinel `'MISSING'` → changed 6 casts to `TRY_CAST`.
3. Same proc inserted `StatusExitDateNeglectedOrDelinquentId` but the fact table column is `StatusEndDateNeglectedOrDelinquentId` → renamed 4 refs Exit→End.

**What remains (the block):**
- The report staging views `Staging.vwNeglectedOrDelinquent_StagingTables_C218/C219/220/C221` (and the `_218` copy I created) fail to compile — they reference columns that the current `debug.vwNeglectedOrDelinquent_StagingTables` does not expose (Msg 207 at several columns, e.g. the SELECT/WHERE columns `NeglectedOrDelinquentProgramEnrollmentSubpart`, `NeglectedOrDelingquentProgramEnrollmentSubpartEdFactsCode` (note the misspelling "Delingquent"), the academic/CTE outcome columns). The base `debug.vwNeglectedOrDelinquent_StagingTables` and the report views are out of sync after the 14.x changes.
- Also: the staging report views are inconsistently named (`_C218`, `_C219`, `_220`, `_C221`) vs the harness's expected `_218/_219/_220/_221`.

**Decision/feedback needed:** reconcile `debug.vwNeglectedOrDelinquent_StagingTables` with the columns the report staging views expect (or update the report views to the current column names), then create correctly-named `_218/_219/_220/_221` expected views mirroring the (now-working) NorD fact migration. This is a self-contained reconciliation but non-trivial (subpart + academic/CTE outcome dimensions, misspelled column names in the existing views). Deferred to keep momentum on other files.
