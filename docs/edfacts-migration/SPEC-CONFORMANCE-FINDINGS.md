# EDFacts Spec-Conformance Findings (SY 2025-26 specs vs Generate fact-side output)

Data year 2027. Every report below is **e2e-green** (expected staging view == report actual). This
pass validates the *second half* of the done-bar: does the report OUTPUT conform to the authoritative
EDFacts SY 2025-26 file spec? Six parallel spec-validation agents downloaded the real `.docx` specs
(v22.0/22.1), extracted the business rules, and checked the fact procs, fact views,
`app.CategoryCodeOptionsByReportAndYear` metadata, and `RDS.ReportEDFactsK12StudentCounts` output.

**Why e2e didn't catch any of this:** the expected view and the report actual both derive from the same
fact objects, so a rule encoded wrong is mirrored on both sides and the test passes. Confirmed across
all six reports — exactly the risk we flagged when the done-bar was redefined.

---

## Headline

- **Permitted-value metadata conforms everywhere.** `app.CategoryCodeOptionsByReportAndYear` matches the
  spec's permitted-value tables for all 18 reports. The value *lists* are right; the problem is which
  values actually get *emitted*.
- **The fact procs/views are mostly spec-correct on population and structure.** Most deviations are
  concentrated, not scattered.
- **The deviations cluster into a small fix surface** — two shared report-layer objects plus a handful of
  fact-view code translations. That is far better than 18 per-report patches.
- **One report family is genuinely blocked on missing source data:** the Migrant reports (FS054/121/145)
  have their defining program dimensions hardcoded to MISSING; fixing them needs source data + SSRD
  mapping, not just SQL edits.

---

## The fix surface (grouped so we fix once, benefit many)

### Bucket A — shared report-layer objects (highest leverage)

**`RDS.Get_CountSQL`** (the dynamic count generator):
- **A1 (HIGH):** ChildCount age-5 never emitted. `AGE05NOTK` (FS089) / `AGE05K` (FS002) are in the fact
  view but dropped from every Age aggregation → Age subtotal fails to reconcile to the education-unit
  total. (FS089/FS002)
- **A2 (MED):** FS002 school-level file leaks `HH` (Homebound/Hospital) and `PPPS` (Parentally-Placed
  Private School) — spec forbids both at school level. Exclusion is applied only in disability-join
  branches, not universally.
- **A3:** FS116 DG648 grade counts all zero (fact has grade; DG849 uses it fine → report-layer bug).

**`RDS.Insert_CountsIntoReportTable`** (zero-fill + permitted-value join):
- **A4 (FS219/221):** zero-fill over-includes all 339 LEAs; only ~95 have Subpart-2 programs and spec says
  non-participating LEAs are *not reported*.
- **A5 (FS219/221):** duplicate zero rows — LEA-grain file but the zero-fill driver joins at school grain,
  so a multi-school LEA gets one duplicate zero row per school per outcome.
- **A6 (FS195):** ~61K spurious `StudentCount=0` school rows (spec: zeros not required for FS195).
- **A7 (FS218/220, latent):** SEA zero-fill branch is a no-op (no ELSE) → passes only because current data
  has no zero-count SEA outcomes.

### Bucket B0 — CORRECTED (2026-07-31): IDEA→WDIS is a NEW-PATH gap, NOT a dim bug. Do NOT change the dim.

**Initial (WRONG) reading:** I claimed `RDS.DimIdeaStatuses.IdeaIndicatorEdFactsCode='IDEA'` was a
systemic bug breaking the disability breakout across ~30 reports. **Retracted.** Nathan pushed back:
the spec-ed/assessment files submit successfully every year in many states — so the translation must
work. It does.

**Corrected understanding:** There are two populate paths, and the translation lives in the legacy one:
- **Legacy `RDS.Get_CountSQL` (production submission path)** DOES translate, per-report, at
  lines 2094–2119: default `IdeaIndicatorEdFactsCode='IDEA' → 'WDIS' ELSE 'WODIS'`; FS118 → `'IDEA' →
  'WDIS' ELSE 'MISSING'` (line 2104-2110); FS175 → via `IdeaIndicatorCode` (line 2096-2102). This is why
  the vetted spec-ed files submit correctly. **The dim value `'IDEA'` is the intended canonical code and
  MUST stay — Get_CountSQL keys on it.**
