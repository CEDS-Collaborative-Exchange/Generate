---
name: reviewing-documentation
description: Perform repository-grounded documentation code reviews and produce a prioritized list of concrete documentation issues or concerns with file and line references. Use when the user asks for a documentation review, code comment review, API documentation review, developer-documentation review, inline-doc review, docstring review, self-descriptiveness review, knowledge-transfer review, or documentation quality assessment for the Generate codebase (Angular frontend, ASP.NET Core backend, SQL Server database scripts, DTOs/models, and data-migration workflows), especially when the documentation should work well for both human readers and AI systems. Evaluate documentation quality across the Angular ClientApp, the ASP.NET Core API and web controllers, generate.core contracts, and generate.database SQL scripts, and present confirmed findings in Markdown sorted by Critical, High, Medium, and Low with file and line references.
---

# Reviewing Documentation

Review the code that exists before making claims. Prefer concrete documentation gaps that raise onboarding cost, misuse risk, or interpretation ambiguity over generic "needs more comments" advice.

## Generate Stack Focus

Tailor the review to this repository's stack and layout:

- Backend: ASP.NET Core (.NET 10) split across `generate.web` (Controllers/Api/{App,ODS}, Controllers/Web, Razor Views, Security, Helpers, Utilities, Updates, Config), `generate.core` (Dtos/{App,ODS,RDS}, Models/{App,IDS,RDS,Staging}, Interfaces/{Helpers,Repositories,Services}, ViewModels, Examples), and `generate.infrastructure` (Contexts, Repositories, Services, Helpers) where the interfaces defined in `generate.core` are actually implemented. Supporting projects include `generate.filestorage`, `generate.background`, `generate.console`, `generate.shared`, and `generate.update`.
- Data and contracts: SQL Server access through repositories/services in `generate.infrastructure`, raw SQL objects versioned as individual files in `generate.database` (`Functions/`, `StoredProcedures/`, `Tables/`, `TableTypes/`, `Views/`, each split into `Create`/`Drop`), release-specific migration scripts under `generate.database/VersionUpdates/<version>/`, and request/response contracts under `generate.core/Dtos` and `generate.core/ViewModels`.
- Frontend: Angular 20 SPA in `generate.web/ClientApp/src/app`, organized by feature (`about/`, `home/`, `reports/{edfacts,library,sppapr,summary}/`, `settings/{datastore,metadata,toggle,update}/`, `resources/`, `services/`, `shared/`), with typed models, route-heavy modules, and large reactive/report-building components where naming and inline comments carry most of the explanatory burden.
- Existing repo conventions (verify locally, since they vary by area): C# controllers, interfaces, and DTOs in this repo generally do **not** use `/// <summary>` XML doc comments — comment coverage is sparse, inline `//` notes (sometimes author-initialed, e.g. old "MER changed to..." notes) and commented-out dead code are common instead of structured docs. Swagger (`AddSwaggerGen`/`UseSwaggerUI`) is wired up in `generate.web/Program.cs`, but the project does not enable `GenerateDocumentationFile`, so Swagger only exposes auto-generated schema shapes, not authored summaries — flag this gap concretely rather than assuming Swagger already carries rich docs. `generate.database` stored procedures frequently open with a `/* ... */` block comment stating a date, a short purpose statement, and a numbered list of assumptions/preconditions, plus inline `--` comments beside parameters showing example values or defaults; table scripts sometimes carry a one-line `--` header describing the table's purpose. Column-level metadata (e.g. `Required`, `Lookup`) is also captured as queryable schema documentation via `sp_addextendedproperty` calls immediately after `CREATE TABLE` — treat missing or incorrect extended properties as a documentation gap, not just missing comments. `generate.database/README.md` explicitly requires that `VersionUpdates/<version>/*.MetaData.sql` and `*.TableChanges.sql` files "provide documentation in the file to explain why the changes were required" — check whether release scripts actually meet that stated bar. Angular services and components rely on typed models, DI, and naming rather than JSDoc; JSDoc-style blocks are rare, so do not penalize their absence where names and types already carry the meaning.

## Workflow

1. Identify the code paths, interfaces, and files that future maintainers or AI systems would rely on to understand behavior without running the app.
2. Read only the files needed to trace whether the current documentation explains intent, inputs, outputs, constraints, side effects, and workflow meaning. In this repo, start with API/Web controllers, `generate.core` interfaces/DTOs/ViewModels, `generate.infrastructure` repositories and services, `generate.database` stored procedures/tables/version-update scripts, and Angular startup/shared code.
3. Use [references/documentation-review-checklist.md](references/documentation-review-checklist.md) as the default checklist. Use [references/generate-stack-documentation.md](references/generate-stack-documentation.md) for repo-specific hotspots and interpretation guidance.
4. For each suspected issue, confirm the missing or misleading documentation surface, the concrete reader task it blocks, and why code alone is unlikely to answer the question efficiently. Do not report speculative findings that amount to personal style preference.
5. Spend most time on gaps that make public APIs, shared abstractions, workflow-heavy components, or data contracts hard to understand for both human engineers and AI-assisted tooling.

## Finding Standard

Only report a finding when all of these are true:

- The documentation problem is present in code comments, naming, structure, or generated-doc surfaces.
- A realistic reader or consumer path reaches it.
- The impact is meaningful and not purely theoretical.

When the evidence is incomplete, say so explicitly and label it as an assumption or open question instead of a confirmed finding.

## Human And AI Documentation Standard

Treat documentation as successful only when it helps both:

- Humans quickly understand purpose, workflow, and constraints without reverse-engineering every call path.
- AI systems infer intent, data shape, and side effects from stable names, structured comments, summaries, parameter descriptions, and predictable file organization.

