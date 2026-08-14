# Open questions for Nathan — EDFacts 94-file green initiative

Companion to `BLOCKED.md` (technical blockers). **This file holds only decisions that require Nathan.**
Each entry: what I found → why I stopped → options → my recommendation.

Goal being driven: *full end-to-end support + e2e testing GREEN on all 94 active EDFacts file specs.*
Brain task: `6cafe950`. Branch `feature/finish-generate`. Data year **2027**.

---

## 🔴 Q0 (CRITICAL, found 2026-08-14) — The AI ETL Developer destroys the e2e test-data baseline

**This is the single biggest finding of the session and it invalidated a swathe of test results.**

The AI ETL Developer (ETL chat, CIID-9061) emits staging loads shaped as:

```sql
DELETE FROM Staging.<Table> WHERE SchoolYear = @SchoolYear;
INSERT INTO Staging.<Table> (...) SELECT ... FROM <the session's bespoke source>;
```

Run against the shared Generate DB, that is destructive in **two** ways:

1. **INSERT succeeds but is tiny.** `Staging.K12Enrollment` for **SchoolYear 2026** went from **10,031 generated rows → 600 rows / 300 students**, every one an `NJ1000001`-style id from `Source.MembershipExtract2026` (map 8, the FS052 membership test map).
2. **DELETE succeeds, INSERT fails → pure deletion.** `Staging.K12Enrollment` for **SchoolYear 2027** was wiped **entirely (0 rows)** — consistent with a session that hit the bit-conversion error loop after its DELETE had already committed.

Sibling tables were untouched (`Staging.Discipline` 2025/26/27 = 24,068 / 24,068 / 33,996; `PersonStatus` = 10,031 / 10,031 / 10,023), so staging became **internally inconsistent**: the enrollment backbone gone while every child table kept full cohorts.

**Impact.** Every `FSxxx_TestCase` expected side that joins `Staging.K12Enrollment` on SchoolYear collapses to zero. Proven step-by-step for FS005 — the predicate `ske.Schoolyear = CAST(@SchoolYear AS VARCHAR)` takes **5,336 surviving students → 0**:

| step | predicate added | distinct students |
|---|---|---|
| 0 | base joins | 7,496 |
| 1 | `+ sppse.IDEAIndicator = 1` | 7,446 |
| 2 | `+ idea.IdeaDisabilityTypeCode IS NOT NULL` | 7,446 |
| 3 | `+ sd.IdeaInterimRemoval IN ('REMDW_1','REMHO_1')` | 5,336 |
| **4** | **`+ ske.Schoolyear = @SchoolYear`** | **0** |

That single fact explains discipline FS005/006/007/088/143/144 all reporting "NO TEST RESULTS," and likely contributed to other expected-side-empty results. Reports/facts were **not** affected — they were built before the destruction.

**Already done:** restored the baseline by re-running the deterministic generator
(`generate.console testdata staging 1000 10000 sql 2027 3 non-ceds execute`, seed 1000 → identical
data to what the RDS facts were built from). The test procs are **correct** and must not be changed —
their `K12Enrollment` join mirrors the production ETL
(`Staging-to-FactK12StudentDisciplines`, lines 273-274).

**Question:** How do you want the ETL chat isolated so this cannot recur? Options:
- **(A)** Point the AI ETL Developer at a dedicated sandbox DB / restorable snapshot (my recommendation).
- **(B)** Scope its generated `DELETE` to the session's own source keys (e.g. the LEA/school ids present
  in its source) instead of the whole `SchoolYear`.
- **(C)** Run its loads inside a transaction that rolls back unless the INSERT succeeds — this alone
  would have prevented the 2027 total wipe.

I'd do **(A) + (C)**: (C) is a cheap, high-value guard regardless of where it runs.

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

## Q3 ✅ RESOLVED-DIAGNOSIS (approval needed to apply) — staff SEA is a **TEST** bug, not a report bug

**Good news: the report is correct.** My earlier hypothesis (report double-counting) was **wrong** —
diagnosed and disproved.

`FS070/FS099/FS112` fail only at SEA level (TOT SEA expected 2 vs actual 226). Root cause is in the
**test proc**, `App.FS070_TestCase` line 118 (FS099 lines 125-126, FS112 line 125):

```sql
AND @ChildCountDate BETWEEN sko.LEA_RecordStartDateTime
                        AND ISNULL(sko.LEA_RecordEndDateTime, GETDATE())
```

For SY2027 `@ChildCountDate` = **2026-10-01**, but the test runs *today* (2026-08-14). For every still-open
org (`LEA_RecordEndDateTime IS NULL` — 2,696 rows / 337 LEAs) the window becomes
`10/01/2026 BETWEEN start AND 08/14/2026` → **false**. Only **1 of 152 LEAs** ("LEAPKOnly", which has an
explicit end date) survives — hence expected=2.

