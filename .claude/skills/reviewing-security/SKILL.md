---
name: reviewing-security
description: Perform repository-grounded security code reviews of the Generate codebase and produce a prioritized list of concrete vulnerabilities with file and line references. Use when the user asks for a security review, AppSec review, vulnerability review, abuse-path review, OWASP Top 10 review, or secure-by-default assessment of this Generate repository — its Angular SPA, ASP.NET Core web/API app, ASP.NET Core Identity auth, EF Core and raw-SQL data access layer, file submission/export workflows, background jobs, or deployment-facing configuration. Also use for reviews scoped to FERPA-protected student/education data exposure risk.
---

# Reviewing Security

Review the code that exists before making claims. Prefer concrete, reachable issues over generic best-practice advice.

## Generate Stack Focus

Tailor the review to this repository's stack and layout:

- Backend: ASP.NET Core (.NET 10) in `generate.web`, bootstrapped from top-level statements in `Program.cs` (no `Startup.cs`). API controllers live in `Controllers/Api/` (including `Controllers/Api/App/`, `Controllers/Api/ODS/`), MVC controllers in `Controllers/Web/`, and the Angular SPA is hosted in-process via `app.UseSpa(...)`.
- Auth: ASP.NET Core Identity, configured in `Program.cs` from an `AppSettings:UserStoreType` switch across three modes — `EMBEDDED` and AD (both cookie-based via `AddAuthentication().AddCookie()`) and `OAUTH` (JWT bearer via `Microsoft.Identity.Web`/`AddMicrosoftIdentityWebApi`). Custom Identity plumbing lives in `generate.web/Security/` (`ApplicationUser`, `ApplicationUserManager`, `ApplicationUserStore`, `ApplicationRoleStore`, `ApplicationClaimsPrincipleFactory`, `SignInManager`, plus `EmbeddedUserManager`/`EmbeddedUserStore` for the embedded mode).
- Data access: a mix of EF Core (`generate.infrastructure/Repositories/`, `RepositoryBase`, `AppDbContext`/`IDSDbContext`/`RDSDbContext`/`StagingDbContext`) and parameterized raw SQL via `FromSqlRaw`/`ExecuteSqlRaw` with `{0}`-style placeholders (e.g. `generate.infrastructure/Repositories/RDS/FactStudentCountRepository.cs`), plus a large raw-SQL layer in `generate.database/` (`StoredProcedures/`, `Functions/`, `Views/`, `Tables/`, `TableTypes/`, each split into `Create`/`Drop`). Several stored procedures build dynamic SQL via string concatenation into `@sql`-style variables (e.g. `generate.database/StoredProcedures/Create/RDS.Get_ReportData.StoredProcedure.sql`), which is worth checking whenever the concatenated values could trace back to user-editable report/report-topic configuration rather than fixed metadata.
- Frontend: Angular 20 SPA under `generate.web/ClientApp/src/app`, served same-origin through `UseSpa` (no separate cross-origin API deployment and no CORS middleware configured in `Program.cs`). Route guards live in `ClientApp/src/app/shared/guards/` (`admin.guard.ts`, `login.guard.ts`, `confirmation.guard.ts`) and are client-side only (e.g. `admin.guard.ts` checks `UserService.isAdmin` and redirects) — no HTTP interceptor was found wiring auth tokens or refresh, so treat these guards as UX conveniences, not security controls.
- File and export workflows: `generate.web/Controllers/Api/App/FileSubmissionController.cs` streams generated EDFacts submission files directly from report data (no filesystem read), building `Content-Disposition: attachment; filename="..."` from a route-supplied `fileName`. `generate.infrastructure/Helpers/ZipFileHelper.cs` wraps .NET's built-in `ZipFile.ExtractToDirectory`/`ZipFile.CreateFromDirectory`. Note: `generate.filestorage` is an in-repo project name but currently contains no compiled code (only `Metadata/metadata.txt`) — it is not where real file-handling logic lives; don't assume it is in scope just because of its name.
- Background/maintenance surfaces: `generate.background` (Hangfire-driven jobs via `IHangfireHelper`), `generate.update` and `AppUpdateController.cs`/`DataMigrationController.cs` (schema and data migration triggers), `generate.console`.
- Common review starting points: `generate.web/Program.cs`, `generate.web/Security/`, `generate.web/Config/AppConfiguration.cs` and `appsettings*.json`, `generate.web/Controllers/Api/` and `Controllers/Web/`, `generate.infrastructure/Repositories/`, `generate.database/StoredProcedures|Functions|Views/Create/`, `generate.web/ClientApp/src/app/shared/guards/`, and `generate.filestorage/`.

## Workflow

