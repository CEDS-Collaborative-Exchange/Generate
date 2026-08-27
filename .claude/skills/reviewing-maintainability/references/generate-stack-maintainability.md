# Generate Maintainability Focus

Use this reference to adapt a maintainability review to the Generate repository structure.

## Backend Starting Points

- `generate.web/Program.cs`: service registration, middleware order, auth setup, and background job wiring — this repo's `Startup.cs` equivalent under the .NET 10 minimal-hosting model.
- `generate.web/Controllers/Api/App/` and `Controllers/Api/ODS/`: controller sprawl, endpoint consistency, route naming, and how much business logic sits at the HTTP layer. `GenerateReportController.cs` (338 lines, roughly 20 similar `Get` overloads) is a representative example of a controller that both orchestrates business logic and reaches directly into `IAppRepository`/`IRDSRepository` instead of going through `IGenerateReportService`.
- `generate.infrastructure/Services/`: business/orchestration service implementations backing `generate.core/Interfaces/Services/I*.cs` contracts — migration services, report services, file submission services, metadata update services.
- `generate.web/Security/`, `generate.web/Helpers/`, `generate.web/Utilities/`: shared auth, permission, and cross-cutting utilities that affect most controllers.

## Data Access Starting Points

- `generate.core/Interfaces/Repositories/App/IAppRepository.cs` and its implementation `generate.infrastructure/Repositories/App/AppRepository.cs` (500 lines): a generic EF Core repository (`Create<T>`, `Find<T>`, `GetAll<T>`, `Count<T>`, etc.) that has also accreted roughly 15 unrelated "Extended Methods" — data migration orchestration, report locking, view-definition updates, metadata migration. This is this repo's closest analog to a shared "god" data-access class.
- `generate.core/Interfaces/Repositories/RDS/*.cs` and `generate.infrastructure/Repositories/RDS/`: fact/dimension repositories backing the reporting star schema.
- `generate.core/Interfaces/Repositories/{ODS,Staging}` and matching `generate.infrastructure/Repositories/{IDS,Staging}`: repositories over ingested education-data-standard entities and migration staging tables.
- `generate.database/VersionUpdates/<version>/`: versioned schema/data migration scripts. `generate.database/{Tables,Views,StoredProcedures,Functions,TableTypes}/{Create,Drop}`: canonical raw-SQL object definitions that can drift from the EF Core model shapes in `generate.core/Models/` when one is updated without the other.

## Frontend Starting Points

- `generate.web/ClientApp/src/app/services/{app,ods}/*.service.ts`: thin HTTP wrapper services extending `services/base.service.ts`; check consistency and duplication. `generateReport.service.ts` mirrors `GenerateReportController.cs` almost one-to-one, repeating the same `.pipe(map, tap, catchError)` boilerplate and hand-built query-string URLs across roughly 15 methods instead of a shared request builder.
- `generate.web/ClientApp/src/app/shared/guards/` and `shared/interceptors/`: shared auth and error-handling behavior.
- `generate.web/ClientApp/src/app/shared/components/`, `shared/reportcontrols/`, `shared/filters/`: shared UI, table, and report-rendering components.
- `generate.web/ClientApp/src/app/{reports,settings}/**/*-routing.module.ts`: route ownership and lazy-loading boundaries.
- Large feature components under `reports/edfacts`, `reports/sppapr`, `reports/library`, `reports/summary`, and `settings/{datastore,metadata,toggle,update}`: especially components that combine data-fetching, filter-state, and table-rendering logic inline.

## Repo-Specific Hotspots

- The App / ODS / IDS / RDS / Staging layering is this repo's central domain split: `App` models/DTOs/controllers are Generate's own operational schema (reports, toggles, submissions); `ODS`/`IDS` hold ingested CEDS-aligned source-system entities; `RDS` is the reporting star schema (fact/dimension tables) that EDFacts/SPP-APR reports are generated from; `Staging` holds raw tables used while migrating ODS data into RDS. A maintainability review should check whether a change respects this layering (for example, a controller reaching past its own layer, or a DTO mixing shapes from two layers) rather than treating every cross-layer reference as accidental duplication.
- `IAppRepository`/`AppRepository` growing further: a new "Extended Methods"-style addition here instead of a purpose-built service or repository is a maintainability smell — the class already spans generic CRUD, migration orchestration, and report-locking concerns.
- Controllers that reach directly into `IAppRepository`/`IRDSRepository` for query logic instead of going through their matching `I*Service`, scattering the same LINQ predicate across multiple controller actions (see `GenerateReportController.GetOptions`/`GetCatSetNameByCode`/`GetCats`, which query `IAppRepository` inline rather than through `IGenerateReportService`).
- Angular API wrapper services that duplicate URL-building and RxJS pipe boilerplate per method instead of extracting a shared helper.
- Parallel App vs. ODS vs. RDS controllers, services, and repositories that implement similar CRUD or lookup patterns with inconsistent naming or structure.
- SQL definitions under `generate.database/` drifting from the EF Core model shapes in `generate.core/Models/` when one is updated without the other.

## Practical Review Heuristics

- Assume `Program.cs`, `IAppRepository`/`AppRepository`, shared Angular API wrapper services, and large report/settings feature components are high-value review targets because they are the places most likely to become change magnets.
- Look for places where "the easiest place to add one more method" (usually `IAppRepository` or a feature's API wrapper service) is also the worst place for long-term ownership.
- Treat repeated full-stack ceremony for simple CRUD work — a new controller method, a new wrapper-service method, a new component call, each duplicating the same shape — as a maintainability smell when it increases change count without adding clear value.
- If a cleaner pattern already exists elsewhere in the repo (for example, a feature that does route business logic through its service layer instead of querying repositories directly from the controller), use that inconsistency as evidence of architectural drift.
