# Performance Review Checklist

Use this checklist to guide a repository review, then spend most of the time on the highest-impact confirmed paths.

## Triage First

- What flows are user-facing, latency-sensitive, or operationally critical?
- Which paths run most often or touch the most data (student-, school-, or LEA-level volumes)?
- Which flows deserve `Critical` or `High` attention first if they degrade — especially ones that could block an EDFacts/SPP-APR submission deadline?

## Generate Repo Sweep

- `generate.web/Program.cs`
- `generate.background/Program.cs`
- `generate.web/Controllers/Api/` and `generate.web/Controllers/Web/`
- `generate.background/Controllers/`
- `generate.infrastructure/Repositories/` and `generate.infrastructure/Repositories/RepositoryBase.cs`
- `generate.database/StoredProcedures/Create/`, `Functions/`, `Views/Create/`
- `generate.web/ClientApp/src/app/app-routing.module.ts`
- `generate.web/ClientApp/src/app/services/`, `shared/interceptors/`, and data-heavy feature modules under `reports/`

## Backend And APIs

- Repeated calls in the same request path
- Sequential I/O that could be parallelized
- Sync-over-async (`.Result`, `.Wait()`) or other blocking behavior on request threads
- Uncached expensive computation or repeated configuration loading
- Excessive serialization, logging, or response shaping
- Controllers that fan out across many repositories or services before responding

## Data Access

- N+1 queries or per-row lookups
- Missing pagination, filtering, or projection (watch `RepositoryBase.GetAll`/`Find`/`GetDistinct` calls made with `take: 0` or without `AsNoTracking` on read-only paths)
- Full-table scans implied by query shape
- Repeated materialization with `ToList`, array copies, or equivalent
- Missing index assumptions called out in code or query patterns
- Repository or stored-procedure paths that duplicate each other or fetch overlapping data in the same flow

## Stored Procedures And Dynamic SQL

- Dynamic SQL built with `CURSOR` + `sp_executesql` that executes one statement per report, category set, or organization level instead of a single set-based statement (a widespread pattern under `generate.database/StoredProcedures/Create`)
- String-concatenated SQL built from table/column names or filter values without parameterization
- Procedures that repeat the same expensive join or aggregation once per cursor iteration rather than computing it once
- Row-by-row `SqlDataReader` mapping in repository code (see `FactStudentCountRepository.Get_MembershipReportData`) instead of set-based `FromSqlRaw`/EF mapping, especially with large or unbounded `numberOfRecords` parameters
- Migration/report-generation procedures that delete-then-reinsert full report tables per submission year instead of incremental updates

## Memory And Resource Use

- Unbounded caches, queues, dictionaries, or lists
- Large object allocation churn or repeated cloning
- Streams, responses, timers, or subscriptions not disposed cleanly
- Background/Hangfire work that can pile up faster than it completes
- Large file, export, report, or attachment handling paths that buffer more than needed

## Frontend

- Re-render churn from broad state updates in `pivottable`, `flextable`, or `report-library-table` components
- Expensive computation during rendering or change detection
- Duplicate fetches or waterfall loading
- Feature modules loaded eagerly despite `loadChildren` (check `data: { preload: true }` usage in `app-routing.module.ts`) when they could stay lazy
- Large report/data tables without virtualization or pagination
- Shared Angular services (`base.service.ts`) or interceptors (`HttpConfigInterceptor`) that make many screens pay the same avoidable cost

## Jobs And Startup

- Startup code doing network or database work before readiness
- Hangfire jobs in `generate.background` scanning all rows on every run
- Missing batching, checkpointing, or incremental processing in migration jobs (Staging -> IDS/ODS -> RDS)
- Retry loops or polling patterns that amplify load
- Migration queue, scheduled task, or startup paths that add cold-start latency or delay a submission window

## Severity Calibration

- `Critical`: Likely outage, cascading failure, or severe resource exhaustion under plausible load
- `High`: Major hot-path inefficiency with broad user or system impact
- `Medium`: Confirmed but narrower inefficiency with stronger preconditions or partial mitigation
- `Low`: Local inefficiency or scale concern with limited present-day impact