The production ETL does it correctly (`Staging-to-FactK12StaffCounts` line 26/127/131/134): it falls back to
`staging.GetFiscalYearEndDate(@SchoolYear)` = 2027-06-30, not wall-clock. The report's 226 was independently
reconstructed from `RDS.FactK12StaffCounts` and is internally consistent (CSA buckets 45+85+26+70 = 226;
ST1 130+96 = 226; ST2 71+155 = 226). **No inflated submission risk.**

Note the LEA-level rows "pass" only because they too compare that single surviving LEA — they weren't
validating anything.

**This is systemic.** The same `ISNULL(<end date>, GETDATE())` time-bomb appears **33 times across 8 test
procs**: FS002 (5), FS032 (3), FS040 (7), FS070 (2), FS089 (5), FS099 (2), FS112 (2), FS17x (7). It
silently mis-scopes any test run before its own count date — which is likely a major contributor to the
childcount/dropout/assessment discrepancies too.

**Proposed fix (mirrors production, no report logic touched):** declare
`@SYEndDate = staging.GetFiscalYearEndDate(@SchoolYear)` and replace every `GETDATE()` date-window fallback
with it.

**Question:** FS032/FS040 are **not** in your vetted list so I can fix those now — but FS002, FS089, FS070,
FS099, FS112 and FS17x **are** vetted. Approval to apply this `GETDATE() → @SYEndDate` fix to the vetted
test procs? (It changes only test-harness date scoping, not spec/report logic.) **Expect a re-baseline** —
once tests exercise all 152 LEAs instead of 1, currently-"passing" rows may reveal real discrepancies.

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

## Q8 (biggest remaining gap) — 49 active codes produced **zero** 2027 rows; 4 families have real SQL defects

Audit of every active 3-digit report code against all six report tables found **49 with no 2027 rows at
all**. Splitting them by whether `RDS.Create_Reports` even has a branch for them:

- **44 have a branch** → they were simply never generated (a *run* gap, not a development gap).
- **5 have NO branch → need development:** `FS180, FS181, FS210, FS211, FS212`.

I then generated the 44 (locking only those codes, so it was purely additive — nothing existing was
touched). **15 now populate**, including FS035 (9,220), FS039 (44,280), FS103, FS129, FS130, FS131, FS163,
FS170, FS190, FS193, FS197, FS198, FS206, FS207, FS223.

**4 families aborted on real defects in *active, in-scope* report SQL** (these are not retired codes —
I had excluded those):

| family | error | affects |
|---|---|---|
| graduationrate | `Incorrect syntax near ')'` | FS150, FS151 |
| migranteducationprogram | `The multi-part identifier "da.AgeCode" could not be bound` | FS121, FS126, FS145 |
| cte | `Invalid object name 'rds.DimEnrollmentStatuses'` | FS082, FS083, FS154-158, FS169 |
| assessment | `Invalid column name 'DimStudentId'` | FS113, FS125, FS137-139, FS142, FS224, FS225 |

That's ~20 specs blocked behind 4 discrete SQL bugs — high leverage: fixing 4 defects could unblock a fifth
of the 94.

**Question:** Priority to fix these 4 (my recommendation — best ratio of effort to specs unblocked), and do
you want the 5 branch-less codes (180/181/210/211/212) developed in this push or deferred?

---

## Q9 — Test-result counts are inflated by duplicate `App.SqlUnitTest` registrations

`App.SqlUnitTest` has **17 duplicate rows** for `FS143_UnitTestCase` (`SqlUnitTestId` 8, 10-22, 29, 31, 33),
oldest from 2022-11-04. The test procs do:

```sql
IF NOT EXISTS (SELECT 1 FROM App.SqlUnitTest WHERE UnitTestName = @UnitTestName) INSERT ...
ELSE SELECT @SqlUnitTestId = SqlUnitTestId FROM App.SqlUnitTest WHERE UnitTestName = @UnitTestName
```

With duplicates present this picks an arbitrary id (no `TOP 1`/`ORDER BY`), and the cleanup
`DELETE FROM App.SqlUnitTestCaseResult WHERE SqlUnitTestId = @SqlUnitTestId` clears only that one id —
orphaning the rest. So the reported "FS143 = 0 pass / 105,320 fail" is **~105,319 stale 2022-2023 rows plus
1 real row from the current run**. The real current FS143 result is a single row:
`TOT SEA Match All, expected 0, actual 9,215`.

Any scorecard that aggregates by `UnitTestName` (mine did) over-reports. **Fix:** dedupe `App.SqlUnitTest`
and/or scope result queries to the latest `SqlUnitTestId` per name.

**Question:** OK to dedupe `App.SqlUnitTest` and add `TOP 1 ... ORDER BY SqlUnitTestId DESC` to the lookup?

---

## Q10 — `FS212_TestCase` is written against a dropped schema

`dbo.FS212_TestCase` references **`rds.FactOrganizationCountReports`**, which no longer exists. Current
tables are `RDS.FactOrganizationCounts` / `RDS.ReportEDFactsOrganizationCounts`. It needs a rewrite, not a
redeploy. (It also lives in `dbo`, not `App` — see the issue log.)

**Question:** Rewrite FS212 against the current schema as part of this push, or defer with 180/181/210/211?

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
