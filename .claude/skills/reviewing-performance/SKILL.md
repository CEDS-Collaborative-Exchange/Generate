---
name: reviewing-performance
description: Perform repository-grounded performance code reviews and produce a prioritized list of concrete performance issues or concerns with file and line references. Use when the user asks for a performance review, latency review, scalability review, throughput review, efficiency review, hotspot analysis, N+1 query review, memory review, CPU review, startup-time review, rendering-performance review, or bundle-size review for this Generate codebase (EDFacts/SPP-APR reporting for State Education Agencies) — its Angular frontend, ASP.NET Core web and background hosts, EF Core / raw-SQL data access, stored-procedure and reporting layer, or Hangfire background jobs.
---

# Reviewing Performance

Review the code that exists before making claims. Prefer concrete, reachable performance problems over generic advice.

## Generate Stack Focus

Tailor the review to this repository's stack and layout:

- Backend: .NET 10 ASP.NET Core. `generate.web` is the primary host (`Program.cs`, `Controllers/Api/`, `Controllers/Web/`, Razor views under `Views/`, the Angular SPA under `ClientApp/`). `generate.background` is a separate ASP.NET Core host that runs Hangfire-backed migration and update jobs (`Program.cs`, `Controllers/DataMigrationController.cs`, `Controllers/BackgroundUpdateController.cs`).
- Core/domain: `generate.core` holds `Dtos/{App,ODS,RDS}/`, `Models/{App,IDS,RDS,Staging}/`, `Interfaces/{Helpers,Repositories,Services}/`, and `ViewModels/`.
- Data access: `generate.infrastructure/Repositories/{App,IDS,RDS,Staging}/` implement the `generate.core` repository interfaces against EF Core `DbContext`s (`AppDbContext`, `IDSDbContext`, `RDSDbContext`, `StagingDbContext`), mixing LINQ-to-EF, `FromSqlRaw`/`ExecuteSqlRaw` calls into stored procedures, and raw `SqlConnection`/`SqlCommand`/`SqlDataReader` usage for high-volume report reads. `RepositoryBase` (`generate.infrastructure/Repositories/RepositoryBase.cs`) is the shared generic CRUD base most repositories build on.
- Database: `generate.database` is a large raw-SQL layer — `Functions/`, `StoredProcedures/{Create,Drop}`, `Tables/{Create,Drop}`, `TableTypes/`, `Views/{Create,Drop}`, `Indexes/`, `Jobs/`, and per-version `VersionUpdates/<version>/`. This is a data-heavy reporting app: EDFacts/SPP-APR report generation is driven largely by stored procedures that build and run dynamic SQL (many procedures under `StoredProcedures/Create` use `CURSOR` + `sp_executesql` to generate per-report/per-category/per-organization-level SQL, e.g. `RDS.Insert_CountsIntoReportTable`, `RDS.Create_ReportData`, `App.Migrate_Data`). Weight stored-procedure and query efficiency heavily in this review.
- Background/jobs: `generate.background` hosts Hangfire jobs (`AddHangfire`/`AddHangfireServer` in its `Program.cs`) that drive data migration (Staging -> IDS/ODS -> RDS) and metadata/report updates — these are long-running, data-volume-sensitive flows, not request/response endpoints.
- Frontend: Angular 20.3.x SPA at `generate.web/ClientApp` (NgModule-based, not standalone components), with `app-routing.module.ts` lazy-loading `resources`, `settings`, and `reports` feature modules via `loadChildren` — note most of them are also marked `data: { preload: true }`, so they still load shortly after bootstrap rather than truly on demand. Shared HTTP plumbing lives in `services/base.service.ts` and `shared/interceptors/HttpConfigInterceptor.ts`. Data-heavy shared UI lives in `shared/components/pivottable/`, `shared/components/flextable/`, and `shared/components/report-library-table/` — these render large report/pivot tables and are natural rendering hotspots.
- Common review starting points: `generate.web/Program.cs`, `generate.background/Program.cs`, `generate.web/Controllers/Api/`, `generate.background/Controllers/`, `generate.infrastructure/Repositories/`, `generate.infrastructure/Repositories/RepositoryBase.cs`, `generate.database/StoredProcedures/Create/`, `generate.web/ClientApp/src/app/app-routing.module.ts`, `generate.web/ClientApp/src/app/services/`, `generate.web/ClientApp/src/app/shared/components/pivottable/` and `flextable/`, and `generate.web/ClientApp/src/app/reports/`.