Prefer documentation that is concrete, structured, and close to the code over vague prose or stale historical noise.

## Priority Rubric

Sort findings from highest to lowest priority:

- `Critical`: Documentation is missing or misleading on a shared interface, workflow, or contract in a way that is likely to cause incorrect implementation, dangerous misuse, or repeated regressions (for example, an undocumented EDFacts/SPP-APR submission or migration step that reshapes state data).
- `High`: Major documentation gap in commonly changed or widely reused code, such as ambiguous controllers, repositories, services, DTOs, startup wiring, migration stored procedures, or large Angular report/settings components where intent and constraints are not inferable quickly.
- `Medium`: Confirmed documentation issue with narrower scope, stronger preconditions, or partial mitigation already present in naming or adjacent files.
- `Low`: Local cleanup, consistency, wording, or formatting issue that still reduces clarity but has limited present-day impact.

Prefer fewer, higher-confidence findings over long speculative lists.

## What To Look For

- Shared contracts, DTOs, repositories, services, or controllers whose names and comments do not explain what they actually do, return, require, or mutate.
- Stale comments, commented-out dead code, or author-initialed historical notes that contradict current behavior or obscure the useful explanation.
- Block comments in SQL stored procedures (or their absence) that no longer match the procedure's actual parameters, preconditions, or side effects.
- Public methods, endpoints, and interfaces with undocumented inputs, validation expectations, status transitions, or failure behavior — especially where Swagger is reachable but carries no authored summary because `GenerateDocumentationFile` is not enabled.
- Angular components, forms, and services (particularly report-building and migration/settings workflows) whose logic is hard to follow because the code lacks task-level explanation.
- Domain models and DTOs whose property meanings, units, enum semantics, or special sentinel values are unclear.
- Missing or incorrect `sp_addextendedproperty` metadata (`Required`, `Lookup`, etc.) on table columns relative to actual behavior.
- `VersionUpdates/<version>/*.MetaData.sql` or `*.TableChanges.sql` files that omit the "why" explanation the repo's own `generate.database/README.md` calls for.
- TODOs, comments, or historical notes that signal uncertainty without explaining the current intended behavior.
- Naming, foldering, and structure choices that make AI retrieval or summarization harder because the code lacks stable semantic cues.

## Output Format

Return the review as Markdown.

Use Markdown structure intentionally so findings are easy to scan.

- Start with a short `## Findings` heading.
- Give each finding its own `### <Priority>: <Short Title>` heading.
- Put supporting fields on separate lines with bold labels such as `**Impact:**`, `**Evidence:**`, `**Change Risk:**`, `**Business Decision:**`, and `**Recommended Change:**`.
- Use inline code for literals, identifiers, routes, and file paths where helpful.
- Use Markdown horizontal rules between findings.
- Do not wrap the entire review in a fenced code block.

Lead with findings. Avoid Markdown tables by default — stacked finding blocks stay readable in a terminal and in rendered Markdown alike, where wide tables tend to wrap awkwardly or force horizontal scrolling.

Present confirmed findings as a priority-sorted sequence of compact finding blocks. Give each finding its own short heading, then place the supporting fields on separate lines underneath it.

Separate findings with a Markdown horizontal rule `---` on its own line so each issue stands out clearly. Do not put a divider before the first finding; place one between findings only.

Never label user-facing findings as `P0`, `P1`, `P2`, or `P3`. Always use the human-readable priority words from the rubric: `Critical`, `High`, `Medium`, or `Low`.

Use this block shape for each finding:

- `### High: Misleading endpoint summary`
- `**Impact:** Maintainers and AI tooling can infer the wrong contract from the current docs.`
- `**Evidence:** path/to/file:line, path/to/other-file:line`
- `**Change Risk:** Low`
- `**Business Decision:** No`
- `**Recommended Change:** Update the summary to describe the real behavior and constraints.`

Example:

## Findings

### High: Misleading endpoint summary
**Impact:** Maintainers and AI tooling can infer the wrong contract from the current docs.
**Evidence:** path/to/file:line
**Change Risk:** Low
**Business Decision:** No
**Recommended Change:** Update the summary to describe the real behavior and constraints.

---

### Medium: DTO property meaning is undocumented
**Impact:** Readers must infer sentinel values and units from usage.

Keep each field to one or two short sentences. Let text wrap naturally. If two evidence references are enough, prefer two over a longer list.

If multiple findings share context, add a short `## Notes` section after the findings. Insert a Markdown horizontal rule `---` before `## Notes` so it is clearly separated from the last finding. Only use a Markdown table when the user explicitly asks for one.

Always pair the recommended change with the change-risk level and business-decision flag. Treat change risk as the likelihood that implementing the fix will cause regressions, require broad coordination, or reshape shared behavior. Mark business decision as `Yes` when the best fix changes documentation policy, externally communicated contract meaning, workflow expectations, or naming conventions that teams must explicitly align on rather than accept as a routine code correction.

If there are no confirmed findings, say that explicitly and mention residual risks or documentation gaps that still require runtime or domain knowledge to verify.

## Review Notes

- Review both frontend (`generate.web/ClientApp`) and backend (`generate.web`, `generate.core`, `generate.infrastructure`, `generate.database`) when both exist for the area under review.
- Pay extra attention to shared contracts and shared services because documentation issues there multiply across the codebase.
- Distinguish missing documentation from intentionally self-explanatory code; do not ask for comments where clear naming and structure already do the job.
- Treat stale or misleading comments as worse than absent comments.
- Keep summaries short. Do not bury findings under an architecture overview.
