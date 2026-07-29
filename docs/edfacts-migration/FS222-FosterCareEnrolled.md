# FS222 — Foster Care Enrolled (DG893) · SY 2025-26

Fact type (current): `titleI` · Report table: `RDS.ReportEDFactsK12StudentCounts` · Levels: **SEA, LEA** · Categories: **none (Total only)**

## 1. Spec (authoritative — SY 2025-26 FS222 v22.0, ed.gov DG893)

**Definition:** "The number of students who are in foster care and enrolled in a public LEA that receives ESSA Title I, Part A funds."

Core reporting requirements (Table 2.2-1):
- **Reporting period:** regular school year (excludes intersession/summer).
- **Education units included:** SEA; **LEAs that receive Title I, Part A funds**.
- **Units not reported:** closed, inactive, or future LEAs; **LEAs that do not receive Title I, Part A funds**.
- **Type of count:** SEA — students counted **once** (deduplicated; if unable to dedup, note "may include duplicate students"). LEA — a student **may** be reported in more than one LEA (if enrolled + in foster care in multiple LEAs).
- **Zero counts:** **SEA — required.** LEA — not required (unreported assumed zero).
- **Missing:** report `-1`.
- **Categories & Totals:** *"This section is not used."* / *"This file specification does not use any categories and permitted values."* → **Total only.**

**Critical clarification (from Data Reporting Guidelines):**
> "The Title I, Part A foster care requirements apply to **all** students in foster care enrolled in an LEA that receives Title I, Part A funds, **even when these students may not be served by or eligible for Title I, Part A services in a school-level … schoolwide program or targeted assistance program.**"

**"Foster care"** = 24-hour substitute care per 45 C.F.R. §1355.20(a) (foster family homes, group homes, shelters, institutions, etc.). Count a student who was in foster care **at any point, for any length of time**, while enrolled during the reporting year.

## 2. Interpretation & decisions

1. **Population is ENROLLMENT-based, not Title I participation-based.** The count is foster-care students *enrolled* in a Title I-A-funded LEA — explicitly independent of whether the student participates in / is eligible for Title I services. **Interpretation:** neither a student-level Title I participation record nor a school-level Title I program/schoolwide/targeted status may be used to restrict the count.
2. **"LEA that receives Title I, Part A funds"** → `Staging.OrganizationFederalFunding` with `FederalProgramCode = '84.010'` (the CFDA code for Title I Part A), at LEA `OrganizationType`. (342 of 344 LEAs in the 2027 test data.) This is the authoritative funding signal; the LEA-level `Lea_TitleIProgramType` is *not* used (it describes program type, not receipt of funds).
3. **LEA exclusions:** `Lea_OperationalStatus IN ('Open','New')` and `Lea_IsReportedFederally <> 0`.
4. **Foster care:** `Staging.PersonStatus.ProgramType_FosterCare = 1` (→ `ProgramParticipationFosterCareEdFactsCode = 'FOSTERCARE'`).
5. **Levels/grain:** SEA = COUNT(DISTINCT student) across qualifying LEAs; LEA = COUNT(DISTINCT student) within each LEA (a student may count in multiple LEAs). Total only.

## 3. Gap found in the existing (pre-fix) objects

| Object | Pre-fix filter | Problem vs spec |
|---|---|---|
| `Staging.vwTitleI_StagingTables_222` (expected) | foster **AND school Title I status ∈ {TGELGBTGPROG, SWELIGTGPROG, SWELIGSWPROG}** | Wrongly restricts to Title I *schools* → under-counts (286). Spec forbids this restriction. |
| `RDS.vwTitleI_FactTable_222` (actual) | foster + LEA open + reportedFed **AND TitleIProgramTypeCode ∈ {Local/PrivateSchool/Schoolwide/TargetedAssistance}** | Wrongly restricts by org **program type**; does not check Title I-A **funding**. |

First real test run (before reconciliation): **expected 286 vs actual 790** at SEA/TOT.

## 4. Fact-source mismatch (open design item — needs decision)

`RDS.FactK12StudentCounts` `titleI` facts are produced by `Staging-to-FactK12StudentCounts_TitleI`, which **requires a `ProgramParticipationTitleI` record** (student-level Title I participation) plus date-window logic. FS222's spec population is **enrollment-based** and must include foster students who are *not* Title I participants. Measured 2027 populations:

- Old staging view (school-status filtered): **286**
- Fact side (foster + open + reportedFed + 84.010, via titleI facts): **790**
- Raw staging (foster + enrolled + open + reportedFed + 84.010, **no** Title I participation join): **1012**

The spec-correct number is the **1012** enrollment-based population (participation-independent). The `titleI` fact type cannot represent that without either (a) sourcing FS222 from an enrollment/membership fact, or (b) broadening the titleI fact to include all enrolled foster students in Title I-A LEAs. **Recommendation:** source FS222 from the enrollment/membership fact grain (or a dedicated foster-care enrolled fact), not Title I participation. Pending that decision, a green test can be produced by aligning both views to the *same* population, but to be *spec-correct* it must be the enrollment-based (participation-independent) population.

## 5. CEDS / warehouse notes

- **"LEA receives Title I, Part A funds"** is available in staging (`OrganizationFederalFunding` / CFDA `84.010`) but is **not surfaced in the RDS fact/dimension layer** (only `RDS.DimFederalProgramCodes` exists; no LEA→federal-funding fact). To evaluate FS222 purely in the RDS layer, a warehouse addition is needed: an **LEA-level "Receives Title I Part A funds" indicator** (e.g., a bit on `RDS.DimLeas`, or an `RDS.FactOrganizationFederalFunding`). CEDS: this maps to CEDS *Organization Federal Funding Allocation* / *Federal Programs Funding Allocation* (CFDA 84.010). **Proposed addition documented here for review** (see repo README §5). Until added, the report views reference `Staging.OrganizationFederalFunding` directly.

## 6. Status

- Spec fully extracted; interpretation documented above.
- Root filters corrected in analysis (remove school-status / program-type; use foster + LEA-open + reportedFed + 84.010).
- **Open before green:** decide the fact source (§4). This is the first-encountered instance of a broader question — reports whose spec population differs from the fact grain currently wired to them.