## Workflow

1. Identify the stack, critical user flows (report configuration, data migration, report generation/export), expensive entry points, and the likely hot paths under load — especially anything that runs per SEA/LEA/school, per submission year, or over full student/organization populations.
2. Read only the files needed to trace expensive work. In this repo, start with host bootstrap (`Program.cs` in `generate.web` and `generate.background`), controller endpoints, repository implementations in `generate.infrastructure`, the stored procedures they call in `generate.database`, Hangfire job entry points, Angular shared API services, route-heavy modules, and report/import/export flows that fan out across the App/IDS/RDS/Staging layers.
3. Use [references/performance-review-checklist.md](references/performance-review-checklist.md) as the default checklist. Use [references/generate-stack-performance.md](references/generate-stack-performance.md) for repo-specific focus areas. When a suspected issue needs more pattern guidance, also read [references/performance-hotspots.md](references/performance-hotspots.md).
4. For each suspected issue, confirm the expensive operation, the code path that triggers it, the scale factor that makes it worse (e.g., number of LEAs, schools, students, submission years, category combinations), and the likely user or system impact. Do not report speculative findings that lack a plausible degradation path.
5. Spend most time on problems that can cause outages, sustained latency spikes, runaway CPU or memory usage, database overload, excessive network chatter, or visibly degraded user experience — including long-running migration/report-generation jobs that can block a submission deadline.

## Finding Standard

Only report a finding when all of these are true:

- The costly behavior is present in code or config.
- A realistic call path or workload reaches it.
- The impact is meaningful and not purely theoretical.

When the evidence is incomplete, say so explicitly and label it as an assumption or open question instead of a confirmed finding.

## Severity Rubric

Sort findings from highest to lowest severity:

- `Critical`: Likely outage, cascading failure, or severe resource exhaustion under plausible production load; can take down a core workflow or shared dependency (e.g., blocking an EDFacts/SPP-APR submission).
- `High`: Significant latency, throughput collapse, N+1 amplification, major memory growth, or repeated expensive work in a hot path with broad user or system impact.
- `Medium`: Confirmed inefficiency with narrower blast radius, stronger preconditions, lower frequency, or partial mitigation already present.
- `Low`: Defense-in-depth improvement, local inefficiency, or maintainability concern that matters mainly at larger scale or in combination with another issue.

Prefer fewer, higher-confidence findings over long speculative lists.

## What To Look For

- Controller or job flows that traverse Angular feature components -> feature services -> `base.service.ts`/HTTP wrappers -> API controllers -> `generate.infrastructure` repositories -> stored procedures, and repeat expensive work at multiple stages.
- Raw SQL, stored procedure, or `RepositoryBase`/EF Core query shapes that over-fetch, skip projection, or trigger repeated database trips.
- Stored procedures that build dynamic SQL via `CURSOR` + `sp_executesql` (common in `generate.database/StoredProcedures/Create`) and execute one statement per report/category/organization-level combination instead of a single set-based statement — a real, widespread pattern in this repo, not a hypothetical.
- Repository methods that open a raw `SqlConnection`/`SqlCommand`/`SqlDataReader` and map rows one at a time (see `FactStudentCountRepository.Get_MembershipReportData`) with large `numberOfRecords` defaults or no pagination applied by the caller.
- Repeated database queries, N+1 access patterns, missing projections, or loading much more data than the caller needs — including `RepositoryBase.GetAll`/`Find`/`GetDistinct` calls made without `AsNoTracking` on read-only paths, or with `take: 0` (no limit).
- Per-request or per-render work that repeats immutable computation instead of caching or reusing results.
- Large in-memory materialization, unnecessary copies, unbounded collections, or retention that can drive memory pressure — especially when migrating or reporting on full student/organization populations across `Staging`/`IDS`/`RDS` contexts.
- Synchronous blocking I/O, thread starvation risks, sync-over-async (`.Result`, `.Wait()`), or expensive work on request threads that should be batched, streamed, or offloaded to a Hangfire job.
- Nested loops or repeated scans whose cost grows poorly with data size (student count, school count, submission year range).
- Chatty service-to-service calls, duplicate fetches, or sequential network/database calls that could be parallelized or collapsed.
- Missing pagination, filtering, indexing assumptions, or query shapes that will degrade badly as data grows across school years.
- Frontend rendering churn in `pivottable`/`flextable`/report-library components, expensive recomputation on every change detection cycle, oversized bundles, or feature modules loaded eagerly (note the `data: { preload: true }` flags in `app-routing.module.ts`) when they could stay lazy.
- Serialization, logging, or transformation work that is disproportionately expensive relative to business value.
- Startup, initialization, or Hangfire background-job behavior (`generate.background`) that repeats expensive setup, scans full tables every run, or blocks readiness.

