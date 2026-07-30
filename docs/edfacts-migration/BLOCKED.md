# Blocked / needs-review EDFacts files

---

## SYSTEMIC FIX (2026-07-30): RDS.Insert_CountsIntoReportTable pivot fan-out — RESOLVED

**Impact:** unblocks the report-populator's dimension-pivot path for every count report whose CategorySetCode repeats across multiple org levels and/or table types (i.e. essentially all multi-level dimensional EDFacts count reports). Previously only Total-only / single-level reports (222, 226, 218) populated; any dimensional multi-level report died with `Msg 1011 - The correlation name 'pv<CATEGORY>' is specified multiple times in a FROM clause`.

**Root cause:** the populator built one pivot subquery alias `pv<CategoryCode>` per category via `STRING_AGG`, but its FROM `LEFT JOIN app.GenerateReport_OrganizationLevels grol` (and `...GenerateReport_TableType grtt`) fanned every category set across *all* of the report's org levels / table types. So a set with its own `OrganizationLevelId` still produced one row per report level → the same category (e.g. `AGEPK` on FS194's `CSA` set, which exists at both SEA and LEA) appeared multiple times in a single group → duplicate pivot aliases.

**Fix (14.1, `RDS.Insert_CountsIntoReportTable`):** join `grol`/`grtt` only when the category set pins no level/table type of its own (`AND cs.OrganizationLevelId IS NULL` / `AND cs.TableTypeId IS NULL`), and key `aol`/`att` on `ISNULL(cs.<x>, g<xx>.<x>)`. This matches how `Staging.RunEndToEndTest` keys the expected side (strictly `cs.OrganizationLevelId`). Verified: FS194 no longer errors; regression-safe — FS226 (179), FS222 (172), FS218 (7) still populate identically.

### FS052 (Membership by Grade/Race/Sex) — GREEN ✅ (13,028 test cases, all pass)
First **dimensional** report greened end-to-end (proves the populator fix + the per-report view pattern for multi-dimension reports, not just Total-only). Steps: (1) populator pivot fix (above); (2) surfaced the per-dimension EdFacts-code columns on `RDS.vwMembership_FactTable_052` (`GradeLevelEdFactsCode`, `RaceEdFactsCode`, `SexEdFactsCode` — the last needed `Demo.SexEdFactsCode` added to `debug.vwMembership_FactTable`); (3) built the expected-side `Staging.vwMembership_StagingTables_052` mirroring the membership fact proc exactly. Key gotchas that mattered for exact match: the EdFacts-code columns live on the dim **tables** (`RDS.DimRaces/DimGradeLevels/DimK12Demographics`) while the `Map` columns are on the `vwDim*` views → two-step join per dimension; race is unduplicated (`RDS.vwUnduplicatedRaceMap` + Hispanic/Latino override, LEFT-joined with the -1 NA member so unmatched race still counts); and the membership proc does **NOT** filter reported-federally or school type — the only school filter the FS052 fact view adds is `SchoolOperationalStatus IN ('Open','New')` (raw staging values are literally 'Open'/'New'). Packaged in 14.1.

