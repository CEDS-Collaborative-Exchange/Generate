# Generate Accessibility Focus

Use this reference to adapt an accessibility review to the Generate repository structure.

## App Shell And Global Behavior

- `generate.web/ClientApp/src/app/app.component.ts`: Root shell behavior, drawer open/close state, and route handling.
- `generate.web/ClientApp/src/app/app.component.html`: Root skip link (`Skip to main content` targeting `#app-generate-main`), the `<main id="app-generate-main">` landmark, and composition of `app-app-drawer`, `generate-app-header`, `router-outlet`, and `generate-app-footer`.
- `generate.web/ClientApp/src/app/app.module.ts`: Global NgModule imports, Azure AD/MSAL auth module wiring, and shared Angular Material modules.
- `generate.web/ClientApp/src/app/app-routing.module.ts`: Lazy-loaded feature routes (`reports`, `settings`, `resources`, `about`, `home`).

## Shared UI Infrastructure

- `generate.web/ClientApp/src/app/shared/components/app-header.component.ts`/`.html`, `app-footer.component.*`, `app-drawer/app-drawer.component.*`: Reused navigation and page chrome. Note: the primary nav block in `app-header.component.html` is wrapped in `aria-hidden="true"` while still containing real `<a routerLink>`/`(click)` links (the "Settings" menu around lines 43-52) — worth re-confirming as a starting point rather than assuming it is still accurate.
- `generate.web/ClientApp/src/app/shared/components/dialog/`, `confirmationdialog.component.*`, `ok-dialog.component.*`, `yes-no-dialog.component.ts`, `upload/dialog/dialog.component.*`: All built on Angular Material `MatDialog` (`mat-dialog-title` / `mat-dialog-content` / `mat-dialog-actions`), which normally gets CDK focus trap and focus-return behavior for free — verify no custom overrides break it.
- `generate.web/ClientApp/src/app/shared/components/report-library-table/`, `flextable/`: Angular Material `mat-table` + `MatSort` + `MatPaginator`, using `LiveAnnouncer` from `@angular/cdk/a11y` to announce sort changes (`announceSortChange`) — treat this as the existing accessible baseline pattern other tables should be compared against.
- `generate.web/ClientApp/src/app/shared/reportcontrols/`: Many small report-filter components (e.g. `c029`, `c035`, `c131`, `edenvironmentdisabilitiesage3-5`) that repeat similar form-control and label patterns across report screens.
- `generate.web/ClientApp/src/app/shared/components/autocomplete/`, `combo-box/`, `datepicker/`: Reused form controls whose labeling and keyboard behavior affects many screens.
- `generate.web/ClientApp/src/app/shared/guards/admin.guard.ts`, `confirmation.guard.ts`, `login.guard.ts`: Route guards — verify redirected or blocked states still communicate context to assistive-technology users instead of silently dead-ending.

## Repo-Specific Hotspots

- `generate.web/ClientApp/src/app/settings/toggle/toggle.component.html`: Large reactive-form survey/toggle screen. It already uses `fieldset`/`legend` and `label[for]` pairing for most controls, but the `mat-radio-group` uses `aria-labelledby="option-radio-group"`, an id that does not appear to exist anywhere in the template — re-verify and treat as a starting point rather than a confirmed finding until checked against the current file.
- `generate.web/ClientApp/src/app/settings/datastore/{datastore,odsmigration,rdsmigration}.component.html`: Admin migration status/progress screens.
- `generate.web/ClientApp/src/app/reports/{edfacts,library,sppapr,summary}/*.component.html`: Dense EDFacts/SPP-APR report tables and filters.
- `generate.web/ClientApp/src/app/shared/components/upload/`, `upload/dialog/`: File upload flow — a plain `<input type="file" multiple>` triggered by an "Add Files" button inside a `MatDialog`, with a `mat-progress-bar` per file. There is no drag-and-drop directive anywhere in this repo (no `*.directive.ts` files exist), unlike stacks that implement custom drop zones.
- `generate.web/ClientApp/src/app/shared/components/login.component.html`: Dual login path (Azure MSAL OAuth button vs. username/password form), built on legacy Material Design Lite markup with manually numbered `tabindex` values (`tabindex="1"` through `tabindex="13"` spread across `login.component.html` and `app-header.component.html`).

## Backend Touchpoints

- `generate.web/Program.cs`: Top-level ASP.NET Core (.NET 10) startup — Angular CLI SPA static hosting, authentication (Azure AD/MSAL, JWT bearer, cookies), Serilog logging, and middleware that affect user-visible responses.
- `generate.web/Controllers/Web/AccountController.cs`, `ErrorController.cs`: User-facing auth flows and error responses/pages.
- `generate.web/Controllers/Api/App/*.cs` (e.g. `GenerateReportController.cs`, `FileSubmissionController.cs`) and `Controllers/Api/ODS/*.cs`: JSON REST endpoints whose payloads (labels, messages, generated file names) feed directly into the SPA's accessible names and error/status text.
- `generate.web/Views/Shared/_Layout.cshtml`, `Views/App/Index.cshtml`, `Views/Error/Index.cshtml`: Server-rendered shell and error pages that host or surround the Angular SPA.

## Practical Review Heuristics

- Confirmed via `generate.web/ClientApp/package.json`: no `axe-core`, no `eslint-plugin-jsx-a11y`, and no `@angular-eslint` accessibility ruleset in this repo. Linting runs through legacy TSLint plus Codelyzer (`generate.web/ClientApp/tslint.json`), and every rule in that file is a code-style or type rule, not an accessibility rule. The `lint` npm script (`ng lint`) exists but is not wired into any CI gate — `bitbucket-pipelines.yml` at the repo root is an empty, commented-out stub, and there are no `.github/workflows/*` files. Do not assert or recommend a fix that assumes an automated accessibility check exists; every accessibility issue here is caught manually or not at all.
- `@angular/cdk` is a real dependency and `LiveAnnouncer` (`@angular/cdk/a11y`) is already used in `flextable.component.ts` and `report-library-table.component.ts` to announce sort changes — this is the one clearly deliberate accessible pattern already in the codebase; use it as the bar for other interactive tables.
- Expect the largest concentration of confirmed findings in Angular templates under `shared/components/` (reused across many screens) and in the reactive-form-heavy `settings/toggle` and dense-table `reports/` screens.
- Much of the markup is legacy Material Design Lite (`mdl-*` classes) intermixed with newer Angular Material (`mat-*`) components and Angular Flex Layout (`fxLayout`/`fxFlex`) — expect inconsistent semantics between the two eras of markup within the same file, and treat mismatches between them as a common source of findings.
- Watch for manually numbered `tabindex` values — a common source of keyboard-order bugs when new controls are inserted without renumbering everything after them.
- Watch for icon elements (`<i class="fa ...">`) carrying an `alt` attribute as if they were `<img>` elements — `alt` has no effect on non-`img`/non-`area`/non-`input` elements, so any accessible name still needs to come from visible text, `aria-label`, or a `.generate-text--screen-reader-only` span (the pattern already used alongside several of these icons).
- Backend controllers are mostly JSON APIs (`Controllers/Api/`) plus a small number of MVC/Razor pages (`Controllers/Web/`, `Views/`); most accessibility-relevant backend surface is in user-facing error messages, download/export file naming, and the Razor shell rather than in markup the API itself renders.