1. Identify the stack, trust boundaries, externally reachable entry points, and sensitive assets — this app likely handles FERPA-protected student and special-education (IDEA/EDFacts) data, so treat student- and organization-level records as sensitive by default; confirm against the actual model fields in `generate.core/Models/` rather than assuming.
2. Read only the files needed to trace risky flows. In this repo, start with `Program.cs` bootstrap and auth-mode wiring, `generate.web/Security/`, controller endpoints under `Controllers/Api/` and `Controllers/Web/`, Angular route guards, EF Core repositories, raw-SQL stored procedures reachable from those repositories, file-submission/export endpoints, and background/migration/admin surfaces touched by the flow.
3. Use [references/security-review-checklist.md](references/security-review-checklist.md) as the default checklist. Use [references/generate-stack-security.md](references/generate-stack-security.md) for repo-specific focus areas. When the user asks for OWASP coverage, also use [references/owasp-top-10-2021.md](references/owasp-top-10-2021.md) and ensure each relevant risk area is considered.
4. For each suspected issue, confirm the attacker-controlled input, the code path that reaches the sink, the missing or broken control, and the impact. Do not report speculative findings that lack a plausible abuse path.
5. Spend most time on problems that can lead to unauthorized access, sensitive-data exposure, remote code execution, arbitrary file access, privilege escalation, or durable denial of service.

## Finding Standard

Only report a finding when all of these are true:

- The vulnerable behavior is present in code or config.
- An attacker-controlled path reaches it.
- The impact is meaningful and not purely theoretical.

When the evidence is incomplete, say so explicitly and label it as an assumption or open question instead of a confirmed finding.

## Severity Rubric

Sort findings from highest to lowest severity:

- `Critical`: Unauthenticated remote compromise, critical secret exposure, integrity failure in a trusted update path, or immediately exploitable tenant-wide or system-wide impact.
- `High`: Authorization bypass, privilege escalation, sensitive-data exposure, arbitrary file access, dangerous injection, broken authentication, SSRF to sensitive internal targets, or similar high-impact abuse path.
- `Medium`: Confirmed security weakness with narrower blast radius, stronger preconditions, partial mitigation already present, or logging and monitoring failures that materially hinder detection or response.
- `Low`: Defense-in-depth gap, risky inconsistency, or issue that matters mainly in combination with another weakness.

Prefer fewer, higher-confidence findings over long speculative lists.

## OWASP Top 10 Coverage

Ensure the review considers the OWASP Top 10:2021 categories when they are relevant to the codebase:

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

## What To Look For

- API and MVC controllers under `Controllers/Api/` and `Controllers/Web/` that omit `[Authorize]`/`[AllowAnonymous]` entirely — this repo does not wire a global authorization filter, so each controller and action must carry its own attribute; do not assume a route is protected just because most of the app requires login.
- Angular route guards (`shared/guards/*.guard.ts`) that gate navigation but have no server-side equivalent enforcing the same rule on the corresponding API endpoint.
- Endpoints that accept broad identifiers directly from the route or query string — e.g. `reportTypeCode`, `reportCode`, `reportLevel`, `reportYear`, `organizationId`, `dataMigrationTypeCode` — and pass them into a repository or file-generation call without checking that the caller is authorized for that specific organization, report, or migration.
- Auth-mode-specific gaps: cookie-based flows (`EMBEDDED`/AD modes) missing appropriate cookie security attributes, logout/session-invalidation gaps in `SignInManager`/`ApplicationUserManager`, or `OAUTH`-mode JWT validation configuration in `AzureAd`/`Microsoft.Identity.Web` settings that is too permissive.
- Raw-SQL and EF Core call sites: confirm `FromSqlRaw`/`ExecuteSqlRaw` calls use the `{0}`-style placeholder convention (parameterized) rather than string interpolation (`$"..."`) or concatenation; flag any deviation as SQL injection risk.
- Dynamic SQL built inside `generate.database/StoredProcedures/` (or `Functions/`/`Views/`) via string concatenation into `@sql`-style variables — trace whether the concatenated values (report field names, category codes, column lists) can be influenced by user-editable configuration (e.g. report/report-topic/toggle-question admin screens) rather than only fixed metadata.
- File-submission and export endpoints (`FileSubmissionController.cs` and similar) that build `Content-Disposition` filenames or other response headers directly from request-supplied values without sanitization.
- Archive handling (`ZipFileHelper`) and any future file-upload/import path for missing size limits, extension/type validation, or path-traversal protection — note that `System.IO.Compression.ZipFile.ExtractToDirectory` in modern .NET already rejects zip-slip-style entries, but confirm any custom extraction logic elsewhere does the same.
- Background and migration triggers (`generate.background` Hangfire jobs, `AppUpdateController`, `DataMigrationController`, `generate.update`, `generate.console`) reachable without the same authorization rigor as ordinary user-facing endpoints.
- Cryptographic mistakes such as reversible storage of secrets, weak algorithms, missing transport protection, or homegrown crypto.
- Insecure design issues such as missing abuse controls, unsafe trust assumptions, and workflows that cannot enforce least privilege.
- Unsafe trust of client-controlled role, organization, or user identifiers, including claims set in `ApplicationClaimsPrincipleFactory`.
- CORS, forwarded-header, host, proxy, origin, or redirect trust issues — note that `Program.cs` currently configures no CORS policy at all (same-origin SPA hosting via `UseSpa`); if CORS is introduced later, review it, and flag any new cross-origin surface as a change worth scrutiny.
- `app.UseSwagger()`/`UseSwaggerUI()` and `UseDeveloperExceptionPage()` are gated behind `IsDevelopment()` in `Program.cs` — confirm this gate stays effective (i.e. `ASPNETCORE_ENVIRONMENT` cannot be forced to `Development` in a deployed environment) and that `Views/Error/*.cshtml` and non-dev exception handling (`UseExceptionHandler("/Error")`) do not leak stack traces, connection strings, or internal paths.
- Dependency, package, or component trust problems, including stale or risky third-party software when the code or lockfiles (`ClientApp/package.json`, `*.csproj`) show clear exposure.
- Software integrity problems such as unsafe deserialization, unsigned update paths, or unchecked execution of untrusted data in the migration/update pipeline.
- Secrets or connection strings committed in `appsettings*.json` under `generate.web/Config/`, `generate.background/`, `generate.console/Config/`, `generate.update/`, or example/test configuration.
- Missing size limits, rate limits, quotas, or anti-automation controls on expensive or sensitive endpoints (report generation, file export, data migration triggers).
- Exception responses, logs, traces, or notifications that leak internal paths, stack traces, secrets, or sensitive student/organization record details.
- Missing or ineffective security logging (Serilog sinks configured in `Program.cs`) and monitoring that blocks detection, triage, or forensics for sensitive actions.
- SSRF paths where attacker-controlled URLs, hosts, or callbacks (e.g. any `RestClient`/`RestSharp` usage) can reach internal services or cloud metadata endpoints.

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

