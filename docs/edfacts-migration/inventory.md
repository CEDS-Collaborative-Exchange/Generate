# EDFacts File-Spec Migration — Per-Report Inventory

Authoritative, **file-derived** status for every EDFacts report that has any New Report Migration Process artifact on branch `feature/finish-generate`. Derived by scanning source on disk only (no database queried). Target data year **2027 (SY 2026-27)**.

Sources scanned (all under `generate.web/DatabaseScripts`):
- Test cases — `TestCases/App.FS*_TestCase*.sql`
- Report staging views — `Views/Create/Staging.vw*_StagingTables_*.sql`
- Report fact views — `Views/Create/RDS.vw*_FactTable_*.sql`
- New-populator wiring — `Insert_CountsIntoReportTable` blocks in `StoredProcedures/Create/RDS.Create_Reports.StoredProcedure.sql`
- Metadata — `VersionUpdates/*/App.Metadata-FS*.sql`

## Legend

- **HasNewProcessViews** — `Y` if the report has a `Staging.vw…_StagingTables_<code>` view and/or an `RDS.vw…_FactTable_<code>` view. See the *View coverage* note below for which have both vs. one side.
- **WiredInCreate_Reports** — `Y` only if `RDS.Create_Reports` calls **`Insert_CountsIntoReportTable`** for the report (the new report-agnostic populator). `N` means the report's block still calls a legacy populator (`Create_ReportData` / `Create_OrganizationReportData` / a custom proc), or the report has no block. Every branch is gated on `IsLocked = 1 AND UseLegacyReportMigration = 1`.
- **HasTestCase** — `Y` if an `App.FS<code>_TestCase` stored procedure exists (bespoke) **or** the code is covered by a grouped test proc (`FS17x`, `FS18x`).
- **Likely status** (from the two build deliverables — views + a SQL test):
  - **Done** — HasNewProcessViews = Y **and** HasTestCase = Y.
  - **Needs test** — HasNewProcessViews = Y **and** HasTestCase = N (scaffolding built; end-to-end test still to author).
  - **Needs conversion** — HasNewProcessViews = N (not yet scaffolded onto the new process), regardless of any legacy test.

> A `Done` report may still be populated by the legacy `Create_ReportData` (WiredInCreate_Reports = N) rather than `Insert_CountsIntoReportTable`; "Done" here means the new-process views and a SQL test both exist on disk, not that the DB populator has been switched over. See *DB-side verification pending*.

## Status table

