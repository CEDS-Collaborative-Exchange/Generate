# Finish-Generate: EDFacts File-Spec Completion

Branch: `feature/finish-generate` · Target data year: **2027 (SY 2026-27)** · Spec baseline: **EDFacts SY 2025-26 file specifications** (ed.gov)

This document captures the full logic, architecture, environment, and workflow used to bring **all** EDFacts file specifications in Generate to functional completeness on the *New Report Migration Process*, each with a SQL end-to-end test and file-specific documentation.

Per-file logic/business-rule write-ups live alongside this file as `FS<nnn>-<name>.md`.

---

## 1. The New Report Migration Process (how a file spec is produced)

Per the Generate developer guide, the new process replaces the ~8,000-line legacy `RDS.Get_CountSQL` with a single stored procedure plus a pair of views **per report**:

| Layer | Object | Purpose |
|---|---|---|
| Base staging view | `debug.vw<FactType>_StagingTables` | All staging rows relevant to the fact type |
| Base fact view | `debug.vw<FactType>_FactTable` | All rows migrated into the RDS Fact table for the fact type |
| Report staging filter | `Staging.vw<FactType>_StagingTables_<ReportCode>` | Applies file-spec rules on the **staging** side → drives *expected* counts |
| Report fact filter | `RDS.vw<FactType>_FactTable_<ReportCode>` | Applies file-spec rules on the **fact** side → drives *actual* counts |
| Populator | `RDS.Insert_CountsIntoReportTable` | Report-agnostic proc. Reads the target table/count column from `app.FactTables` (`FactReportTableName` / `FactFieldName`), deletes the report's existing rows, then re-populates `RDS.ReportEDFacts…` from the report **fact** view — grouped by the report's metadata (CategorySets/Categories→Dimensions/OrganizationLevels/TableTypes), stripping `MISSING` category rows and adding zero-count rows for every permitted category/org combination. `@RunAsTest = 1` prints the generated SQL instead of executing it. |
| Populator wiring | `RDS.Create_Reports` | One `IF EXISTS (… IsLocked = 1 AND UseLegacyReportMigration = 1)` block per report. Reports on the new populator call `Insert_CountsIntoReportTable`; the rest still call the legacy `Create_ReportData` / `Create_OrganizationReportData` / custom procs. **Currently only 8 reports are wired to `Insert_CountsIntoReportTable`: 218, 219, 220, 221, 222, 224, 225, 226.** |
| Test harness | `Staging.RunEndToEndTest` | Report-agnostic. Auto-registers an `App.SqlUnitTest` row (`FS<code>_UnitTestCase`, TestScope `FS<code>`) if absent, builds *expected* counts from the report **staging** view (into `##<code>Staging`), joins to the populated report table, and writes one pass/fail row per category-set/org-level to `App.SqlUnitTestCaseResult` (`Passed = 1` when expected = actual). |

