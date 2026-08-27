# Generate Performance Focus

Use this reference to adapt a performance review to the Generate repository structure.

## Backend Starting Points

- `generate.web/Program.cs`: Startup cost, service/DbContext registration, middleware order, authentication setup (Embedded/OAuth/AD), Swagger, and SPA hosting for the Angular `ClientApp`.
- `generate.background/Program.cs`: Host bootstrapping, Hangfire server/storage registration (`AddHangfire`, `AddHangfireServer`, `UseSqlServerStorage`), and repository/service DI for migration and update jobs.
- `generate.web/Controllers/Api/` and `generate.web/Controllers/Web/`: Endpoints that fan out into many repository calls, file operations, report generation, or large payload shaping.
- `generate.background/Controllers/DataMigrationController.cs` and `BackgroundUpdateController.cs`: Entry points that kick off Hangfire-backed migration and metadata-update jobs — check for missing batching, checkpointing, or cancellation support given these can run over full student/organization datasets.

## Data Access Starting Points

- `generate.infrastructure/Repositories/RepositoryBase.cs`: Shared generic CRUD base — connection/`DbContext` lifetime, `AsNoTracking` usage (or lack of it) on read paths, default `skip`/`take` behavior (note `take: 0` means "no limit"), and command-timeout overrides (`SetCommandTimeout`) around bulk deletes and raw SQL execution.
- `generate.infrastructure/Repositories/{App,IDS,RDS,Staging}/`: LINQ-to-EF query shape, `FromSqlRaw`/`ExecuteSqlRaw` calls into stored procedures, parameterization, result-set size, repeated lookups, and any hand-rolled `SqlConnection`/`SqlCommand`/`SqlDataReader` row-by-row mapping (see `FactStudentCountRepository.Get_MembershipReportData`).
- `generate.database/StoredProcedures/Create/`: Stored procedure, table, index, and view changes that shape production query cost. Pay particular attention to procedures that build dynamic SQL with `CURSOR` + `sp_executesql` — this is a widespread pattern (dozens of procedures) where a per-report/per-category/per-organization-level loop generates and executes a separate SQL statement on each iteration instead of one set-based query. Examples: `RDS.Insert_CountsIntoReportTable`, `RDS.Create_ReportData`, `RDS.Create_ReportData_ZeroCounts`, `App.Migrate_Data`.
- `generate.database/Indexes/`, `Views/Create/`, `Functions/Create/`: Supporting objects whose absence or shape can force full scans in the procedures above.

## Frontend Starting Points

- `generate.web/ClientApp/src/app/app.module.ts` and `app-routing.module.ts`: Eager vs. lazy module loading. Note `resources`, `settings`, and `reports` are wired through `loadChildren` but also flagged `data: { preload: true }`, so they still load shortly after the app becomes idle — treat "lazy" claims in this codebase with suspicion and verify against the actual preload strategy.
- `generate.web/ClientApp/src/app/services/base.service.ts`: Shared HTTP error-handling base reused across most feature services.
- `generate.web/ClientApp/src/app/shared/interceptors/HttpConfigInterceptor.ts`: Request interceptor that runs on every outgoing HTTP call (token attachment) — overhead here is paid by every screen.
- `generate.web/ClientApp/src/app/shared/components/pivottable/`, `flextable/`, and `report-library-table/`: Shared data-grid components that render large report/pivot tables and are natural rendering/change-detection hotspots.
- `generate.web/ClientApp/src/app/reports/`: `edfacts`, `sppapr`, `summary`, and `library` report screens that aggregate multiple API calls and render large result sets — check for duplicate fetches, sequential (non-`forkJoin`) HTTP calls, and missing pagination/virtualization.

## Repo-Specific Hotspots

- Report screens (`reports/edfacts`, `reports/sppapr`, `reports/summary`, `reports/library`) that call several report/topic/category API endpoints sequentially through shared Angular services instead of combining them.
- Stored procedures that regenerate an entire report table (`DELETE` + cursor-driven re-`INSERT`) for a submission year rather than updating incrementally, especially when triggered repeatedly during report configuration/testing.
- Hangfire migration jobs (`generate.background`) that move data across the Staging -> IDS/ODS -> RDS pipeline for a full school year without batching, checkpointing, or the ability to resume after a partial failure.
- File/import/export, download, and attachment workflows that can move large payloads or duplicate serialization work.
- Startup or SPA-hosting work in `generate.web/Program.cs` (e.g., Angular CLI dev-server bridging via `UseSpa`) that adds cold-start latency, though this mainly affects local development, not production.
- Controller actions that chain several repository calls across `App`, `IDS`, `RDS`, and `Staging` `DbContext`s and materialize large result sets before mapping to response/view models.