For normal user-facing reviews, do not emit `::code-comment` directives. The app surfaces them as separate finding cards, so they are not internal-only. Only emit `::code-comment` when the user explicitly wants inline review comments, line-specific callouts, or code annotations.

Use this block shape for each finding:

- `### High: Authorization bypass on file submission endpoint`
- `**Impact:** An authenticated low-privilege user can read data intended for another organization. Include OWASP framing only when it materially helps.`
- `**Evidence:** path/to/file:line, path/to/other-file:line`
- `**Change Risk:** Medium`
- `**Business Decision:** Yes`
- `**Recommended Change:** Enforce server-side organization-scope checks before returning or streaming data.`

Example:

## Findings

### High: Authorization bypass on file submission endpoint
**Impact:** An authenticated low-privilege user can read data intended for another organization.
**Evidence:** path/to/file:line
**Change Risk:** Medium
**Business Decision:** Yes
**Recommended Change:** Enforce server-side organization-scope checks before returning or streaming data.

---

### Medium: Dynamic SQL builds column list from unvalidated report configuration
**Impact:** A report field name that is not restricted to a known-safe set could influence generated SQL text.

Keep each field to one or two short sentences. Let text wrap naturally. If two evidence references are enough, prefer two over a longer list.

If multiple findings share context, add a short `## Notes` section after the findings. Insert a Markdown horizontal rule `---` before `## Notes` so it is clearly separated from the last finding. Only use a Markdown table when the user explicitly asks for one.

Always pair the recommended change with the change-risk level and business-decision flag. Treat change risk as the likelihood that implementing the fix will cause regressions, require broad coordination, or reshape shared behavior. Mark business decision as `Yes` when the best fix changes access policy, trust boundaries, retention expectations, abuse-prevention posture, or other product and governance tradeoffs that need explicit stakeholder approval instead of a routine engineering hardening change.

If there are no confirmed findings, say that explicitly and mention residual risks or testing gaps.

## Review Notes

- Review both frontend and backend when both exist, but treat server-side enforcement as authoritative — Angular guards in this repo are confirmed to be client-side only.
- Pay extra attention to code paths that cross `ClientApp` -> `Controllers/Api` -> `generate.infrastructure` repositories -> `generate.database` stored procedures, because this repo has a broad raw-SQL data access layer alongside EF Core.
- If a safer implementation exists elsewhere in the repo (e.g. a parameterized `FromSqlRaw` call next to a concatenated dynamic-SQL stored procedure), call out the inconsistency.
- If a mitigation seems intended but is not actually wired up (e.g. an `[Authorize]` attribute present on some controllers but absent on comparable ones), report the gap.
- Keep summaries short. Do not bury findings under an architecture overview.
