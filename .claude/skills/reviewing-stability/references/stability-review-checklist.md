# Stability Review Checklist

Use this checklist to guide a repository review, then spend most of the time on the highest-impact confirmed defect risks.

## Triage First

- Which user workflows can mutate important data or submission/migration state?
- Which shared services, repositories, or controllers are reused broadly?
- Which failures would leave the app, a migration, or a schema update in a misleading or partially updated state?

## Generate Repo Sweep

- `generate.web/Program.cs` and DI/service registration
- `generate.web/Security/`
- `generate.web/Controllers/Api/{App,ODS}/`
- `generate.web/Controllers/Web/`
- `generate.background/Controllers/` and `generate.background/Filters/`
- `generate.update/Controllers/` and `generate.update/Startup.cs`
- `generate.infrastructure/Services/` and `generate.infrastructure/Repositories/`
- `generate.infrastructure/Helpers/HangfireHelper.cs`
- `generate.core/Interfaces/{Services,Repositories,Helpers}/` and `generate.core/Models/{App,IDS,RDS,Staging}/`
- `generate.database/VersionUpdates/<version>/`
- `generate.overnighttest/Worker.cs`
- `generate.web/ClientApp/src/app/shared/` (guards, interceptors, upload)
- Feature areas under `generate.web/ClientApp/src/app/settings/datastore/`, `reports/{edfacts,library,sppapr,summary}/`, `resources/`, and `about/`

## Core Questions

- What happens when a dependency returns null, empty, or malformed data?
- What happens when one step in a multi-step workflow (a report submission, a data migration, a version update) fails?
- Can the same action be triggered twice or concurrently — e.g. two migration triggers, two Hangfire job dispatches, a cancel racing a start?
- Does the code communicate failure accurately to callers and users, or does it leak raw exception details (`BadRequest(ex)`) while hiding the real cause?
- Is cleanup, rollback, or state reset handled when a request, background job, or subscription errors out?

## Backend Stability

- DI wiring and configuration consistency across the multiple hosting projects (`generate.web`, `generate.background`, `generate.update`, `generate.console`)
- Controller error translation and response consistency, including exception payloads returned directly to callers
- Repository and service failure semantics (`IAppRepository`, `IRDSRepository`, `IMigrationService`, `IHangfireHelper`)
- Hangfire job dispatch, cancellation, and monitoring-API usage (e.g. `MigrationService.CancelMigration` deleting `ProcessingJobs` in a loop)
- File and document I/O fault handling (uploads, EDFacts/SPP-APR file submissions, metadata calls)

## Frontend Stability

- Subscription cleanup and duplicate subscriptions, especially manual polling intervals (`refreshInterval`) and `OnDestroy` handling
- Chained HTTP calls, `forkJoin` usage, and nested subscribe callbacks in migration/report components
- Dialog, form, and save-state behavior after errors
- Double-submit and repeated-click protection on migration triggers and report generation actions
- State synchronization after create, update, delete, cancel, or upload flows

## Cross-Layer Consistency

- DTO and contract assumptions (`generate.core/Dtos/{App,ODS,RDS}`) match actual runtime behavior
- API error shape is consistent with what Angular services (`services/{app,ods}/*.service.ts`) expect in `catchError`
- Shared services do not hide failures or partial success
- Hangfire background jobs, the nightly regression worker, and version-update flows degrade safely when unavailable or when a step fails mid-sequence

## Schema Migration Safety

- Are `generate.database/VersionUpdates/<version>/` scripts ordered so Create/Drop, Jobs, and Metadata changes are applied consistently if one step fails partway through?
- Are version-update scripts idempotent or safely re-runnable if a prior run partially completed?
- Does the app version recorded after an update accurately reflect what schema state was actually applied?

## Priority Calibration

- `Critical`: Likely production failure, corrupt state, or broken core workflow
- `High`: Strong risk of frequent user-visible defects or inconsistent data
- `Medium`: Confirmed defect risk with narrower scope or stronger preconditions
- `Low`: Local fragility or defense-in-depth issue
