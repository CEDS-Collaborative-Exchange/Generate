# FS088 — Children with Disabilities (IDEA) Disciplinary Removals · SY 2025-26 — ✅ GREEN (11,760/11,760)

Fact type: `discipline` · Report table: `RDS.ReportEDFactsK12StudentDisciplines` (count column `DisciplineCount`) · Levels: **SEA, LEA** · Table type: `CHWDSBDSPACT` · Verified against **SY 2026** data · Populator: **`RDS.Insert_CountsIntoReportTable`**

## Category sets (2026 metadata)
| Set | Categories |
|---|---|
| CSA | Disability Category (IDEA) × Removal Length |
| CSB | Racial Ethnic × Removal Length |
| CSC | Sex × Removal Length |
| CSD | English Learner Status × Removal Length |
| ST1 | Removal Length |
| TOT | Total (no categories) |

Permitted Removal Length values: `LTOREQ1`, `2TO10`, `GREATER10`.

## Population (fact side, `RDS.vwDiscipline_FactTable_088`)
- Children with disabilities: `IdeaIndicatorEdFactsCode = 'WDIS'`. As with FS006, the view previously tested for `'IDEA'` and was empty for 2026.
- Age 3–21.
- Any removal: a discipline method, action taken `03086`/`03087`, an IDEA interim removal reason, or an IDEA interim removal.
- Not in a parentally-placed private school (`PPPS`); the school is `Open` or `New`.
- **Half-day threshold:** only children whose total days removed reach **0.5 or more** are reported. This applies to every set, including TOT, matching the legacy `#Students … HAVING SUM(DurationOfDisciplinaryAction) >= 0.5`.

## Removal length (calculated category)
Each child's `DurationOfDisciplinaryAction` is summed across the school year **within the LEA**, across all removal types. The total is bucketed as in the legacy `Get_CountSQL` `REMOVALLENIDEA` branch:
- under 1.5 days → `LTOREQ1`
- up to 10 days → `2TO10`
- over 10 days → `GREATER10`

The interpretations recorded for FS006 apply here too:
- **LEA-level totals:** a child removed in two LEAs would be bucketed per LEA at the SEA level. 2026 has no such child.
- **One total per child**, even where the child's disability, race or EL value differs between incidents.

## Expected side (`Staging.vwDiscipline_StagingTables_088`)
This view is built from FS006's: the same mirror of `Staging.[Staging-to-FactK12StudentDisciplines]`, the same per-attribute code translation, and the same hash-join hints. On top of that it:
- adds an interim-removal-reason lookup (`RefIdeaInterimRemovalReason`)
- uses FS088's removal filter
- totals days per child and LEA, and applies the half-day threshold.

Before the test, both sides matched: 89,579 rows, 41,323 children, with identical counts per Removal Length bucket. It materializes in about 45 seconds.

## Other changes
`RDS.Create_Reports`: the `088` block calls `Insert_CountsIntoReportTable` (`K12StudentStudentIdentifierState`, distinct).

## Test
`EXEC Staging.RunEndToEndTest '088', '2026', 'ReportEDFactsK12StudentDisciplines', 'StudentIdentifierState', 'DisciplineCount', 1` gives **11,760 cases, all passing**:
- CSA: SEA 36, LEA 4,536
- CSB: SEA 18, LEA 3,070
- CSC: SEA 6, LEA 1,497
- CSD: SEA 6, LEA 1,436
- ST1: SEA 3, LEA 826
- TOT: SEA 1, LEA 325

The result is the same through the pipeline path (`Empty_Reports` then `Create_Reports 'discipline'` with 006 and 088 locked).

Objects are listed in `VersionUpdates/14.1_prerelease/VersionScripts.csv` by main-folder path:
- `RDS.vwDiscipline_FactTable_088`
- `Staging.vwDiscipline_StagingTables_088`
- `RDS.Create_Reports`