## Output Format

Return the review as Markdown.

Use Markdown structure intentionally so findings are easy to scan.

- Start with a short `## Findings` heading.
- Give each finding its own `### <Severity>: <Short Title>` heading.
- Put supporting fields on separate lines with bold labels such as `**Impact:**`, `**Evidence:**`, `**Change Risk:**`, `**Business Decision:**`, and `**Recommended Change:**`.
- Use inline code for literals, identifiers, routes, and file paths where helpful.
- Use Markdown horizontal rules between findings.
- Do not wrap the entire review in a fenced code block.

Lead with findings. Do not use Markdown tables by default. In this app, review tables often force horizontal scrolling and are harder to read than stacked finding blocks.

Present confirmed findings as a severity-sorted sequence of compact finding blocks. Give each finding its own short heading, then place the supporting fields on separate lines underneath it.

Separate findings with a Markdown horizontal rule `---` on its own line so each issue stands out clearly. Do not put a divider before the first finding; place one between findings only.

Never label user-facing findings as `P0`, `P1`, `P2`, or `P3`. Always use the human-readable severity words from the rubric: `Critical`, `High`, `Medium`, or `Low`.

Use this block shape for each finding:

- `### High: N+1 query in hot path`
- `**Impact:** Request latency and database load grow linearly with result size in a common flow.`
- `**Evidence:** path/to/file:line, path/to/other-file:line`
- `**Change Risk:** Medium`
- `**Business Decision:** No`
- `**Recommended Change:** Collapse the repeated lookups into one projected query.`

Example:

## Findings

### High: N+1 query in hot path
**Impact:** Request latency and database load grow linearly with result size in a common flow.
**Evidence:** path/to/file:line
**Change Risk:** Medium
**Business Decision:** No
**Recommended Change:** Collapse the repeated lookups into one projected query.

---

### Medium: Large result set is fully materialized
**Impact:** Memory use spikes even when the caller only needs a small projection.

Keep each field to one or two short sentences. Let text wrap naturally. If two evidence references are enough, prefer two over a longer list.

If multiple findings share context, add a short `## Notes` section after the findings. Insert a Markdown horizontal rule `---` before `## Notes` so it is clearly separated from the last finding. Only use a Markdown table when the user explicitly asks for one.

Always pair the recommended change with the change-risk level and business-decision flag. Treat change risk as the likelihood that implementing the fix will cause regressions, require broad coordination, or reshape shared behavior. Mark business decision as `Yes` when the best fix changes latency-versus-cost tradeoffs, feature behavior, consistency expectations, or capacity planning choices that product or platform owners must explicitly approve.

If there are no confirmed findings, say that explicitly and mention residual risks or missing runtime evidence.

## Review Notes

- Review both frontend and backend when both exist.
- Pay extra attention to stored procedures under `generate.database/StoredProcedures/Create`, the `generate.infrastructure` repository layer, shared Angular API/base services, report generation/export flows, and Hangfire migration/update jobs in `generate.background` because they can hide high-fanout code paths that many features reuse.
- If a safer or faster pattern already exists elsewhere in the repo, call out the inconsistency.
- Treat hot-path issues as more important than one-time admin flows unless the one-time flow can block startup, core availability, or a reporting deadline.
- Keep summaries short. Do not bury findings under an architecture overview.