- **New `RDS.Insert_CountsIntoReportTable` (migration-target path / e2e harness)** joins the dim code to
  the permitted value by exact string equality (`cs.<Dim>EdFactsCode = pv.CategoryOptionCode`, line 128)
  with **no translation** → reports *migrated to the new path* (FS118/FS037/FS195/etc.) get an empty
  `WDIS` bucket. The e2e masks it because the expected staging views read the same untranslated `'IDEA'`.

**Correct fix (contained to new-path reports; dim + legacy + spec-ed untouched):** port the per-report
translation into each new-path report's **fact view** `RDS.vw<Fact>_FactTable_<code>` AND its matching
**expected staging view** `Staging.vw<Fact>_StagingTables_<code>` — a `CASE WHEN IdeaIndicatorEdFactsCode
= 'IDEA' THEN 'WDIS' ELSE <'MISSING'|'WODIS' per Get_CountSQL for that report> END`. Both e2e sides move
together → stays green AND conforms. No dim change, no fact re-populate, no impact on the legacy path or
the vetted spec-ed reports.
- **Nathan's WODIS call (2026-07-31): keep the ELSE branch = `MISSING` for the reports currently being
  fixed** (FS118/FS037/FS195 all permit only WDIS/MISSING anyway — matches Get_CountSQL's FS118 branch).
  WODIS for 032/040/144 is a separate targeted pass mirroring Get_CountSQL's default ELSE `'WODIS'`.
- Best practice going forward: the cleanest long-term fix is to teach `Insert_CountsIntoReportTable` the
  same per-report code translations Get_CountSQL already encodes, so the new path matches the proven
  legacy path centrally rather than per-view. Flag for the shared-layer rework.

### Bucket B — fact-view EdFacts-code → permitted-value translation (small change, high impact)

The report fact views surface a code that doesn't match the report's permitted value, so the whole
category set lands in MISSING:
- **B1:** `IDEA` → **`WDIS`** in `RDS.vwHomeless_FactTable_118` (CSC: 714 MISSING, 0 WDIS) and
  `RDS.vwTitleI_FactTable_037` (CSB: 605 MISSING, 0 WDIS).
- **B2:** `HOMELSENRL` → **`H`** in `RDS.vwTitleI_FactTable_037` (CSE: 765 MISSING, 0 H).
- **B3 (likely same class):** FS141 Disability all-MISSING (WDIS/0) — verify it's the same code mismatch
  vs a source/mapping gap.

### Bucket C — fact-view population / grade filters

- **C1 (FS037, major):** population not restricted to SWP/TAS — the view reads all program types →
  EU Total 1556 vs correct SWP∪TAS = 840. Fix: `WHERE TitleIIndicatorEdFactsCode IN ('SWP','TAS')`.
- **C2 (FS118 & FS134):** grade `PK` dropped instead of mapped to `3TO5NOTK`, `MISSING` grade dropped →
  CSA fails to reconcile to EU Total (FS118 802 vs 997; FS134 1136 vs 1556). FS134 also counts grade-13
  (out-of-school) in TOT but not detail — exclude from the FS134 population.
- **C3 (FS195):** no K-12 grade restriction → PK/ABE/grade-13/NULL over-count; add KG–12+UG filter. Also
  add ≥10 enrolled-days minimum (latent) and a 0/0-no-data guard.
- **C4 (FS054/121/145):** no MEP age/grade collapse (UNDER3/3TO5NOTK/OOS/MISSING) → PK/grade-13 dropped;
  FS121 CSA 1,454 vs Total 1,991 reconciliation break.

### Bucket D — Migrant proc-gap (deep; needs SOURCE DATA + SSRD mapping)

`Staging-to-FactK12StudentCounts_MigrantEducationProgram` hardcodes every MEP program attribute to
`'MISSING'` and `RaceId = -1`:
- **D1:** FS054/121/145 Priority-for-Services, Continuation-of-Services, Services-Type all 100% MISSING.
- **D2:** FS121 Race 100% MISSING (RaceId = -1; the proc never joins the race dim like the TitleIII proc
  does).
- **D3:** FS121 is missing Cat Set D (Disability) and Cat Set E (Mobility/QAD) **entirely** — no rows.
- **D4:** FS145 (MEP *Services*) is semantically empty on the one dimension that is its whole purpose.

These greens are pipeline-valid but semantically empty on their defining dimensions. **Cannot be made
conformant without source data** (a services table, priority/continuation/mobility source columns) and
SSRD mappings.

### Bucket E — TitleIII proc bugs

- **E1 (FS141, severe):** Language cartesian explosion (CSB sums 14,503 vs 315 total). Root cause pinned:
  the Oct proc builds `#vwLanguages` without the `AND ISNULL(Iso6392LanguageMap,'') <> ''` filter that its
  SY sibling proc has → unmapped source language matches every language via the `'MISSING'` fallback.
  Clean fix with a proven in-repo pattern.

### Bucket G — LIVE PIPELINE BREAKAGE (stale column/object refs) — highest operational priority

The full `App.Migrate_Data` / "RDS Migration Wrapper" (the production + UI-driven populate path) is
**currently aborting** on stale references in deployed code. Verified in `app.DataMigrationHistories`
(2026-07-29/30). The e2e greens were produced by running the individual fact procs +
`RDS.Insert_CountsIntoReportTable` + `RunEndToEndTest` *directly*, so they pass while the wrapper fails —
meaning the greens are NOT reproducible through the production path until these are fixed.

- **G1 (Membership):** `RDS Membership failed to run - Invalid column name 'EconomicDisadvantage_StatusEndDate'`
  → FS033/2027 output is **empty (0 rows)**, FS052/2027 is **stale**. The `_StatusEndDate` → `_StatusExitDate`
  rename is the known class (BLOCKED.md). Find the deployed membership proc/view still using the old name.
- **G2:** `RDS Migration Wrapper Datapopulation failed to run - Invalid column name 'DimTitleIStatusId'`.
- **G3:** `RDS Neglected or Delinquent failed to run - Invalid column name 'StatusExitDateNeglectedOrDelinquentId'`.
- **G4:** `RDS Graduates/Completers failed to run - Invalid column name 'ProgramParticipationEndDate'`.
- **G5:** `RDS Assessment failed to run - Invalid object name 'RDS.BridgeK12StudentAssessmentAccommodations'`
  (bridge was renamed to `...AccessibilityFeatures` in 14.1 — a deployed object still references the old name).
- **G6:** `ERROR: Conversion failed when converting the nvarchar value 'MISSING' to data type smallint` — an
  unguarded `CAST(... AS SMALLINT)` on a 'MISSING' sentinel somewhere in the wrapper chain.

These are almost certainly *deploy drift* — the `.sql` sources were fixed but the live DB has older object
versions, and/or a few sources still carry the pre-rename names. A clean `RunDatabaseScripts.ps1 14.1` +
targeted grep for each stale identifier should clear them. **Until G1 clears, FS033 cannot be spec-validated
on 2027 data at all.**

### Bucket F — latent / config / metadata

- **F1:** FS220 metadata has a stray duplicate table type `NDEXITOUTSTATE` alongside spec-correct
  `NDEXITGOUTSTATE` (source of the "16 vs 8" doubling). Delete the stray from
  `app.CategoryCodeOptionsByReportAndYear`.
- **F2:** Title I proc hardcodes `@TitleIDate = '2023-09-01'` for age (wrong for 2027; latent until age
  bands are emitted).
- **F3:** Title I proc homeless-join column bug (line ~245 references
  `title1.ProgramParticipationExitDate` inside the homeless PersonStatus join; should be
  `hmStatus.Homelessness_StatusExitDate`).
- **F4:** ChildCount Developmental-Delay toggle `CHDCTAGEDD` unset → all DD deleted from FS089/FS002.
  Conforms only if the state doesn't define DD.
- **F5:** stray FS089 `ReportYear='2026'` dataset (587 rows) coexists with 2027 — confirm it's not shipped.

---

## Per-report status

| Report | Fact type | e2e | Spec-conformance | Blocking deviations |
|---|---|---|---|---|
| FS032 | Dropout | green | **conforms** (minor) | required zero-subtotal not emitted; unduplication CAN'T-TELL |
| FS195 | Chronic Absenteeism | green | deviates | C3 (grade filter, ≥10-day), A6 (zero-bloat) |
| FS089 | IDEA Child Count (Early Childhood) | green | deviates | A1 (age-5), F4 (DD toggle) |
| FS002 | IDEA Child Count (School Age) | green | deviates | A1 (age-5), A2 (HH/PPPS leak) |
| FS118 | Homeless | green | deviates | B1 (IDEA→WDIS), C2 (grade), anchoring interp |
| FS134 | Title I Part A Participation | green | deviates | C2 (grade + grade-13), F2/F3 |
| FS037 | Title I SWP/TAS | green | deviates | C1 (population), B1, B2 |
| FS054 | MEP Children Served | green | deviates | D1, C4 |
| FS121 | Migratory Children Eligible | green | deviates | D1, D2, D3, C4 |
| FS145 | MEP Services | green | deviates | D1/D4, C4 |
| FS116 | Title III Students Served | green | deviates | A3 (DG648 grade-zero) |
| FS141 | EL Enrolled (October) | green | deviates | E1 (language cartesian), B3 |
| FS218 | N or D in-program (SEA) | green | conforms (A7 latent) | — |
| FS219 | N or D in-program (LEA) | green | deviates | A4, A5 |
| FS220 | N or D exit (SEA) | green | deviates | F1 (metadata), A7 latent |
| FS221 | N or D exit (LEA) | green | deviates | A4, A5 |
| FS052 | Membership | green | **conforms** (code) | 2027 output STALE (G1) — re-run needed, no code change |
| FS033 | Membership FRL | green* | deviates | G1 (2027 EMPTY), FS033-Rule7 (DG565 total excludes direct-cert) |

\* FS033 "green" was a prior run; 2027 output is currently empty (see G1).

---

## Decisions needed from Nathan (interpretation calls, spec is silent or config-dependent)

1. **FS118 temporal anchoring.** Last session I anchored IDEA/EL/Migrant dims on the homelessness-status
   start date. The spec anchors *only* Primary Nighttime Residence to the identification date and gives no
   temporal rule for the other dims → my anchor risks under-counting. Relax to enrollment-window overlap?
2. **MEP age/grade collapse (C4).** Should the UNDER3/3TO5NOTK/OOS/MISSING derivation live in the staging
   proc or the report mapping? (Validator recommends the proc.)
3. **Developmental Delay (F4).** Does the target state define DD? If yes, the unset `CHDCTAGEDD` toggle
   silently under-reports an entire category.
4. **Migrant source data (Bucket D).** Do we have source data for MEP Priority-for-Services,
   Continuation-of-Services, Services-Type, and 12-month Mobility/QAD? If not, FS054/145 cannot be made
   spec-conformant with the current dataset, and FS121 CSD/CSE stay empty. This determines whether the
   Migrant family is "done-able" now or must be logged as source-blocked.
5. **Zero-count policy.** Zero-count rules differ per report (some required at SEA, some not required at
   LEA, FS195 not required at all). Confirm the target for the shared zero-fill rework so we don't trade
   one over/under-emission for another.
6. **Dropout exit-code completeness (FS032).** Confirm all dropout-equivalent exit scenarios map to CEDS
   `01927` in `SourceSystemReferenceData` (else undercount).
7. **FS033 direct-cert routing (FS033-Rule7).** Get_CountSQL routes each FRL student to *either*
   `DIRECTCERT` *or* `LUNCHFREERED` (mutually exclusive), so the DG565 LUNCHFREERED total excludes
   direct-cert students and CSA(FL+RPL) ≠ total. Spec §2.5: DG565 total *includes* direct-cert students and
   Category Set A must sum to the total; DG813 ⊆ DG565. Is the exclusion an intentional state policy or a
   bug? (Verified on 2025: `LF_CSA = LF_TOT + DC_TOT` exactly.)
8. **FS052 membership date.** Toggle `MEMBERDTE` = 10/21 → 2026-10-21 for SY2027, three weeks past Oct 1.
   Confirm that's the state's official / "closest school day to Oct 1" count date.

## Note on the two populate paths (architecture clarification)

The FS052/FS033 validator found those two use the **legacy** path
(`RDS.Create_Reports` → `RDS.Create_ReportData` → `RDS.Get_CountSQL` + `RDS.Create_ReportData_ZeroCounts`),
while the reports I greened via `RunEndToEndTest` use `RDS.Insert_CountsIntoReportTable`. Some Get_CountSQL
findings (age-5, HH/PPPS) and the Insert_CountsIntoReportTable zero-fill findings may therefore live on
different paths than assumed. **Before reworking either shared object, confirm which populate path each
target report actually uses in production** so a fix lands where the report is really generated.
