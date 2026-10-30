# Generate Stability Focus

Use this reference to adapt a stability review to the Generate repository structure.

## Backend Starting Points

- `generate.web/Program.cs`: minimal-hosting startup wiring, middleware order, authentication, DI registration, and endpoint mapping can create environment-specific breakage.
- `generate.web/Security/`: `ApplicationUserManager`, `SignInManager`, `EmbeddedUserManager`/`EmbeddedUserStore`, and related identity plumbing shape global authentication failure behavior.
- `generate.infrastructure/Services/MigrationService.cs`, `generate.infrastructure/Helpers/HangfireHelper.cs`, and `generate.background/Controllers/`: Hangfire-backed background work can block readiness, fail silently, or leave a data migration or site update half-complete. `MigrationService.CancelMigration` loops over `JobStorage.Current.GetMonitoringApi().ProcessingJobs(...)` deleting jobs — check whether a job enqueued mid-loop can survive cancellation or leave state marked "error" while still running.
- `generate.web/Controllers/Api/{App,ODS}/` and `Controllers/Web/`: many controllers contain long, imperative request handlers; some (e.g. `generate.background/Controllers/DataMigrationController.cs`) return `BadRequest(ex)` directly, leaking exception details instead of translating failures.
- `generate.update/Controllers/UpdateController.cs` and `generate.background/Controllers/BackgroundUpdateController.cs`: the app-upgrade path (download → execute → trigger site update) spans two separate ASP.NET Core hosts; a failure between "downloaded" and "executed" can leave the app on a stale version with no clear recovery path.

## Data And Service Starting Points

- `generate.infrastructure/Repositories/`: shared orchestration code (e.g. `AppRepository`) can produce partial updates or inconsistent outcomes when one dependency fails.
- EF Core DbContexts (`AppDbContext`, `StagingDbContext`, ODS/IDS context, `RDSDbContext`): connection, command-timeout, and exception-wrapping semantics affect nearly every data path; `generate.overnighttest/Worker.cs` explicitly raises `SetCommandTimeout` for long-running stored procedures, which is a signal that default timeouts are a real concern elsewhere too.
- `generate.database/VersionUpdates/<version>/`: each version folder bundles `Functions/`, `StoredProcedures/`, `Tables/`, `Views/`, `Indexes/`, `Jobs/`, and `Metadata/` Create/Drop scripts plus ad hoc scripts (e.g. `RemoveReferencesToIeus.sql`, `REPLACE_STAGING_VALIDATION_RULES.sql`). These run as an ordered batch during an upgrade; a script that fails partway through can leave the schema in a state that doesn't match any single version.
- `generate.core/Interfaces/Services/`, `generate.core/Interfaces/Repositories/{App,ODS,RDS,Staging}/`, and `generate.core/Models/`: contract assumptions often drive both frontend and backend behavior, so stability issues here can multiply.

## Frontend Starting Points

- `generate.web/ClientApp/src/app/shared/`: `interceptors/HttpConfigInterceptor.ts` and `guards/{admin,confirmation,login}.guard.ts` are cross-cutting — a silent failure here (e.g. a missing token, an unhandled guard rejection) can spread across every route. `shared/components/upload/` and `shared/reportcontrols/` carry file-submission and report-rendering logic used by many features.
- `generate.web/ClientApp/src/app/settings/datastore/`: `odsmigration.component.ts`, `rdsmigration.component.ts`, and `reportmigration.component.ts` drive the Staging→ODS→RDS pipeline from the UI, hold manual polling state (`refreshInterval`), and call `DataMigrationService`/`DataMigrationHistoryService`/`MigrationMessageService` — a dense area for double-submit, stale-status, and cleanup-on-destroy issues.
- `generate.web/ClientApp/src/app/reports/{edfacts,library,sppapr,summary}/`: report generation and viewing flows with many report-specific components under `shared/reportcontrols/`.
- File, import/export, and report flows: uploads (`shared/components/upload/upload.component.ts`, `upload.service.ts`), FS metadata calls (`FSMetadataCallController`), and file submissions (`FileSubmissionController`) are common places where errors leave stale UI state or orphaned server-side records.

## Repo-Specific Hotspots

- `MigrateData`/`CancelMigration` in `MigrationService.cs` mixes live logic with large commented-out blocks describing an intended-but-unused "new ETL" path — a sign that some report types may silently fall through to legacy migration logic that reviewers should trace explicitly rather than assume.
- `generate.overnighttest/Worker.cs`'s `RunMigration` polls migration status with `while (true) { Thread.Sleep(TimeSpan.FromSeconds(30)); ... }` and no timeout or attempt cap — a stuck migration status row means the nightly job hangs indefinitely.
- Repeated `try/catch { ExitWithCode(...) }` patterns in `generate.overnighttest/Worker.cs` and `catch (Exception ex) { return BadRequest(ex); }` patterns in background controllers may hide root causes or return inconsistent responses.
- Multi-step workflows that touch database state, Hangfire job state, and app-version state in one request (data migration triggers, app updates).
- Angular components with many inline `subscribe`/`pipe` calls, `forkJoin` sequences, or manual polling intervals in the `settings/datastore/` migration components.
- Shared SQL, identity, API-wrapper, or error-handling abstractions that are reused broadly, especially when adjacent code follows a safer pattern elsewhere.

## Practical Review Heuristics

- Treat partial-success paths — migration marked "error" while a Hangfire job is still processing, an app update downloaded but not executed, a version-update script that fails mid-batch — as first-class defect candidates.
- Prefer evidence of a concrete failing path over general concern about complexity.
- Missing cleanup after errors (a `refreshInterval` never cleared, a migration status never reset) is often as important as the original exception.
- When adjacent implementations handle the same scenario differently (e.g. one controller translates exceptions, another returns them raw), inspect whether one path is silently less safe.
