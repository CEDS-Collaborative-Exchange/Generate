# Generate Usability Focus

Use this reference to adapt a usability review to the Generate repository structure. Generate is CIID's EDFacts/IDEA reporting tool for State Education Agency (SEA) data-management staff — treat it as a data-heavy internal tool where task completion, correctness confidence, and error recovery matter more than visual polish.

## App Shell And Shared Behavior

- `generate.web/ClientApp/src/app/app.component.ts` and `app.component.html`: global shell, skip-to-content link, `app-app-drawer` navigation, `generate-app-header`, `generate-app-footer`, and the `router-outlet`.
- `generate.web/ClientApp/src/app/app.module.ts` and `app-routing.module.ts`: route wrappers, `LoginGuard`, `AdminGuard`, and `ConfirmationGuard` (an unsaved-changes `canDeactivate` guard that opens a confirmation dialog — check that feature routes actually wire it up when the underlying form can lose unsaved work).
- `generate.web/ClientApp/src/app/shared/interceptors/HttpConfigInterceptor.ts`: the single HTTP interceptor — user-facing error routing and messaging behavior largely flows through here and through each feature component's own error handling, since there is no dedicated shared error-interceptor/error-handler service layer.
- `generate.web/ClientApp/src/app/services/app/user.service.ts` and `services/app/auth.service.ts`: session state and authentication transitions.

## Shared UX Infrastructure

- `generate.web/ClientApp/src/app/services/app/` and `services/ods/`: report, data-migration, toggle, and ODS API wrappers reused across many features.
- `generate.web/ClientApp/src/app/shared/components/dialog/`: the `generate-app-dialog` wrapper used for most confirm/add/edit dialogs.
- `generate.web/ClientApp/src/app/shared/components/upload/`: `mat-dialog`-based upload flow with per-file progress bars — the newer, Angular-Material-first pattern, in contrast to the legacy MDL dialogs elsewhere.
- `generate.web/ClientApp/src/app/shared/components/breadcrumbs.component.*` and `pagetitle.component.*`: route/context orientation used at the top of nearly every feature page.
- `generate.web/ClientApp/src/app/shared/components/combo-box/`, `autocomplete/`, `datepicker/`, `flextable/`, `pivottable/`, `report-library-table/`: shared data-entry and data-display UX, including `@generic-ui/ngx-grid` (`gui-grid`) grid usage.

## Repo-Specific Hotspots

- `generate.web/ClientApp/src/app/reports/`: `edfacts/`, `sppapr/`, `summary/`, and `library/` — report selection, filtering, generation, and download flows that are core to the app's purpose.
- `generate.web/ClientApp/src/app/settings/datastore/`: staging/ODS/RDS data-migration workflows (`datastore.component.*`, `odsmigration.component.*`, `rdsmigration.component.*`, `reportmigration.component.*`) — long-running background jobs with progress polling, cancel actions, and confirmation dialogs; a common source of unclear in-progress/blocked states.
- `generate.web/ClientApp/src/app/settings/toggle/`: assessment/question/section toggle configuration — filterable, sortable tables with add/edit/delete dialogs (see `toggle-assessment.component.html` for the representative pattern: template-driven form with raw `#ref` inputs, client-side sort/filter/paginate, and separate add/edit vs. delete dialogs).
- `generate.web/ClientApp/src/app/settings/metadata/` and `settings/update/`: metadata configuration and application update flows.
- `generate.web/ClientApp/src/app/resources/tutorials/`, `home/`, and `about/`: lower-risk public-facing and reference content.

## Backend Touchpoints

- `generate.web/Controllers/Api/App/*.cs`: report generation (`GenerateReportController`), file submission/export (`FileSubmissionController`), data migration (`DataMigrationController`, `DataMigrationHistoryController`), toggle configuration (`ToggleAssessmentController` and related), CEDS connection, and app-update endpoints. `FileSubmissionController.Get` is a concrete example of a download endpoint that streams the response body directly with no try/catch — an exception mid-stream produces a truncated file with no user-facing explanation.
- `generate.web/Controllers/Api/ODS/*.cs`: organization, person, grade-level, assessment-type, and performance-level lookups that back combo-box and filter UI — validation and error responses here shape how confusing those controls feel.
- `generate.web/Controllers/Web/AccountController.cs` and `ErrorController.cs`, plus `generate.web/Views/App/`, `Views/Error/`, and `Views/Shared/` Razor views: login and server-rendered error-page UX.

## Practical Review Heuristics

- Assume most confirmed findings will be in Angular templates, component logic, and shared services, but check backend controllers whenever messages, statuses, or downloads look awkward — this backend has thin/no centralized error handling, so per-endpoint gaps are common.
- Give extra scrutiny to flows that mix routing, forms, dialogs, and API calls (data migration and toggle-configuration screens especially) because they often hide the most user friction.
- The frontend mixes legacy Material Design Lite (`mdl-*`) screens with newer Angular Material screens; when a clearer or more consistent pattern already exists elsewhere in the repo (e.g. the Angular Material upload dialog vs. an MDL-based dialog), use that inconsistency as evidence.
- Treat "can a user finish the task confidently?" as the primary test, not just "does the screen technically work?"
