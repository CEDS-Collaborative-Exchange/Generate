# FS006 — Children with Disabilities (IDEA) Suspensions/Expulsions · SY 2025-26 — ✅ GREEN (16,969/16,969)

Fact type: `discipline` · Report table: `RDS.ReportEDFactsK12StudentDisciplines` (count column `DisciplineCount`) · Levels: **SEA, LEA** · Table type: `IDEASUSEXPL` · Verified against **SY 2026** data · Populator: **`RDS.Insert_CountsIntoReportTable`** (first Discipline report moved off `Create_ReportData`)

## Category sets (2026 metadata)
| Set | Categories |
|---|---|
| CSA | Disability Category (IDEA) × Removal Length × Discipline Method |
| CSB | Racial Ethnic × Removal Length × Discipline Method |
| CSC | Sex × Removal Length × Discipline Method |
| CSD | English Learner Status × Removal Length × Discipline Method |
| ST1 | Removal Length × Discipline Method |

Permitted values: Removal Length `LTOREQ10` / `GREATER10`; Discipline Method `INSCHOOL` / `OUTOFSCHOOL`.

## Population (fact side, `RDS.vwDiscipline_FactTable_006`)
- Children with disabilities: `IdeaIndicatorEdFactsCode = 'WDIS'`. The view previously tested for `'IDEA'`, which no longer exists after `RDS.DimIdeaStatuses-IDEAtoWDIS.sql` (14.1), so the report was empty. **The same stale `'IDEA'` filter is still in the FS005, FS007 and FS088 fact views.**
- Age 3–21 (age as of the child count date, as the discipline fact proc computes it).
- Not an IDEA interim removal (`IdeaInterimRemovalEdFactsCode NOT IN ('REMDW','REMHO')`); those are reported on FS005/FS007.
- A discipline method is present, or the action taken is `03086`/`03087`. This carries over the legacy `Get_CountSQL` FS006 filter.
- Not in a parentally-placed private school (`PPPS`); the school is `Open` or `New`.

## Removal length (calculated category)
Removal Length is not stored on the fact. For each child, the view sums `DurationOfDisciplinaryAction` across the school year, **per LEA and per discipline method** (window `SUM … OVER`). The totals are bucketed the same way as the legacy `Get_CountSQL` `REMOVALLENSUS` branch:
- under 0.5 days → `MISSING` (dropped by the populator)
- up to 10 days → `LTOREQ10`
- over 10 days → `GREATER10`

### Interpretations recorded
1. **Totals are summed within the LEA, not the state.** A single column can't hold both a state-wide and an LEA-wide total. At the SEA level, a child removed in two LEAs could therefore fall into a different bucket than a state-wide sum would put them in. The 2026 data has **no** such children (0 child/method pairs span more than one LEA), so SEA and LEA results are exact here. If this matters for a state with mobile students, the populator needs a level-specific calculated column.
2. **The total spans the whole child, not each category value.** Legacy grouped the sum by the category set's other dimensions as well. In 2026, 155 children have more than one disability, race or EL value across their incidents; for them, legacy split the days by that value, while this view sums all of the child's days for the method.

## Expected side (`Staging.vwDiscipline_StagingTables_006`)
Mirrors `Staging.[Staging-to-FactK12StudentDisciplines]`:
- **Joins:** enrollment window, IDEA status window, primary disability (overlapping the IDEA participation), EL status at the action start date, and unduplicated race with Hispanic/Latino taking precedence.
- **Filters and Removal Length:** the same as the fact view.

Source codes are translated per attribute through `Staging.SourceSystemReferenceData` plus the dimension tables, not through `RDS.vwDimDisciplineStatuses` / `vwDimIdeaStatuses`. Joining those views across five or four `ISNULL` columns inside a view never finished (over 10 minutes).

The main joins carry `HASH` hints. Without them, the optimizer estimates one row for the school-year/toggle CTE and nests loops all the way down. With the hints, the view materializes in about 50 seconds.

Result before the test: 54,894 rows, 33,601 children, with identical counts in every Removal Length × Method bucket on both sides.

## Other changes
- `debug.vwDiscipline_FactTable` now exposes `Demo.SexEdFactsCode`, which CSC needs.
- `RDS.Create_Reports`: the `006` block calls `Insert_CountsIntoReportTable` (`K12StudentStudentIdentifierState`, distinct).

## Test
`EXEC Staging.RunEndToEndTest '006', '2026', 'ReportEDFactsK12StudentDisciplines', 'StudentIdentifierState', 'DisciplineCount', 1` gives **16,969 cases, all passing**:
- CSA: SEA 48, LEA 6,553
- CSB: SEA 24, LEA 4,521
- CSC: SEA 8, LEA 2,329
- CSD: SEA 8, LEA 2,186
- ST1: SEA 4, LEA 1,288

The result is the same through the pipeline path (`Empty_Reports` then `Create_Reports 'discipline'` with only 006 locked).

Objects packaged in `VersionUpdates/14.1_prerelease`:
- `Debug.vwDiscipline_FactTable`
- `RDS.vwDiscipline_FactTable_006`
- `Staging.vwDiscipline_StagingTables_006`
- `RDS.Create_Reports`
