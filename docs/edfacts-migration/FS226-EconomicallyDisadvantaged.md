# FS226 — Economically Disadvantaged Students (DG56) · SY 2025-26 — ✅ GREEN (179/179)

Fact type: `membership` · Report table: `RDS.ReportEDFactsK12StudentCounts` · Level: **School only** · Categories: **none (Total only)**

## Spec (SY2025-26 FS226 v22.0, DG56)
**Definition:** "The unduplicated number of students who met the state criteria for classification as economically disadvantaged according to the state definition."
- **Level:** School only (no SEA/LEA).
- **Reporting period:** Oct 1 (or closest school day) — the membership date.
- **Units included:** operational schools. **Excluded:** closed/inactive/future schools; "reportable program" school type; operational schools with no students.
- **Students:** all students the SEA regards as enrolled elementary/secondary (includes ungraded per state toggle). Count **at only one school**.
- **Zero counts:** **Required** (school level). **Categories:** none — Total only.

## Resolution
The fact view `RDS.vwMembership_FactTable_226` already encoded the spec (`EconomicDisadvantageStatusEdFactsCode='ECODIS'` + operational school + reported federally + `SchoolTypeCode <> 'Reportable'`). Two fixes were needed elsewhere:

1. **`debug.vwMembership_StagingTables` was broken** in the deployed DB — it referenced `EconomicDisadvantage_StatusEndDate` (the column is `_StatusExitDate`), so any query against it errored. The checked-in view is already correct; redeploying it (packaged in 14.1) fixes states whose DB is stale. (Same root cause as the membership fact-proc typo fixed earlier.)
2. **Authored `Staging.vwMembership_StagingTables_226`** (the harness expects `_226`; the prior object was mis-named `_C226`). It mirrors the membership fact migration so expected == actual: enrollment covers the membership date, economic-disadvantage status window covers the membership date, valid age as-of the membership date (inner `DimAges`), valid demographic (inner `vwDimK12Demographics`), **grade level in the toggle-driven included set** (PK,KG,01-12 always; 13/UG/ABE only when the `CCDGRADE13`/`CCDUNGRADED`/`ADULTEDU` toggles are on), and operational/reported/not-Reportable school.

### Interpretation recorded
The initial expected population (252) over-counted by 65 students in grades **13 / ABE (adult ed) / UG / NULL**. The membership fact **correctly excludes** these per the grade toggles (adult ed and grade 13 are not elementary/secondary membership) — so here the fact was spec-correct and the *expected* view was tightened to match (not a fact bug). Result: **179 schools, all counts match, 179/179 test cases pass.**

Objects packaged in `VersionUpdates/14.1`. (The deprecated `Staging.vwMembership_StagingTables_C226` is left in place, unused, to avoid breaking any unknown references.)