| ReportCode | FactType | HasNewProcessViews | WiredInCreate_Reports | HasTestCase | Likely status |
|---|---|:--:|:--:|:--:|---|
| 002 | ChildCount | Y | N | Y | Done |
| 005 | Discipline | Y | N | Y | Done |
| 006 | Discipline | Y | N | Y | Done |
| 007 | Discipline | Y | N | Y | Done |
| 009 | Exiting | Y | N | Y | Done |
| 029 | Directory | N | N | Y | Needs conversion |
| 032 | Dropout | Y | N | Y | Done |
| 033 | Membership | Y | N | Y | Done |
| 037 | TitleI | Y | N | N | Needs test |
| 040 | GraduatesCompleters | Y | N | Y | Done |
| 045 | TitleIIIELSY | Y | N | N | Needs test |
| 050 | Assessment | Y | N | N | Needs test |
| 052 | Membership | Y | N | Y | Done |
| 054 | MigrantEducationProgram | Y | N | N | Needs test |
| 059 | Staff | Y | N | N | Needs test |
| 067 | Staff | Y | N | N | Needs test |
| 070 | Staff | Y | N | Y | Done |
| 086 | Discipline | Y | N | N | Needs test |
| 088 | Discipline | Y | N | Y | Done |
| 089 | ChildCount | Y | N | Y | Done |
| 099 | Staff | Y | N | Y | Done |
| 112 | Staff | Y | N | Y | Done |
| 113 | Assessment | Y | N | N | Needs test |
| 116 | TitleIIIELSY | Y | N | Y | Done |
| 118 | Homeless | Y | N | Y | Done |
| 119 | NeglectedOrDelinquent | Y | N | N | Needs test |
| 121 | MigrantEducationProgram | Y | N | N | Needs test |
| 125 | Assessment | Y | N | N | Needs test |
| 126 | Assessment | Y | N | N | Needs test |
| 127 | NeglectedOrDelinquent | Y | N | N | Needs test |
| 129 | Directory | Y | N | N | Needs test |
| 134 | TitleI | Y | N | N | Needs test |
| 137 | Assessment | Y | N | N | Needs test |
| 138 | Assessment | Y | N | N | Needs test |
| 139 | Assessment | Y | N | N | Needs test |
| 141 | TitleIIIELOct | Y | N | Y | Done |
| 143 | Discipline | Y | N | Y | Done |
| 144 | Discipline | Y | N | Y | Done |
| 145 | MigrantEducationProgram | Y | N | N | Needs test |
| 150 | GraduationRate | Y | N | N | Needs test |
| 151 | GraduationRate | Y | N | N | Needs test |
| 160 | HSGradPSEnroll | Y | N | N | Needs test |
| 165 | MigrantEducationProgram | Y | N | N | Needs test |
| 175 | Assessment | N | N | Y | Needs conversion |
| 178 | Assessment | N | N | Y | Needs conversion |
| 179 | Assessment | N | N | Y | Needs conversion |
| 185 | Assessment | N | N | Y | Needs conversion |
| 188 | Assessment | N | N | Y | Needs conversion |
| 189 | Assessment | N | N | Y | Needs conversion |
| 194 | Homeless | Y | N | Y | Done |
| 195 | ChronicAbsenteeism | Y | N | N | Needs test |
| 203 | Staff | Y | N | N | Needs test |
| 207 | Directory | N | N | N | Needs conversion |
| 210 | Assessment | Y | N | N | Needs test |
| 211 | Assessment | Y | N | N | Needs test |
| 212 | Assessment | N | N | Y | Needs conversion |
| 218 | NeglectedOrDelinquent | Y | Y | N | Needs test |
| 219 | NeglectedOrDelinquent | Y | Y | N | Needs test |
| 220 | NeglectedOrDelinquent | Y | Y | N | Needs test |
| 221 | NeglectedOrDelinquent | Y | Y | N | Needs test |
| 222 | TitleI | Y | Y | N | Needs test |
| 223 | Directory | Y | N | N | Needs test |
| 224 | Assessment | Y | Y | N | Needs test |
| 225 | Assessment | Y | Y | N | Needs test |
| 226 | Membership | Y | Y | N | Needs test |

## Counts

| Status | Count |
|---|--:|
| Done | 20 |
| Needs test | 36 |
| Needs conversion | 9 |
| **Total** | **65** |

- **Wired to `Insert_CountsIntoReportTable`** (new populator): 8 — `218, 219, 220, 221, 222, 224, 225, 226`. None yet has a SQL test on disk, so all 8 fall under *Needs test*.

## View coverage note

`HasNewProcessViews = Y` does not distinguish staging-side vs fact-side coverage. From the view files on disk:

- **Both staging + fact views** (fully scaffolded): `002, 005, 007, 009, 089, 119, 210, 218, 219, 220, 221, 222, 224, 225, 226`.
- **Staging view only** (Directory reports): `129, 223`.
- **Fact view only**: all other `Y` rows. Their tests, where present, are bespoke `App.FS<code>_TestCase` procs rather than the generic `Staging.RunEndToEndTest` path (which requires a staging view).

## DB-side verification pending

This inventory reflects files on disk only. Not yet confirmed against the database:

- `App.GenerateReports.IsActive` — whether each report is an active submission for the target year.
- `App.GenerateReports.UseLegacyReportMigration` — the flag that gates every `Create_Reports` branch; `Migrate_Data` defers completion while any locked report still has `UseLegacyReportMigration = 0`.
- Whether the auto-registered `App.SqlUnitTest` rows are `IsActive = 1` and whether the latest `App.SqlUnitTestCaseResult` rows pass.
- Report metadata (`CategorySets` / `Categories` / `Dimensions` / `OrganizationLevels` / `TableTypes`) actually populated for 2027.

## Sources of truth

Process mechanics, the object model, and the headless run loop are documented in [`README.md`](README.md). Per-file business-rule write-ups live alongside as `FS<nnn>-<name>.md`. When this table and the README disagree, the README describes the *process*; this table describes *current on-disk coverage*.
