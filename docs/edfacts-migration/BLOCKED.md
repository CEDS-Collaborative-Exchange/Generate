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

---

## Assessment fact layer — RESOLVED (facts populate); accessibility-features bridge DEFERRED

**Status:** fact side FIXED — `RDS.FactK12StudentAssessments` now populates (3144 rows for 2027). Packaged in 14.1.

**Root cause (was blocking ALL assessment reports):** the wrapper `App.Wrapper_Migrate_Assessment_to_RDS` (step 8 `rds.Empty_RDS 'assessment'` and step 9 the fact proc) referenced `RDS.BridgeK12StudentAssessmentAccommodations`, which the **14.0 CEDS rebuild renamed/redesigned** into the granular `RDS.BridgeK12StudentAssessmentAccessibilityFeatures` (per-feature columns: Braille, Calculator, Break, ReadAloud, ExtendedTime, …). `Empty_RDS` died on the missing table before the fact proc ever ran → 0 facts, swallowed by the wrapper's TRY/CATCH into `App.DataMigrationHistories`.

**Fixes (committed, in 14.1):**
1. `RDS.Empty_RDS` — repointed the assessment-bridge cleanup DELETE to `BridgeK12StudentAssessmentAccessibilityFeatures`.
2. `Staging.[Staging-to-FactK12StudentAssessment]` (the SINGULAR proc the wrapper actually calls — line 101) — repointed the cleanup DELETE (line 631) to the new bridge; the **core `FactK12StudentAssessments` INSERT now runs and populates**.

**Deferred (logged, non-blocking):** the accommodations→accessibility-features **bridge population** block in the fact proc (old `RDS.vwAssessmentAccommodations` / `DimAssessmentAccommodationId` model) is disabled with a `/* … */` guard. It needs a full remap onto the granular AccessibilityFeatures model. The primary assessment reports are driven by `FactK12StudentAssessments.AssessmentCount`, not by this bridge, so those reports are unblocked.

**Note / correction:** the file `Staging-to-FactK12StudentCounts_Assessments.StoredProcedure.sql` defines the PLURAL proc `Staging-to-FactK12StudentAssessments`, which the wrapper does **not** call — it is legacy/unused on the assessment path. Its column-name fixes were committed as a harmless canonical improvement but it is intentionally NOT in 14.1.