**Everything runs in SQL.** The orchestrator the app calls is `App.Migrate_Data`. It processes a pending `App.DataMigrations` row and iterates `App.DataMigrationTasks` in phases (pre → source-to-staging → staging validation → generate `rds`+`report` → post), selecting tasks only for reports that are `IsLocked = 1 AND IsActive = 1`. The `report`-phase tasks run `RDS.Empty_Reports '<factType>'` (clears prior rows for that fact type's locked reports) then `RDS.Create_Reports '<factType>', 0`, whose per-report branch invokes `Insert_CountsIntoReportTable` (or a legacy populator). Note: `Migrate_Data` will **not** mark the report migration complete while any locked report still has `UseLegacyReportMigration = 0`, reserving that flag for a separate new-migration path.

### Identifier gotcha
`Insert_CountsIntoReportTable` reads the **fact** view (`K12StudentStudentIdentifierState`); `RunEndToEndTest` reads the **staging** view (`StudentIdentifierState`). The two views intentionally use different column names.

---

## 2. Headless execution loop (no web app / no Hangfire)

The C# overnight-test runner enqueues Hangfire jobs whose server lifecycle is unreliable headless. Since the whole pipeline is SQL, the loop is driven directly:

```
1. EXEC App.Run_Before_Tests @submissionYear = 2027      -- year selection + toggles (child-count/membership dates, ToggleAssessments)
2. UPDATE App.GenerateReports SET IsLocked = 0;          -- unlock all
   UPDATE App.GenerateReports SET IsLocked = 1 WHERE ReportCode IN (<targets>) AND IsActive = 1;
3. Flag the 'report' App.DataMigrations row as 'pending' + LastTriggerDate = GETUTCDATE()
4. EXEC App.Migrate_Data                                 -- staging→fact→Create_Reports→Insert_CountsIntoReportTable
5. EXEC Staging.RunEndToEndTest '<code>', 2027, '<ReportTable>', '<IdColumn>', 'StudentCount', <isDistinct>
6. SELECT Passed, COUNT(*) FROM App.SqlUnitTestCaseResult r JOIN App.SqlUnitTest t … WHERE TestScope='FS<code>'
```

Locking only the target report bounds which fact type migrates (protects the hydrated staging: Source-to-Staging tasks are `IsSelected=0` except Directory, which only fires for locked directory reports).

---

## 3. Environment setup (this workstation)

- **.NET 10 SDK**: repo pins `10.0.203`; installed `10.0.302` to `%USERPROFILE%\.dotnet` (user-local, no admin). Build/run with `DOTNET_ROOT=%USERPROFILE%\.dotnet` and that `dotnet.exe`.
- **User secrets** (shared id `b238522b-…` for `generate.console` and `generate.overnighttest`): `Data:*Connection` → `Server=localhost;Database=Generate;Trusted_Connection=True;…`.
- **Hydrate**: `generate.console testdata staging <seed> <qty> sql <year> <numYears> ceds execute` — full staging refresh for one year. Staging is ephemeral; re-run freely.
- **DB baseline**: local DB was at schema **13.0**; branch scripts at 14.0. Applied the sanctioned `VersionUpdates/13.1→14.0_prerelease` folders (skipping the baseline `Restore *.bak` helpers), then authored **`VersionUpdates/14.1`** for all new work so it deploys to every state via the normal update process.

### Fixes made to shared tooling
- **Hydrate reset bug** (`generate.testdata/Helpers/OutputHelper.cs`): the staging reset deleted RDS fact tables without first truncating the bridge tables that FK to them, causing FK error 547. Now truncated before the fact deletes, guarded with `IF OBJECT_ID` for version-safety across 13.x/14.x bridge renames.
- **Fact-table `-1` key defaults** (`14.1/RDS.TableChanges.sql`): the 14.0 rebuild dropped the `DEFAULT(-1)` NA-member constraints on the fact tables' NOT NULL dimension/date keys, so every staging→fact proc that omitted a key silently failed its INSERT (swallowed by TRY/CATCH) → 0 fact rows. Restored idempotently.
- **`RunEndToEndTest` harness bug** (`Staging.RunEndToEndTest`): for a Total-only report at LEA/SCH level it appended the org group-by column without the `GROUP BY` keyword (gated on dimensions), yielding invalid SQL. Now emits `GROUP BY` whenever dimensions exist **or** the level is not SEA. Benefits every Total-only LEA/SCH report.
- **Fact procs `K12StudentId`** (ChildCount, TitleI): now populate the NOT NULL `K12StudentId` via a point-in-time `DimPeople` join. **Membership** proc: fixed `EconomicDisadvantage_StatusEndDate` → `_StatusExitDate`.

---

## 4. Per-file deliverable checklist

For each in-scope file spec:
1. Pull the SY 2025-26 file spec from ed.gov; extract **every** business rule (permitted categories, org levels, totals, edits/reasonableness, population rules). Ambiguities are documented as explicit interpretations in the file's MD.
2. Map required data to CEDS + the Staging/RDS schema. Missing CEDS-warehouse fields are **added and documented** (see §5); elements with no CEDS match are documented for submission to the CEDS Open Source Community.
3. Build/verify the four views + metadata + the `Create_Reports` branch + `Insert_CountsIntoReportTable` call.
4. Extend Hydrate so every field is populated for full end-to-end data.
5. Author the SQL end-to-end test (`Staging.RunEndToEndTest` wiring, or a bespoke `App.FS<nnn>_TestCase`).
6. Run the headless loop for 2027; iterate until the test passes green.
7. Write `FS<nnn>-<name>.md` documenting the logic, rules, interpretations, and any schema/CEDS additions.
8. Commit once green.

All SQL objects are placed in `generate.web/DatabaseScripts/VersionUpdates/14.1` (with `VersionScripts.csv` entries) so the work is deployable to all states.

### UI access ("done" also requires the report be usable in the app)
The report UI (`generate.web/ClientApp`) is **metadata-driven** via the generic `generate-app-report` component (`shared/report.component.ts`) reached from the EDFacts reports page (`reports/edfacts`). A report becomes selectable/renderable in the UI when it is `IsActive`, associated with the `edfactsreport` report type/control type, and has its report **structure metadata** (`CategorySets`/`OrganizationLevels`) for the year — the same metadata the ETL uses. **Count-based reports** (e.g. 033, 052, 222, 226) render through the generic flextable with no per-report code. **Directory/custom-layout reports** have a dedicated `shared/reportcontrols/c<code>.component.ts` (e.g. c029, c035, c131, c163, c197–c207, c223); when converting one of those, add/verify its `c<code>` component. So the per-file UI step is: (a) count reports — confirm the report appears and renders in the EDFacts UI (metadata only); (b) directory/custom reports — add the `c<code>` component.

---

## 5. CEDS / warehouse field additions (running log — review before merge)

| # | Object / field | Type | Why | CEDS element | Status |
|---|---|---|---|---|---|
| 1 | `RDS.DimLeas.ReceivesTitleIPartAFunds` (or `RDS.FactOrganizationFederalFunding`) — **proposed, not yet applied** | bit / fact | FS222 population is "LEA that receives Title I-A funds" (CFDA 84.010). That funding signal exists in `Staging.OrganizationFederalFunding` but is not surfaced in the RDS fact/dim layer, so report views can't evaluate it purely in RDS. | Maps to CEDS *Organization Federal Funding Allocation* / *Federal Programs Funding Allocation* (CFDA 84.010) — matching CEDS elements exist; no new CEDS element needed. | Proposed — pending FS222 fact-source decision (see [FS222 doc](FS222-FosterCareEnrolled.md) §4-5). |

---

## 6. Scope & status

Authoritative per-report status is tracked in [`inventory.md`](inventory.md). At kickoff: 119 active reports (~90 numbered `FSxxx` + ~25 named); `UseLegacyReportMigration = 1` for all; only 005/007 had both new-process scaffolding **and** a working test.

Current **file-derived** coverage (65 reports touched, DB-side verification pending): **20 Done**, **36 Needs test**, **9 Needs conversion**. Eight reports (218, 219, 220, 221, 222, 224, 225, 226) are wired to `Insert_CountsIntoReportTable` but still lack a SQL test. See `inventory.md` for the per-report table and the exact status rules.
