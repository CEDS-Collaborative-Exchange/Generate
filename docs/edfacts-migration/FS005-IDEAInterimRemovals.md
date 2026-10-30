# FS005 — Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting · SY 2025-26 — ✅ GREEN (9,380/9,380)

Fact type: `discipline` · Report table: `RDS.ReportEDFactsK12StudentDisciplines` (count column `DisciplineCount`) · Levels: **SEA, LEA** · Table type: `CHDISDSPL` · Verified against **SY 2026** data · Populator: **`RDS.Insert_CountsIntoReportTable`**

## Category sets (2026 metadata)
| Set | Categories |
|---|---|
| CSA | Disability Category (IDEA) × Removal Type |
| CSB | Racial Ethnic × Removal Type |
| CSC | Sex × Removal Type |
| CSD | English Learner Status × Removal Type |
| ST1 | Removal Type |

Permitted Removal Type values: `REMDW` (removed by school personnel for drugs, weapons or serious bodily injury) and `REMHO` (removed by a hearing officer for likely injury).

## Population (fact side, `RDS.vwDiscipline_FactTable_005`)
This matches the legacy `Get_CountSQL` FS005 `#Students` rules:
- Children with disabilities (`IdeaIndicatorEdFactsCode = 'WDIS'`), aged 3–21.
- An IDEA interim removal of `REMDW` or `REMHO`.
- Not in a parentally-placed private school (`PPPS`); the school is `Open` or `New`.

Each child is counted once per Removal Type (distinct `K12StudentStudentIdentifierState`). There is no calculated category.

The view now exposes the dimension EdFacts codes the populator needs: disability type, race, sex, EL status, and interim removal.

## Expected side (`Staging.vwDiscipline_StagingTables_005`)
This replaces the earlier version, which used hard-coded code mappings and no longer matched the fact proc. Nothing else referenced it, and the bespoke `App.FS005_TestCase` reads staging directly.

The new view is built from FS006's, which mirrors `Staging.[Staging-to-FactK12StudentDisciplines]` with per-attribute code translation and hash-join hints. FS005's filter is interim removal in `REMDW`/`REMHO`.

Before the test, both sides matched: 35,149 rows and 25,636 children (18,441 `REMDW`, 11,115 `REMHO`).

## Other changes
`RDS.Create_Reports`: the `005` block calls `Insert_CountsIntoReportTable` (`K12StudentStudentIdentifierState`, distinct).

## Test
`EXEC Staging.RunEndToEndTest '005', '2026', 'ReportEDFactsK12StudentDisciplines', 'StudentIdentifierState', 'DisciplineCount', 1` gives **9,380 cases, all passing**:
- CSA: SEA 24, LEA 3,750
- CSB: SEA 12, LEA 2,544
- CSC: SEA 4, LEA 1,218
- CSD: SEA 4, LEA 1,176
- ST1: SEA 2, LEA 646

This ran through the pipeline path (`Empty_Reports` then `Create_Reports 'discipline'` with 005, 006 and 088 locked), and FS006 and FS088 stayed green in the same run.

Objects are listed in `VersionUpdates/14.1_prerelease/VersionScripts.csv` by main-folder path:
- `RDS.vwDiscipline_FactTable_005`
- `Staging.vwDiscipline_StagingTables_005`
- `RDS.Create_Reports`
