# Open questions for Nathan — EDFacts 94-file green initiative

Companion to `BLOCKED.md` (technical blockers). **This file holds only decisions that require Nathan.**
Each entry: what I found → why I stopped → options → my recommendation.

Goal being driven: *full end-to-end support + e2e testing GREEN on all 94 active EDFacts file specs.*
Brain task: `6cafe950`. Branch `feature/finish-generate`. Data year **2027**.

---

## Q1 (BLOCKER, highest value) — How should the 38 unregistered specs be registered in `App.EtlMetadata`?

**What I found.** `App.EtlMetadata` is **not** a file-spec registry. It is a **CEDS element → destination mapping**
table (2,939 rows). Each row is one CEDS element with its `Destination_Staging_Table/Column`,
`Destination_RDS_Dimension/Fact/Report` columns, tagged by `EDFacts_File_Spec_Number`
(comma-separated) for the specs that use it.

Registering a spec therefore means adding its **element-level rows**, not one row per spec:

| | element rows |
|---|---|
| FS178 / FS175 / FS185 (largest) | 127–131 each |
| FS029 | 112 |
| FS002 / FS089 | 78–79 |
| FS132 / FS131 (smallest) | 4–5 |

38 specs × ~50 avg ≈ **1,000–1,900 accurate element→destination rows.**

**Why I stopped.** There is no source I can derive them from accurately:
- `App.EtlMetadata` and `App.GenerateStagingColumns` are **seeded from the external EDFacts/CEDS
  metadata database** (see the CIID-9061 column-drift defect note). No seed script for the *content*
  exists in the repo — only the `14.0_prerelease` column-name patches.
- `app.vwStagingRelationships` (independent of EtlMetadata, built from `GenerateStagingTables/Columns`)
  has staging columns for **only 30 report codes — none of the 38.**
  Verified: FS002=264 cols, FS089=264, FS052=162, but 082/113/119/165/218/223/054/150 = **0**.

Hand-authoring ~1,500 CEDS element mappings would be fabrication, and per **ADR-15** wrong mappings
corrupt the AI ETL Developer's required-column list and the mapping coverage preflight (false
"not ready" verdicts). So I did not guess.

**What I *can* derive accurately (already done):** the **fact type per spec**, from
`App.GenerateReports → App.GenerateReport_FactType → rds.DimFactTypes`:

| fact type | specs |
|---|---|
| cte | 082, 083, 154, 155, 156, 158, 169 |
| directory | 035, 190, 193, 198, 207, 223 |
| neglectedordelinquent | 119, 127, 218, 219, 220, 221 |
| assessment | 113, 125, 142, 224, 225 |
| migranteducationprogram | 054, 121, 145 |
| schoolperformanceindicators | 205 · titleI 222 · titleIIIELSY 210 · immigrant 165 · membership 226 |

**Options**
- **(A) Get the upstream source.** Point me at the external EDFacts/CEDS metadata database (or a CEDS
  Connect export per file spec — CEDS Connect publishes the element set for each EDFacts file). I then
  generate the registration mechanically and accurately, as a `VersionUpdates` script so it survives reseed.
- **(B) Fact-type-level registration.** Tag each unregistered spec with the element rows already
  registered for its fact-type siblings. Mechanical and cheap — but **over-tags**: FS082 and FS083 (both
  CTE) genuinely need different element subsets, so the coverage preflight would demand more than a spec
  actually requires and produce false "not ready" warnings.
- **(C) Register the identifier/dimension backbone only.** Tag just the org/student/year business-key
  elements each spec certainly needs; leave spec-specific breakout elements out until the source arrives.
  Safe but incomplete.
- **(D) Defer.** Keep the 38 out of `EtlMetadata`; they already generate reports without it.
  `EtlMetadata` only drives the *AI ETL Developer's* guidance, not report generation.

**My recommendation: (A), falling back to (C).** (A) is the only path that yields correct data. If the
upstream isn't readily available, (C) is safe and unblocks the file-spec dropdown without poisoning the
coverage preflight. I recommend **against (B)** — silent over-tagging is worse than absence because it
looks authoritative.

**Question:** Which option — and if (A), where do I get the external metadata / CEDS Connect export?

---

## Q2 — Is the 94 denominator right, and are the 13 retired specs truly out of scope?

Reconciliation across Generate (report codes + tests) found **107** distinct FS numbers:
- **56** registered in `App.EtlMetadata`
- **38** active but unregistered (Q1)
- **13** inactive/retired, absent from metadata — presumed correctly excluded:
  `FS036, FS065, FS167, FS192, FS200, FS201, FS202, FS209, FS213, FS214, FS215, FS216, FS217`

56 + 38 = **94 active**, which matches your "94 EDFacts files."

**Caveat:** my "active" proxy is `App.GenerateReports.IsActive=1` + a 3-digit report code — *not* ED's
published file-spec index for the submission year. A file ED publishes that Generate has **no report code
for at all** would be invisible to this count.

**Question:** Confirm 94 is the target set, and confirm the 13 retired are out of scope. If you have ED's
official SY2026-27 file-spec list, I'll reconcile against it to be certain nothing is missing entirely.

---

## Q3 (approval needed) — Vetted IDEA staff SEA totals look wrong. May I fix?

`FS070/FS099/FS112` fail **only at SEA level**, with expected far below actual:

