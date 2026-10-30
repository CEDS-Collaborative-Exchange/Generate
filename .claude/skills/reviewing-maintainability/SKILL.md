---
name: reviewing-maintainability
description: Perform repository-grounded maintainability code reviews and produce a prioritized list of concrete maintainability issues or concerns with file and line references. Use when the user asks for a maintainability review, code health review, technical debt review, refactorability review, complexity review, coupling review, duplication review, readability review, architecture drift review, change-risk review, or long-term ownership assessment for this Generate (CIID EDFacts/IDEA reporting) codebase spanning the Angular 20 SPA in generate.web/ClientApp, the ASP.NET Core (.NET 10) API in generate.web/generate.core/generate.infrastructure, and the raw-SQL object definitions in generate.database. Inspect controllers, services, repositories, DTOs/models across the App/ODS/IDS/RDS/Staging layering, Angular feature modules and API wrapper services, and cross-layer workflows for concrete maintainability issues; present confirmed findings in Markdown sorted by Critical, High, Medium, and Low with file and line references.
---

# Reviewing Maintainability

Review the code that exists before making claims. Prefer concrete change-risk and ownership problems over generic style advice.

## Generate Stack Focus

Tailor the review to this repository's stack and layout:

- Backend: ASP.NET Core on .NET 10 (`global.json`), hosted from `generate.web/Program.cs` — this repo's service-registration, middleware-order, auth, and background-job wiring entry point (the `Startup.cs` equivalent). Controllers live under `generate.web/Controllers/Api/{App,ODS}/` and `generate.web/Controllers/Web/`, with Razor views in `generate.web/Views/`.
- Core/domain layer: `generate.core/Interfaces/{Repositories,Services,Helpers}/I*.cs` define contracts; `generate.core/Dtos/{App,ODS,RDS}`, `generate.core/Models/{App,IDS,RDS,Staging}`, and `generate.core/ViewModels/` hold data shapes. `generate.core` has no concrete implementations — those live in `generate.infrastructure`.
- Implementation layer: `generate.infrastructure/Services/*.cs` (business/orchestration services) and `generate.infrastructure/Repositories/{App,IDS,RDS,Staging}/*.cs` (EF Core-backed data access), plus `generate.infrastructure/Contexts/` for DbContexts.
- Database layer: raw-SQL object definitions in `generate.database/{Tables,Views,StoredProcedures,Functions,TableTypes,Indexes,Jobs}/{Create,Drop}` and versioned migration scripts in `generate.database/VersionUpdates/<version>/`.
- Frontend: Angular 20 SPA in `generate.web/ClientApp/src/app`, with thin HTTP wrapper services in `services/{app,ods}/*.service.ts` (extending `services/base.service.ts`), feature areas under `reports/`, `settings/`, `resources/`, `about/`, `home/`, and shared guards/interceptors/components/reportcontrols under `shared/`.
- Common review starting points: `generate.web/Program.cs`, `generate.web/Controllers/Api/`, `generate.infrastructure/Services/`, `generate.core/Interfaces/Repositories/App/IAppRepository.cs` and its implementation `generate.infrastructure/Repositories/App/AppRepository.cs`, `generate.web/ClientApp/src/app/services/`, `generate.web/ClientApp/src/app/shared/guards/`, `generate.web/ClientApp/src/app/shared/interceptors/`, and any large feature module under `reports/` or `settings/`.

## Workflow

1. Identify the stack, the main seams between layers, and the parts of the codebase that many features must touch to ship a change.
2. Read only the files needed to trace change amplification, hidden coupling, duplication, architectural drift, and confusing ownership boundaries. In this repo, start with `Program.cs` registration, controllers, the `IAppRepository`/`AppRepository` data-access surface, infrastructure services, shared Angular API wrapper services, guards/interceptors, and large report/settings feature components.
3. Use [references/maintainability-review-checklist.md](references/maintainability-review-checklist.md) as the default checklist. Use [references/generate-stack-maintainability.md](references/generate-stack-maintainability.md) for repo-specific hotspots and interpretation guidance.
4. For each suspected issue, confirm the concrete maintenance burden: what future change is likely to be harder, riskier, or slower because of the current shape. Do not report speculative findings that lack a plausible ownership or modification pain path.
5. Spend most time on problems that make broad changes unsafe, scatter one concern across many files, hide business logic behind oversized abstractions, or force developers to edit multiple layers for routine work.

## Finding Standard

Only report a finding when all of these are true:

- The maintainability problem is present in code, structure, or configuration.
- A realistic change path or ownership path reaches it.
- The impact is meaningful and not purely theoretical.

When the evidence is incomplete, say so explicitly and label it as an assumption or open question instead of a confirmed finding.

## Priority Rubric

Sort findings from highest to lowest priority:

- `Critical`: The current structure makes core changes unsafe or unreasonably hard, such as giant shared abstractions that centralize too many concerns, architectural duplication that can diverge silently, or cross-layer coupling that creates systemic regression risk.
- `High`: Significant maintenance burden in commonly changed code, such as oversized classes or components, repeated logic across modules, weak ownership boundaries, or patterns that force multi-file edits for routine feature work.
- `Medium`: Confirmed maintainability issue with narrower scope, stronger preconditions, or partial mitigation already present.
- `Low`: Local readability, consistency, or cleanup issue that matters mainly over time or in combination with larger design problems.

Prefer fewer, higher-confidence findings over long speculative lists.

## What To Look For

