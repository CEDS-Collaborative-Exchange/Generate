# EDFacts code-translation catalog (from Get_CountSQL) → central map

Source of truth: `RDS.Get_CountSQL` translates each dim/fact EDFacts code to a report's permitted
`CategoryOptionCode` via inline per-report CASE blocks (lines 2027–2402). The new view-based path
(`RDS.Insert_CountsIntoReportTable` + `RunEndToEndTest`) has no translation, so it must reproduce these.
Plan: move the **simple 1:1 value translations** into `App.EdFactsCategoryCodeMap` (applied centrally by
`RDS.Get_TranslatedReportCategoryCode`); leave the **complex multi-column ones** in `Get_CountSQL` (several
belong to the vetted spec-ed assessment reports and must not change).

## Goes in the central map (simple value → CategoryOptionCode; source = the EdFactsCode the view surfaces)

| CategoryCode | ReportCode | Source EdFactsCode → Target | Notes |
|---|---|---|---|
| DISABSTATUS/DISABSTATIDEA/DISABIDEASTATUS | ALL | `IDEA` → `WDIS` | **already done via the dim UPDATE** (dim now stores WDIS); non-disabled stays MISSING per Nathan (WODIS deferred) |
| HOMELESS | 037 (any HOMELESS-cat report) | `HOMELSENRL` → `H` | Get_CountSQL 2163: homeless=Yes→H, else passthrough |
| DISABSTATUS504 | ALL | `SECTION504` → `DISAB504STAT` | Get_CountSQL 2171; `NONSECTION504`/else → MISSING |
| LUNCHPROG | ALL (033) | `FREE`→`FL`, `REDUCEDPRICE`→`RPL` | Get_CountSQL 2153 |
| FSTRCRSTS | ALL (222) | foster `Yes` → `FCS` | Get_CountSQL 2243 |
| GRADELDROP | ALL (032) | `PK,KG,01..06` → `BELOW7` | Get_CountSQL 2179 |
| MAJORREG | ALL | AM7→MAN, AS7→MAP/MA, BL7→MB, HI7→MHL, MU7→MM, PI7→MAP/MNP, WH7→MW, else MISSING | Get_CountSQL 2063; branches on @istoggleRaceMap |
| ACADSUBASSESNOSCI/ACADSUBASSES | ALL (assessments) | `MATH`→`M`, `SCIENCE`→`S` | Get_CountSQL 2385 — **spec-ed; only if we migrate assessments** |
| DISABSTATADA | ALL | PrimaryDisabilityType MISSING→MISSING else `DISADA`/`WDIS` (toggle CtePerkDisab) | Get_CountSQL 2366 |

Also confirmed by the new-path fact views: `NLEP`→MISSING and `NoEdFactsEquivalent`→MISSING (FS032 EL/Migrant)
— these are "not a permitted value → MISSING" and can be map rows too (per report/category).

## Stays in Get_CountSQL for now (complex / multi-column / spec-ed)

- Assessment PARTSTATUS / PARTSTATUS%LG / %HS / PROFSTATUS / TESRES (2131–2360): multi-column, many mappings, spec-ed.
- Discipline REMOVALLENSUS / REMOVALLENIDEA (2027/2037): aggregate `sum(DurationOfDisciplinaryAction)` buckets.
- Grade+age combos AGEU3TOGR12UG / AGE3TOGRADE13 / AGEPK / AGESA / AGEEC (2210–2234, 2394 + joins 2544/2603):
  depend on BOTH AgeCode and GradeLevelEdFactsCode (childcount age-5 = AGESA/AGEEC — **spec-ed, log-only**).
- GRADELVLHS / GRADELVLHSSCI (2187/2198): depend on assessment grade toggle.

## Region B (allow-lists / pruning) — NOT translations
Get_CountSQL lines 1516–1893 enumerate permitted options and prune per report (e.g. 002/005/006/007/088/143/144
drop `PPPS`/`HH` at school level; grade toggles add 13/UG/AE). These constrain the vocabulary; on the new path the
equivalent is `app.CategoryCodeOptionsByReportAndYear` + the PermittedValues join. The `HH`/`PPPS` school-level
pruning (FS002) is a real new-path gap to handle separately (spec-ed → log).

## Integration
1. Seed `App.EdFactsCategoryCodeMap` with the "goes in the map" rows above (source = EdFactsCode value).
2. `RDS.Insert_CountsIntoReportTable`: wrap `cs.<Dim>EdFactsCode` (SELECT/JOIN/GROUP BY, ~lines 123/128/152)
   with `RDS.Get_TranslatedReportCategoryCode(@ReportCode, '<CategoryCode>', cs.<Dim>EdFactsCode)`.
3. `Staging.RunEndToEndTest`: wrap the staging `s.<DimensionFieldName>` refs (~lines 99/123) the same way so
   expected == actual.
4. Remove the interim per-view CASEs (FS037 homeless, FS195 504) — the map replaces them.
5. Empty map = pure passthrough (behavior-preserving), so deploy plumbing first, confirm all greens stay green,
   then seed + retest.
