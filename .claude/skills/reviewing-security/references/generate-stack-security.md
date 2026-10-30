# Generate Security Focus

Use this reference to adapt a security review to the Generate repository structure.

## Backend Starting Points

- `generate.web/Program.cs`: Top-level request pipeline setup, auth-mode selection (`EMBEDDED`/`OAUTH`/AD), Identity registration, DbContext registration, Swagger exposure, static files, SPA hosting, forwarded-header handling, and startup behavior. Note there is no `Startup.cs` — everything lives in `Program.cs`.
- `generate.web/Security/`: `ApplicationUser`, `ApplicationUserManager`/`EmbeddedUserManager`, `ApplicationUserStore`/`EmbeddedUserStore`, `ApplicationRoleStore`, `ApplicationClaimsPrincipleFactory`, and `SignInManager` — the custom ASP.NET Core Identity plumbing behind login, claims, and role mapping.
- `generate.web/Controllers/Api/` and `Controllers/Api/App/`, `Controllers/Api/ODS/`: Route-level authorization (or its absence — `[Authorize]` is applied per-controller/action, not globally), object-level access checks, file-submission, report-generation, data-migration, and admin-adjacent controllers.
- `generate.web/Controllers/Web/`: `AccountController.cs`, `ErrorController.cs` — MVC-side auth entry points and error-page behavior (check it doesn't leak stack traces).
- `generate.web/Config/AppConfiguration.cs` and `generate.web/Config/appsettings*.json`: DI wiring, secrets, connection strings, mail, and deployment-facing settings; loaded from a `./Config/` base path with environment-suffixed overrides.

## Data Access Starting Points

- `generate.infrastructure/Repositories/RepositoryBase.cs` and `AppRepository.cs`, `RDS/*Repository.cs`: EF Core LINQ access plus parameterized raw SQL via `FromSqlRaw`/`ExecuteSqlRaw` using `{0}`-style placeholders — confirm any call site actually uses the placeholder form rather than string interpolation or concatenation.
- `generate.infrastructure/Contexts/`: `AppDbContext`, `IDSDbContext`, `RDSDbContext`, `StagingDbContext` — connection-string sourcing and context-level configuration.
- `generate.database/StoredProcedures/Create/`, `Functions/Create/`, `Views/Create/`, `Tables/Create/`, `TableTypes/Create/`: the raw T-SQL data-access layer. Several report-generation stored procedures (e.g. `RDS.Get_ReportData.StoredProcedure.sql`) build dynamic SQL by concatenating column/field names into `@sql`-style variables before execution — trace whether those values can be influenced by user-editable report/report-topic/toggle-question configuration.
- `generate.database/VersionUpdates/<version>/`: schema and stored-procedure changes that can introduce authorization, injection, or data-exposure regressions between versions.

## Frontend Starting Points

- `generate.web/ClientApp/src/app/app.module.ts` and `app-routing.module.ts`: Global module wiring, app initialization, and route exposure (public vs. authenticated split).
- `generate.web/ClientApp/src/app/shared/guards/`: `admin.guard.ts`, `login.guard.ts`, `confirmation.guard.ts` — client-side-only navigation checks (e.g. `admin.guard.ts` checks `UserService.isAdmin`); confirm equivalent enforcement exists server-side.
- `generate.web/ClientApp/src/app/services/app/user.service.ts`: client-side identity/session state consumed by guards.
- No HTTP interceptor was found for token attachment or refresh in this sweep — if one is added later, review it for token leakage or unsafe retry/refresh handling.

## Repo-Specific Hotspots

- File-submission/export flow in `FileSubmissionController.cs`: streams generated EDFacts/report data directly to the response and builds `Content-Disposition: attachment; filename="..."` from a route-supplied `fileName` — check for header injection and confirm the endpoint enforces authorization on the requested organization/report, not just any authenticated (or, if `[Authorize]` is missing, any) caller.
- Controllers with no `[Authorize]`/`[AllowAnonymous]` attribute at all — since there is no global authorization filter in `Program.cs`, this is the closest analogue to an "implicitly public endpoint" risk; verify each API controller's intended access level explicitly rather than assuming the app-wide login requirement applies.
- `EMBEDDED` vs. `OAUTH` vs. AD auth-mode branching in `Program.cs`: confirm each mode's session/token handling (cookie flags for cookie modes, JWT validation settings for `OAUTH`) is sound, and that the active mode in each deployed environment matches what `appsettings.<Environment>.json` intends.
- `generate.background` (Hangfire) jobs and `generate.update`/`generate.console` schema/version-update tooling: confirm these privileged, often-unauthenticated-by-design surfaces cannot be triggered or influenced by untrusted input.
- `appsettings*.json` across `generate.web/Config/`, `generate.background/`, `generate.console/Config/`, `generate.update/`: connection strings, mail configuration, and environment-specific security policy wiring — check for committed secrets and confirm `Development`-only behavior (Swagger, developer exception page) cannot leak into `Stage`/`Production`.
- Controllers or repositories that pass broad identifiers such as `organizationId`, `reportCode`, `reportTypeCode`, `reportYear`, `dataMigrationTypeCode`, or `userId` into SQL-backed methods without per-record or per-organization authorization.