- Oversized classes, services, controllers, or components that carry too many responsibilities or accumulate unrelated revisions over time.
- Old and newer architectural patterns living side-by-side, especially where `IAppRepository`/`AppRepository`'s generic CRUD methods, its "Extended Methods" (migration orchestration, report locking, metadata migration), infrastructure services, and Angular API wrapper services create overlapping ways to do similar work.
- Cross-layer flows that repeatedly traverse Angular component -> feature service (`services/app` or `services/ods`) -> API controller -> infrastructure service -> repository (`IAppRepository`/`IRDSRepository`) for straightforward operations — or that skip a layer, such as a controller querying `IAppRepository`/`IRDSRepository` directly instead of going through its matching `I*Service`.
- Large service registration blocks in `Program.cs`, service classes, or route modules that keep growing and make dependency ownership unclear.
- Large Angular feature components or template files that mix data-fetching, filter/query-string construction, table rendering, and orchestration logic in one place.
- Repeated endpoint, repository query, mapping, API-wrapper, or component patterns copied across the App/ODS/RDS layering instead of extracted into coherent abstractions.
- Generic wrappers or `any`-heavy APIs that hide shape information, reduce compile-time safety, or make refactors harder.
- Mixed naming, foldering, or import styles that make it hard to predict where new code belongs — especially inconsistencies between parallel App, ODS, RDS, and Staging surfaces.
- Business logic embedded in controllers, component classes, or templates instead of clearer domain or service boundaries.
- Tests that are hard to write or maintain because the production code has too many responsibilities or too many concrete dependencies.
- Revision-history comments (e.g., stale commented-out code, "switching to other API call without it" style notes) and file accretion that signal a class has become the default dumping ground for adjacent features.

## Output Format

Return the review as Markdown.

Use Markdown structure intentionally so findings are easy to scan.

- Start with a short `## Findings` heading.
- Give each finding its own `### <Priority>: <Short Title>` heading.
- Put supporting fields on separate lines with bold labels such as `**Impact:**`, `**Evidence:**`, `**Change Risk:**`, `**Business Decision:**`, and `**Recommended Change:**`.
- Use inline code for literals, identifiers, routes, and file paths where helpful.
- Use Markdown horizontal rules between findings.
- Do not wrap the entire review in a fenced code block.

Lead with findings. Do not use Markdown tables by default. Review tables often force horizontal scrolling in a terminal or PR comment and are harder to read than stacked finding blocks.

Present confirmed findings as a priority-sorted sequence of compact finding blocks. Give each finding its own short heading, then place the supporting fields on separate lines underneath it.

Separate findings with a Markdown horizontal rule `---` on its own line so each issue stands out clearly. Do not put a divider before the first finding; place one between findings only.

Never label user-facing findings as `P0`, `P1`, `P2`, or `P3`. Always use the human-readable priority words from the rubric: `Critical`, `High`, `Medium`, or `Low`.

Use this block shape for each finding:

- `### Critical: IAppRepository accumulates unrelated data-migration and reporting concerns`
- `**Impact:** Routine changes become risky because one shared repository interface mixes generic CRUD with report-locking, migration orchestration, and metadata concerns.`
- `**Evidence:** generate.core/Interfaces/Repositories/App/IAppRepository.cs:55-74, generate.infrastructure/Repositories/App/AppRepository.cs`
- `**Change Risk:** High`
- `**Business Decision:** Yes`
- `**Recommended Change:** Extract the "Extended Methods" into purpose-built services that depend on IAppRepository, rather than growing the repository itself.`

Example:

## Findings

### Critical: IAppRepository accumulates unrelated data-migration and reporting concerns
**Impact:** Routine changes become risky because one shared repository interface mixes generic CRUD with report-locking, migration orchestration, and metadata concerns.
**Evidence:** `generate.core/Interfaces/Repositories/App/IAppRepository.cs:55-74`, `generate.infrastructure/Repositories/App/AppRepository.cs`
**Change Risk:** High
**Business Decision:** Yes
**Recommended Change:** Extract the "Extended Methods" into purpose-built services that depend on `IAppRepository`, rather than growing the repository itself.

---

### High: GenerateReportController duplicates near-identical report-lookup endpoints and bypasses the service layer
**Impact:** Fixes can drift because the same report-lookup logic is repeated across many similar controller actions, and some actions query `IAppRepository`/`IRDSRepository` directly instead of going through `IGenerateReportService`.

Keep each field to one or two short sentences. Let text wrap naturally. If two evidence references are enough, prefer two over a longer list.

If multiple findings share context, add a short `## Notes` section after the findings. Insert a Markdown horizontal rule `---` before `## Notes` so it is clearly separated from the last finding. Only use a Markdown table when the user explicitly asks for one.

Always pair the recommended change with the change-risk level and business-decision flag. Treat change risk as the likelihood that implementing the fix will cause regressions, require broad coordination, or reshape shared behavior. Mark business decision as `Yes` when the best fix changes architecture direction, ownership boundaries, accepted layering, or investment tradeoffs that teams must choose deliberately rather than as a routine refactor.

If there are no confirmed findings, say that explicitly and mention residual risks or testing gaps.

## Review Notes

- Review both frontend and backend when both exist.
- Pay extra attention to `IAppRepository`/`AppRepository`, infrastructure services, Angular API wrapper services, guards/interceptors, and `Program.cs` registration because one maintainability issue there can affect many workflows.
- If a cleaner or newer pattern already exists elsewhere in the repo (for example, a feature that does route business logic through its service layer instead of querying repositories directly from the controller), call out the inconsistency.
- Treat change amplification and hidden coupling as more important than cosmetic code-style issues.
- Keep summaries short. Do not bury findings under an architecture overview.