### FS194 (Homeless, by Age) — partially converted, NOT yet green
- Fact/report now populate without error via the fixed populator. Added `f.AgeEdFactsCode` to `RDS.vwHomeless_FactTable_194` (the populator joins the report's permitted Age values on `cs.AgeEdFactsCode`; the view previously exposed only `BirthDate`) — clears the `Msg 207` invalid-column error.
- **Remaining:** the report populates 1300 LEA rows but all `StudentCount = 0`, and no SEA rows — the fact's `AgeEdFactsCode` values do not align with the report's permitted Age category codes (AGEPK, AGE5, …), so the pivot join matches nothing. Needs: (1) reconcile the homeless age-group EdFacts codes between `debug.vwHomeless_FactTable.AgeEdFactsCode` and the report's permitted `app.CategoryCodeOptionsByReportAndYear` Age values for 2027; (2) confirm the SEA `CSA` set is present/'`cs.OrganizationLevelId`'d for SEA; (3) build the expected-side `Staging.vwHomeless_StagingTables_194` (StudentIdentifierState + LEAIdentifierSeaAccountability + `Age` = the EdFacts age-group code computed from BirthDate via `RDS.DimAges`, mirroring the homeless fact age-as-of date) for the e2e test. Deferred to keep momentum.


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

### Full diagnosis (2026-07-30) — the report *actual* works; the *expected* oracle is blocked by a dimensional-model inconsistency

The FS218 **fact/report actual** side is fully working now:
- `RDS.vwNeglectedOrDelinquent_FactTable_218` returns 412 rows; `RDS.Insert_CountsIntoReportTable '218','2027','K12StudentStudentIdentifierState',1,0` populates `RDS.ReportEDFactsK12StudentCounts` with 7 SEA-level rows, one per outcome-type EdFacts code: EARNCRE=12, EARNDIPL=10, EARNGED=8, ENROLLGED=9, ENROLLTRAIN=8, OBTAINEMP=12, POSTSEC=11.
- FS218 metadata (2027): one CategorySet `CSA` at `sea` level, one dimension `EdFactsAcademicOrCareerAndTechnicalOutcomeType`; report table `ReportEDFactsK12StudentCounts`, count `StudentCount`.

The harness (`Staging.RunEndToEndTest`) needs a `Staging.vwNeglectedOrDelinquent_StagingTables_218` exposing `StudentIdentifierState` + a column literally named `EdFactsAcademicOrCareerAndTechnicalOutcomeType` holding those same EdFacts codes, producing the same distinct-student counts.

**Why the expected view can't be faithfully reconstructed yet — the model is internally inconsistent:**
- `debug.vwNeglectedOrDelinquent_FactTable` reads the outcome code as `NorD.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode` from **`RDS.DimNorDStatuses`** (joined via `Fact.NorDStatusId`).
- But the fact proc `Staging-to-FactK12StudentCounts_NeglectedOrDelinquent` sets `NOrDStatusId` from `RDS.vwDimNOrDStatuses` joined on **subpart + academic achievement/outcome *indicators*** (lines ~245-254) — NOT on the outcome *type*. And `vwDimNOrDStatuses` does not expose any `EdFactsAcademicOrCareerAndTechnicalOutcomeType*` column at all.
- The proc maps the outcome type/exit type to a *separate* dim, `CTEOutcomeIndicatorId` via `RDS.vwDimCteOutcomeIndicators` (lines ~256-260) — but **`RDS.vwDimCteOutcomeIndicators` returns zero rows** (unpopulated), so `CTEOutcomeIndicatorId` is always -1.
- Net: the raw staging `Staging.ProgramParticipationNOrD` *does* carry `EdFactsAcademicOrCareerAndTechnicalOutcomeType`/`...ExitType`, but there is no populated, consistent dimension path from that raw value to the EdFacts code the report actually shows. The actual codes appear to ride on `DimNorDStatuses` rows whose key encodes subpart+indicators, conflating two concepts.

**To finish (needs a design decision):** either (a) populate/repair `RDS.DimCteOutcomeIndicators` + `vwDimCteOutcomeIndicators` and have the proc + report read the outcome type from it consistently, or (b) confirm `DimNorDStatuses` is intended to carry the outcome type and expose a `...OutcomeType*Map` on `vwDimNOrDStatuses` so the staging oracle can join raw `ProgramParticipationNOrD.EdFactsAcademicOrCareerAndTechnicalOutcomeType` → EdFacts code the same way the fact does. Once the raw→code path is single-sourced, the `_218/_219/_220/_221` expected views are a straightforward mirror (join raw `ProgramParticipationNOrD` + enrollment/org, filter NorDStatus=1 + subpart='Subpart1' + outcome code present, expose `StudentIdentifierState` + `EdFactsAcademicOrCareerAndTechnicalOutcomeType`).

This is a warehouse-model question (which dim owns the CTE/academic outcome type), so it is logged for review rather than guessed. Also still applies: the existing `_C218…_C221` views use the misspelled `NeglectedOrDelingquentProgramEnrollmentSubpartEdFactsCode` and `ProgramParticipationBegin/EndDate` (now `Start/ExitDate`) and are named `_C###` instead of the harness's `_###`.

---

## Assessment fact layer — RESOLVED (facts populate); accessibility-features bridge DEFERRED

**Status:** fact side FIXED — `RDS.FactK12StudentAssessments` now populates (3144 rows for 2027). Packaged in 14.1.

**Root cause (was blocking ALL assessment reports):** the wrapper `App.Wrapper_Migrate_Assessment_to_RDS` (step 8 `rds.Empty_RDS 'assessment'` and step 9 the fact proc) referenced `RDS.BridgeK12StudentAssessmentAccommodations`, which the **14.0 CEDS rebuild renamed/redesigned** into the granular `RDS.BridgeK12StudentAssessmentAccessibilityFeatures` (per-feature columns: Braille, Calculator, Break, ReadAloud, ExtendedTime, …). `Empty_RDS` died on the missing table before the fact proc ever ran → 0 facts, swallowed by the wrapper's TRY/CATCH into `App.DataMigrationHistories`.

**Fixes (committed, in 14.1):**
1. `RDS.Empty_RDS` — repointed the assessment-bridge cleanup DELETE to `BridgeK12StudentAssessmentAccessibilityFeatures`.
2. `Staging.[Staging-to-FactK12StudentAssessment]` (the SINGULAR proc the wrapper actually calls — line 101) — repointed the cleanup DELETE (line 631) to the new bridge; the **core `FactK12StudentAssessments` INSERT now runs and populates**.

**Deferred (logged, non-blocking):** the accommodations→accessibility-features **bridge population** block in the fact proc (old `RDS.vwAssessmentAccommodations` / `DimAssessmentAccommodationId` model) is disabled with a `/* … */` guard. It needs a full remap onto the granular AccessibilityFeatures model. The primary assessment reports are driven by `FactK12StudentAssessments.AssessmentCount`, not by this bridge, so those reports are unblocked.

**Note / correction:** the file `Staging-to-FactK12StudentCounts_Assessments.StoredProcedure.sql` defines the PLURAL proc `Staging-to-FactK12StudentAssessments`, which the wrapper does **not** call — it is legacy/unused on the assessment path. Its column-name fixes were committed as a harmless canonical improvement but it is intentionally NOT in 14.1.