| test case | expected | actual |
|---|---|---|
| TOT SEA Match All | 2 | 226 |
| ST2 SEA (AGE5KTO21) | 1 | 155 |
| ST1 SEA (SPEDTCHFULCRT_1) | 2 | 130 |

LEA-level rows **pass** (2 vs 2, 1 vs 1). The actual/expected ratio ≈ the LEA count, which suggests the
report **sums a per-LEA fan-out into the SEA total** while the test counts distinct staff once.

This matters beyond the test: **if the report is wrong, Generate would submit inflated SEA staff totals to
ED.** But staff is in your vetted family ("spec ed child count, staff, spec exit, assessments … don't
change their logic without asking"), so I have an agent diagnosing **read-only** and will not touch it.

**Question:** If the diagnosis confirms a real report-side defect (not a test artifact), do I have approval
to fix the SEA aggregation in the vetted staff path?

---

## Q4 (approval needed) — `FS009_TestCase` (vetted spec-exit) has a blocking bug

`App.FS009_TestCase @SchoolYear=2027` fails at **line 1501** with
`Column name or number of supplied values does not match table definition` — an INSERT whose column list
doesn't match its target. The test cannot run at all until fixed.

Vetted family → logged, not touched. (Note: the deployed proc is an `ALTER PROCEDURE`; I briefly dropped
and restored it during triage — it is back in place and unchanged.)

**Question:** Approval to fix the INSERT column-list mismatch in `FS009_TestCase`?

---

## Q5 — Residual assessment failures: real discrepancies or acceptable tolerance?

After the non-ceds regen + the `FS17x` perf-level join fix (commit `462e36eb`), all six assessment specs
self-validate, but each retains a handful of genuine mismatches:

| spec | pass | fail |
|---|---|---|
| FS175 | 1,379 | 10 |
| FS178 | 1,267 | 8 |
| FS179 | 521 | 4 |
| FS185 | 617 | 7 |
| FS188 | 693 | 8 |
| FS189 | 375 | 3 |

~0.7% failure rate. Assessments are vetted, so I have not investigated the individual rows.

**Question:** Do you want these chased to zero (they may indicate real edge-case defects), or is a small
residual acceptable for synthetic data?

---

## Q6 — Report-table row counts look inflated; confirm a clean regen is safe

2027 report population currently: StudentCounts **32 codes / 692,282 rows**, Disciplines **8 / 46,362**,
Assessments 6 / 86,118, Staff 6 / 4,140, OrgCounts 1 / 3,037.

StudentCounts and Disciplines look inflated relative to earlier clean runs (discipline was 13,191 across
7 codes). Cause: several regeneration passes, and `RDS.Create_ReportData` **was** non-idempotent until
commit `a88fabf3`. A clean `Empty_Reports → Create_Reports` pass per family should settle them.

Also learned the hard way: **locking *all* report codes breaks the run** — retired codes' `Get_CountSQL`
references dropped columns/objects (`SeaIdrules`, `LeaIdentifierState`, `rds.DimEnrollmentStatuses`,
`TitleISchoolStatusCode`, `ContinuationOfServicesReasonEdFactsCode`, `DimStudentId`) and abort the whole
family. Curated locks (in-scope codes only) run clean.

**Question:** Confirm I should run the clean regen (it replaces current report rows for 2027 — no fact
data touched). I've held off while diagnostic agents are reading the current data.

---

## Q7 — 26 in-scope specs have **no e2e test at all**

Of the 56 registered specs, 26 have no test proc:
`FS039, FS045, FS050, FS059, FS067, FS086, FS126, FS129, FS130, FS131, FS132, FS137, FS138, FS139,
FS150, FS151, FS160, FS163, FS170, FS196, FS197, FS199, FS203, FS206, FS211, FS212`
(FS212 has a `dbo.FS212_TestCase` that is simply unregistered — a wire-up, not new work.)

Plus most of the 38 unregistered specs also lack tests. Writing an e2e test per spec is substantial,
repeatable work well suited to the `etl-validator` / test-authoring agents.

**Question:** Priority order — (a) fix the ~13 existing-but-failing tests first, (b) author the ~26 missing
tests for already-registered specs, or (c) drive breadth first (one smoke-level test per spec across all 94,
then deepen)? My recommendation: **(a) then (c)** — fixing failures protects submission correctness, and a
breadth pass tells us the true size of the remaining gap.

---

## Running issue log (no decision needed — recorded for traceability)

- **Non-ceds `_1` convention.** Staging carries source codes with a `_1` suffix; the warehouse/report
  carries translated CEDS codes. Test procs must join on the `Map` column or `replace(...,'_1','')`.
  This was the root cause of the FS17x "NO TEST RESULTS" (fixed, `462e36eb`).
- **Deployed-vs-file drift.** `FS052`/`FS194` failed with errors already corrected in their `.sql` files —
  the *deployed* procs were stale. Redeploying from file fixed them. Worth a general redeploy sweep of
  `DatabaseScripts/TestCases/` before trusting any red result.
- **`CREATE` vs `ALTER` test procs.** Most `FSxxx_TestCase` files are `CREATE PROCEDURE` (need DROP first
  to redeploy); `FS009` is `ALTER PROCEDURE` (must NOT be dropped). Mixed convention is a footgun.
- **`FS212_TestCase` lives in `dbo`,** not `App` — sweeps that assume `App.` silently skip it.
- **Retired report codes carry broken SQL** (see Q6) — they should probably be deactivated or repaired so
  a naive "lock everything" run cannot poison a family.
