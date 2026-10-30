---
name: reviewing-stability
description: Perform repository-grounded stability code reviews of the Generate codebase (CIID's EDFacts/SPP-APR reporting tool for State Education Agencies) and produce a prioritized list of concrete defects, breakage risks, or reliability concerns with file and line references, covering the Angular 20 frontend, .NET 10/ASP.NET Core backend, SQL Server data pipeline, Hangfire background jobs, and versioned schema migrations. Use when the user asks for a stability review, defect review, reliability review, regression-risk review, runtime-failure review, error-handling review, null-safety review, async-defect review, state-consistency review, migration-safety review, background-job review, or fragile-workflow assessment for this repository.
---

# Reviewing Stability

Review the code that exists before making claims. Prefer concrete, reachable defect risks over generic "needs more tests" advice.

## Generate Stack Focus

Tailor the review to this repository's stack and layout:

- Backend: .NET 10 / ASP.NET Core across several entry-point projects — `generate.web` (`Controllers/Api/{App,ODS}/*.cs`, `Controllers/Web/*.cs`, minimal-hosting `Program.cs`), `generate.background` (Hangfire-triggered endpoints in `Controllers/`), `generate.update` (`Controllers/UpdateController.cs`), and `generate.console`. Business logic and orchestration live in `generate.infrastructure/Services/` and `generate.infrastructure/Repositories/`; contracts live in `generate.core/Interfaces/{Services,Repositories,Helpers}/`.
- Data and migration: SQL Server via EF Core DbContexts (`AppDbContext`, `StagingDbContext`, `IDSDbContext`/ODS, `RDSDbContext`) plus raw-SQL objects under `generate.database/{Functions,StoredProcedures,Tables,Views}/{Create,Drop}` and versioned schema changes under `generate.database/VersionUpdates/<version>/` (e.g. `11.0`, `14.0`) that bundle Create/Drop scripts, jobs, and metadata together — a step that fails partway through a version update can leave schema state and app version out of sync. `generate.infrastructure/Services/MigrationService.cs` drives the Staging→ODS→RDS data pipeline through Hangfire jobs (`IHangfireHelper`); its `CancelMigration` loops deleting Hangfire `ProcessingJobs` while new jobs may still be enqueuing — worth scrutinizing for races.
- Background and upgrade flows: `generate.background` hosts Hangfire-triggered controllers (`DataMigrationController`, `BackgroundUpdateController`) that call `IAppUpdateService`/`IHangfireHelper` to download, execute, and trigger site updates; `generate.update/Controllers/UpdateController.cs` surfaces pending update packages by version. `generate.overnighttest/Worker.cs` is a nightly regression harness whose `RunMigration` polls migration status via a raw `while (true) { Thread.Sleep(TimeSpan.FromSeconds(30)); ... }` loop with no timeout or max-attempt guard, and most command handlers funnel any exception to `ExitWithCode(...)` — a process-level hard-exit failure pattern worth checking for lost diagnostics or partial cleanup.
- Frontend: Angular 20.3 SPA at `generate.web/ClientApp/src/app`, largely `NgModule`-based (`standalone: false`) rather than fully standalone. Feature areas include `settings/datastore/` (ODS/RDS/report migration UIs), `reports/{edfacts,library,sppapr,summary}/`, `resources/`, and `about/`. Services under `services/{app,ods}/*.service.ts` wrap HTTP calls in `.pipe(map, tap, catchError)`; components such as `settings/datastore/rdsmigration.component.ts` hold manual polling state (`refreshInterval`) and implement `OnDestroy` for migration-status refresh — a recurring area for stale subscriptions, double-submits, or missed cleanup. `shared/interceptors/HttpConfigInterceptor.ts` and `shared/guards/{admin,confirmation,login}.guard.ts` are cross-cutting and worth checking for silent failure modes since they affect every request/route.
- Common repo hotspots: `generate.infrastructure/Services/MigrationService.cs`, `generate.infrastructure/Helpers/HangfireHelper.cs`, `generate.background/Controllers/*.cs`, `generate.update/Controllers/UpdateController.cs`, `generate.database/VersionUpdates/<version>/`, `generate.web/ClientApp/src/app/settings/datastore/*`, and `generate.web/ClientApp/src/app/shared/components/upload/*` (file submission flows).

## Workflow

1. Identify the workflow, contract, or state transition that could fail in production and what user-visible or data-integrity impact that failure would have.
2. Read only the files needed to trace success, failure, retry, null, empty, concurrency, and cleanup paths. In this repo, start with `generate.web/Program.cs` and DI wiring, controller actions (`Controllers/Api`, `Controllers/Web`), Hangfire-triggered background controllers (`generate.background`), migration and repository services (`generate.infrastructure/Services`, `generate.infrastructure/Repositories`), versioned schema updates (`generate.database/VersionUpdates/<version>/`), and Angular services/components that chain HTTP calls, poll status, or perform multi-step submit flows.
3. Use [references/stability-review-checklist.md](references/stability-review-checklist.md) as the default checklist. Use [references/generate-stack-stability.md](references/generate-stack-stability.md) for repo-specific hotspots and interpretation guidance.
4. For each suspected issue, confirm the failing path, the triggering condition, the observable effect, and why existing guards, exception handling, or validation do not fully prevent it. Do not report speculative findings without a plausible execution path.
5. Spend most time on issues that can cause crashes, corrupted or inconsistent state, broken submissions, stuck migrations, lost updates, misleading success states, unsafe schema migrations, or repeated regressions in shared paths.

## Finding Standard

Only report a finding when all of these are true:

- The defect risk is present in code or configuration.
- A realistic execution path reaches it.
- The impact is meaningful and not purely theoretical.

When the evidence is incomplete, say so explicitly and label it as an assumption or open question instead of a confirmed finding.

## Priority Rubric

Sort findings from highest to lowest priority:

- `Critical`: Likely production failure, data corruption, incorrect authorization or workflow state, app startup failure, or a shared path that can take down a core user flow.
- `High`: Strong risk of broken submissions, user-visible runtime errors, inconsistent saved state, duplicate actions, lost updates, or widespread regressions in commonly used code.
- `Medium`: Confirmed defect risk with narrower scope, stronger preconditions, lower frequency, or partial mitigation already present.
- `Low`: Defense-in-depth issue, local fragility, or smaller correctness concern with limited present-day blast radius.

Prefer fewer, higher-confidence findings over long speculative lists.

## What To Look For

- Controller and service flows that perform multi-step writes without clear rollback, compensation, or failure handling — e.g. report-lock toggling paired with Hangfire job dispatch in `MigrationService.MigrateData`, or version-update package execution in `generate.update`/`generate.background`.
- Catch blocks that swallow errors, replace them with misleading success behavior, or hide the original fault source — including patterns like `catch (Exception ex) { return BadRequest(ex); }` that leak exception details to callers instead of translating them.
- Null, empty, or missing-data assumptions on request models, route parameters, DTOs (`generate.core/Dtos/{App,ODS,RDS}`), query results, and configuration values (`AppSettings`, `DataSettings`).
- Async or subscription-heavy Angular code that can double-submit, race, leak subscriptions, or leave the UI in a stale state after failure — especially manual polling intervals (e.g. `refreshInterval` in migration components) and multi-request `forkJoin`/chained-subscribe sequences.
- Startup and DI wiring differences across the multiple entry-point projects (`generate.web`, `generate.background`, `generate.update`, `generate.console`) that can break authentication, exception handling, or request processing in one host but not another.
- Shared services or repositories whose failure semantics are unclear, inconsistent, or different from adjacent code paths callers likely expect (e.g. `IAppRepository`, `IRDSRepository`, `IHangfireHelper`).
- File upload, download, and document-processing paths (`shared/components/upload/*`, `FileSubmissionController`, `FSMetadataCallController`) and EDFacts/SPP-APR report-generation flows that can partially succeed, orphan records, or misreport status when one step fails.
- Hangfire background jobs, the nightly regression worker (`generate.overnighttest`), and version-update/upgrade flows that assume connectivity, ordering, or environment conditions that are not guaranteed — including unbounded polling loops and hard `ExitWithCode` exits that may skip cleanup.
- Versioned schema migrations under `generate.database/VersionUpdates/<version>/` where Create/Drop scripts, jobs, and metadata changes are not clearly ordered, idempotent, or reversible if one step fails partway through.
- Fragile branching, duplicated logic, magic strings, or large commented-out code blocks left alongside live logic (a recurring pattern in `MigrationService`) where one path was updated but a sibling path — live or dead — was not.
- Missing guards around repeated migration triggers, parallel Hangfire job dispatch, stale cached migration/update status, or dependent API calls in large Angular components.

## Output Format

Return the review as Markdown.

Use Markdown structure intentionally so findings are easy to scan.

- Start with a short `## Findings` heading.
- Give each finding its own `### <Priority>: <Short Title>` heading.
- Put supporting fields on separate lines with bold labels such as `**Impact:**`, `**Evidence:**`, `**Change Risk:**`, `**Business Decision:**`, and `**Recommended Change:**`.
- Use inline code for literals, identifiers, routes, and file paths where helpful.
- Use Markdown horizontal rules between findings.
- Do not wrap the entire review in a fenced code block.

Lead with findings. Do not use Markdown tables by default. In this app, review tables often force horizontal scrolling and are harder to read than stacked finding blocks.

Present confirmed findings as a priority-sorted sequence of compact finding blocks. Give each finding its own short heading, then place the supporting fields on separate lines underneath it.

Separate findings with a Markdown horizontal rule `---` on its own line so each issue stands out clearly. Do not put a divider before the first finding; place one between findings only.

Never label user-facing findings as `P0`, `P1`, `P2`, or `P3`. Always use the human-readable priority words from the rubric: `Critical`, `High`, `Medium`, or `Low`.

For normal user-facing reviews, do not emit `::code-comment` directives. The app surfaces them as separate finding cards, so they are not internal-only. Only emit `::code-comment` when the user explicitly wants inline review comments, line-specific callouts, or code annotations.

Use this block shape for each finding:

- `### High: Retry path can double-submit records`
- `**Impact:** Users can trigger duplicate writes and inconsistent state in a common workflow.`
- `**Evidence:** path/to/file:line, path/to/other-file:line`
- `**Change Risk:** Medium`
- `**Business Decision:** No`
- `**Recommended Change:** Add idempotency or disable repeated submission until completion.`

Example:

## Findings

### High: Retry path can double-submit records
**Impact:** Users can trigger duplicate writes and inconsistent state in a common workflow.
**Evidence:** path/to/file:line
**Change Risk:** Medium
**Business Decision:** No
**Recommended Change:** Add idempotency or disable repeated submission until completion.

---

### Medium: Null result is treated as success
**Impact:** The UI can show a completed workflow even when the write never happened.

Keep each field to one or two short sentences. Let text wrap naturally. If two evidence references are enough, prefer two over a longer list.

If multiple findings share context, add a short `## Notes` section after the findings. Insert a Markdown horizontal rule `---` before `## Notes` so it is clearly separated from the last finding. Only use a Markdown table when the user explicitly asks for one.

Always pair the recommended change with the change-risk level and business-decision flag. Treat change risk as the likelihood that implementing the fix will cause regressions, require broad coordination, or reshape shared behavior. Mark business decision as `Yes` when the best fix changes workflow guarantees, retry or consistency semantics, tolerated failure modes, or operational expectations that stakeholders must agree on rather than accept as a routine bug fix.

If there are no confirmed findings, say that explicitly and mention residual risks or missing runtime evidence.

## Review Notes

- Review both frontend and backend when both exist.
- Pay extra attention to long controller methods, migration/background-job orchestration (`MigrationService`, `HangfireHelper`, `generate.background`, `generate.overnighttest`), versioned schema migrations (`generate.database/VersionUpdates`), and shared Angular services, because defects there often fan out widely.
- Treat misleading error handling and inconsistent state transitions as more important than stylistic cleanup.
- If a safer pattern already exists elsewhere in the repo, call out the inconsistency.
- Keep summaries short. Do not bury findings under an architecture overview.
