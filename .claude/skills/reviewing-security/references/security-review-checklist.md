# Security Review Checklist

Use this checklist to guide a repository review, then spend most of the time on the highest-risk confirmed paths.

## Triage First

- What is internet reachable, user reachable, or partner reachable?
- What assets matter most: secrets, FERPA-protected student/organization records, files, submission data, tenant (organization/SEA) boundaries, admin and migration actions?
- Which flows deserve `Critical` or `High` attention first if they fail?

## Generate Repo Sweep

- `generate.web/Program.cs` and `generate.web/Config/AppConfiguration.cs`, `appsettings*.json`
- `generate.web/Security/` (`ApplicationUser`, `ApplicationUserManager`, `ApplicationUserStore`, `ApplicationRoleStore`, `ApplicationClaimsPrincipleFactory`, `SignInManager`, `EmbeddedUserManager`, `EmbeddedUserStore`)
- `generate.web/Controllers/Api/` (including `Api/App/` and `Api/ODS/`) and `Controllers/Web/`
- `generate.infrastructure/Repositories/` and `generate.infrastructure/Contexts/` (`AppDbContext`, `IDSDbContext`, `RDSDbContext`, `StagingDbContext`)
- `generate.database/StoredProcedures/Create/`, `Functions/Create/`, `Views/Create/`, `Tables/Create/`
- `generate.background/` (Hangfire jobs), `generate.update/`, `generate.console/`
- `generate.web/ClientApp/src/app/shared/guards/` and `ClientApp/src/app/services/app/`
- Report/export, data-migration, and admin-facing modules that front sensitive API actions (`FileSubmissionController`, `DataMigrationController`, `AppUpdateController`, `GenerateReportController`)

## OWASP Top 10:2021 Sweep

- Broken Access Control
- Cryptographic Failures
- Injection
- Insecure Design
- Security Misconfiguration
- Vulnerable and Outdated Components
- Identification and Authentication Failures
- Software and Data Integrity Failures
- Security Logging and Monitoring Failures
- Server-Side Request Forgery (SSRF)

## Identity And Access

- What authenticates the caller? Which auth mode applies — `EMBEDDED`/AD (cookie-based) or `OAUTH` (JWT via Microsoft Identity Web)?
- What authorizes the specific resource or action?
- Can a low-privilege user access another organization's, school's, or student's records?
- Does every controller and action that should require login actually carry `[Authorize]`? This repo has no global authorization filter, so absence of the attribute means the endpoint is open.
- Are background, migration, admin, and file/export endpoints protected the same way as ordinary HTTP endpoints?
- Are client-side checks (Angular guards) incorrectly relied on as the main authorization control instead of a server-side check on the same rule?
- Do Angular guards (`admin.guard.ts`, `login.guard.ts`, `confirmation.guard.ts`) assume something the backend does not actually enforce?

## Input To Dangerous Sinks

- Request values into filesystem paths or archive extraction
- Request values into raw SQL, dynamic SQL construction, or stored procedure parameters
- Request values into shell or process execution
- Request values into outbound URLs or internal service calls (`RestSharp`/`RestClient` usage)
- Request values into redirects, headers (e.g. `Content-Disposition`), templates, or dynamic code paths

## Files And Object Access

- Upload size, type, and extension validation (if/when file upload exists)
- Safe file naming with directory components stripped before use in headers or paths
- Canonical-path checks after path joining
- Archive extraction protections against zip-slip style writes (`ZipFileHelper` wraps .NET's built-in `ZipFile` APIs, which are zip-slip-safe by default — confirm any custom extraction logic elsewhere matches)
- Download, preview, and export endpoints (e.g. `FileSubmissionController`) tied to authorization on the target organization/report, not just authentication
- Do not assume `generate.filestorage` is where file logic lives — it currently contains no compiled code

## Web Platform And Session Security

- CORS: `Program.cs` currently configures no CORS policy at all (same-origin SPA via `UseSpa`) — flag any newly introduced cross-origin surface
- Cookies, tokens, refresh flow, logout semantics, and token lifetime across the three auth modes
- CSRF protections where cookie auth is in use (`EMBEDDED`/AD modes)
- Forwarded headers (`app.UseForwardedHeaders` only forwards `XForwardedProto` — check whether host/for headers need equivalent trust handling), host handling, proxy trust
- Rate limiting, quotas, and anti-abuse guards on expensive or sensitive operations (report generation, file export, migration triggers)
- JWT validation configuration for `OAUTH` mode (`AzureAd` settings, `Microsoft.Identity.Web`)

## Data And Secrets

- Secrets or sensitive placeholders committed in `appsettings*.json` (`generate.web/Config/`, `generate.background/`, `generate.console/Config/`, `generate.update/`), docs, or examples
- TLS or certificate validation disabled
- Stack traces, paths, tokens, or secrets returned in errors (`Views/Error/`, `UseDeveloperExceptionPage` gated correctly behind `IsDevelopment()`)
- Sensitive student/organization data broadcast to logs (Serilog sinks in `Program.cs`), notifications, telemetry, or clients that should not receive it
- Connection strings (`Data:AppDbContextConnection`, `Data:ODSDbContextConnection`, `Data:RDSDbContextConnection`, `Data:StagingDbContextConnection`), mail settings, and environment-specific configuration handled safely across `Development`/`Test`/`Stage`/`Production`

## Severity Calibration

- `Critical`: Immediate unauthenticated compromise, critical secret exposure, or trusted software integrity failure with system-wide impact
- `High`: High-impact authz, authn, injection, file access, SSRF, or sensitive-data exposure issue
- `Medium`: Confirmed but narrower weakness with stronger preconditions or partial mitigation
- `Low`: Defense-in-depth issue or risky inconsistency
