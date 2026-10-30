# FS007 — Children with Disabilities (IDEA) Reasons for Unilateral Removal · SY 2025-26 — ✅ GREEN (11,335/11,335)

Fact type: `discipline` · Report table: `RDS.ReportEDFactsK12StudentDisciplines` (count column `DisciplineCount`) · Levels: **SEA, LEA** · Table type: `IDEAREMOV` · Verified against **SY 2026** data · Populator: **`RDS.Insert_CountsIntoReportTable`** · **Counts removals, not children**

## Category sets (2026 metadata)
| Set | Categories |
|---|---|
| CSA | Disability Category (IDEA) × Removal Reason |
| CSB | Racial Ethnic × Removal Reason |
| CSC | Sex × Removal Reason |
| CSD | English Learner Status × Removal Reason |
| ST1 | Removal Reason |

Permitted Removal Reason values: `D` (drugs), `W` (weapons), `SBI` (serious bodily injury).

## Population (fact side, `RDS.vwDiscipline_FactTable_007`)
- Children with disabilities (`IdeaIndicatorEdFactsCode = 'WDIS'`), aged 3–21.
- Removed by school personnel to an interim alternative setting (`IdeaInterimRemovalEdFactsCode = 'REMDW'`), with a reason of `D`, `W` or `SBI`.
- Not in a parentally-placed private school (`PPPS`); the school is `Open` or `New`.

The view now also exposes disability type, race, sex and EL status EdFacts codes.

## What is counted
FS007 reports the **number of removals**. The legacy `Get_CountSQL` sums the fact's `DisciplineCount`. `Staging-to-FactK12StudentDisciplines` writes `DisciplineCount = 1` on every fact row, so counting fact rows gives the same number.

`RDS.Create_Reports` therefore calls `Insert_CountsIntoReportTable` with:
- `@IdentifierToCount = 'FactK12StudentDisciplineId'`
- `@IsDistinctCount = 0`

The test counts rows on the expected side (`StudentIdentifierState`, non-distinct).

2026 figures: 22,645 removals (= 22,645 fact rows = `SUM(DisciplineCount)`).

## Expected side (`Staging.vwDiscipline_StagingTables_007`)
This replaces the earlier version, which used hard-coded code mappings. Nothing else referenced it, and the bespoke `App.FS007_TestCase` reads staging directly.

The new view is built from FS088's: the same mirror of the discipline fact proc, including the interim-removal-reason lookup. It returns one row per removal, filtered to `REMDW` with reason `D`/`W`/`SBI`.

Before the test, both sides matched per reason:
| Reason | Removals | Children |
|---|---|---|
| D | 7,546 | 7,011 |
| SBI | 7,543 | 7,034 |
| W | 7,556 | 7,104 |

## Test
`EXEC Staging.RunEndToEndTest '007', '2026', 'ReportEDFactsK12StudentDisciplines', 'StudentIdentifierState', 'DisciplineCount', 0` gives **11,335 cases, all passing**:
- CSA: SEA 36, LEA 4,187
- CSB: SEA 18, LEA 3,015
- CSC: SEA 6, LEA 1,608
- CSD: SEA 6, LEA 1,519
- ST1: SEA 3, LEA 937

This ran through the pipeline path (`Empty_Reports` then `Create_Reports 'discipline'` with 005, 006, 007 and 088 locked).

Objects are listed in `VersionUpdates/14.1_prerelease/VersionScripts.csv` by main-folder path:
- `RDS.vwDiscipline_FactTable_007`
- `Staging.vwDiscipline_StagingTables_007`
- `RDS.Create_Reports`
