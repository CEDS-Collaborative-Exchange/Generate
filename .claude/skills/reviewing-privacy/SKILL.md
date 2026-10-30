---
name: reviewing-privacy
description: Perform repository-grounded privacy and confidential-information reviews of this Generate codebase (CIID's open-source EDFacts / IDEA special-education reporting tool for State Education Agencies) and produce a prioritized Markdown list of concrete leaks or exposure risks, sorted Critical/High/Medium/Low, with file and line references. Use when the user asks for a privacy review, PII review, FERPA review, student-data exposure review, confidential-information review, secret scan, credential leak review, application-secret review, internal infrastructure detail review, data exposure review, log redaction review, telemetry privacy review, or safe-publication assessment for this .NET/Angular codebase, docs, config, database scripts, generated content, or UI copy.
---

# Reviewing Privacy

Review the content that exists before making claims. Prefer concrete, reachable privacy or confidentiality leaks over generic "be careful with data" advice.

## Generate Stack Focus

Tailor the review to this repository's stack and layout:

- Domain: Generate is CIID's (Center for the Integration of IDEA Data) open-source EDFacts / IDEA special-education reporting tool for State Education Agencies (SEAs). It standardizes state data and automates EDFacts and SPP-APR submissions to the U.S. Department of Education, so most of the sensitive data flowing through this repo is FERPA-protected special-education student data, not generic customer PII.
- Backend: .NET 10 / ASP.NET Core across `generate.web` (Controllers/Api, Controllers/Web, Views, Security, Config, DatabaseScripts, Helpers, Utilities, Updates), `generate.core` (Dtos, Models, Interfaces, ViewModels, Examples), `generate.infrastructure` (Repositories, Services, Contexts), `generate.background` (background jobs and their own Controllers/appsettings), `generate.filestorage`, `generate.console`, `generate.update`, `generate.overnighttest`, and raw-SQL object definitions under `generate.database` (Tables, Views, StoredProcedures, Functions, TestCases, VersionUpdates).
- Frontend: Angular 20 SPA at `generate.web/ClientApp/src/app`, with shared HTTP interceptors, route guards, dialogs, and API services under `ClientApp/src/app/shared` and `ClientApp/src/app/services`.
- Auth: ASP.NET Core Identity (`generate.web/Security/ApplicationUser.cs`, `ApplicationUserManager.cs`, `SignInManager.cs`, `EmbeddedUserManager.cs`, `ApplicationRoleStore.cs`) combined with cookie auth and, in some configurations, Azure AD / JWT bearer auth wired in `generate.web/Program.cs`. There is no single auth model used everywhere — confirm which scheme actually protects a given controller or route before assuming it is guarded.
- Sensitive domains: student identifiers and demographics (`generate.core/Models/RDS/DimK12Student.cs` carries `StateStudentIdentifier`, `FirstName`, `MiddleName`, `LastName`, `BirthDate`, sex, and race fields), disability and special-education program data (`generate.core/Models/Staging/Disability.cs`, `ProgramParticipationSpecialEducation.cs`, `IdeaDisabilityType.cs`), discipline/attendance/assessment facts (`FactK12StudentDiscipline`, `FactK12StudentAttendance`, `FactK12StudentAssessment` under `generate.core/Models/RDS`), staff records including email and phone (`generate.core/Models/RDS/DimK12Staff.cs`), organization/school identifiers, EDFacts file-submission generation and download endpoints (`generate.web/Controllers/Api/App/FileSubmissionController.cs`, `generate.infrastructure/Services/EdfactsFileService.cs`), data-migration jobs that move raw student records between staging/IDS/RDS layers (`DataMigrationController.cs`, `DataMigrationService.cs`), embedded admin/reviewer credentials and Active Directory settings in `generate.web/Config/appsettings*.json`, and Azure AD tenant/client configuration.

## Workflow

1. Identify the content surface and intended audience before reading deeply: public/unauthenticated route, authenticated UI, API response, log, export or file-submission download, config, database script, or documentation.
2. Read only the files needed to trace whether student or staff data, confidential business details, secrets, credentials, or internal infrastructure details can be exposed to the wrong audience.
3. Use [references/privacy-review-checklist.md](references/privacy-review-checklist.md) as the default checklist. Use [references/generate-stack-privacy.md](references/generate-stack-privacy.md) for repo-specific starting points and hotspots.
4. For each suspected issue, confirm the data class, the exposure path, the reachable audience, and the practical impact. Do not report speculative findings that lack a plausible leak or misuse path.
5. Spend most time on committed secrets, unauthenticated or weakly authenticated controllers, EDFacts file-submission downloads and data-migration paths, logs and errors, exports, seed/test data in `generate.database`, deployment/config files, and broad admin/reporting endpoints.

## Finding Standard

Only report a finding when all of these are true:

- The private, confidential, secret, credential, or internal detail is present in code, config, docs, scripts, UI copy, generated output, logs, or responses.
- A realistic reader, user, caller, build artifact, repository viewer, log consumer, or downloaded/exported file can reach it.
- The impact is meaningful and not purely theoretical.

When evidence is incomplete, say so explicitly and label it as an assumption or open question instead of a confirmed finding.

## Severity Rubric

Sort findings from highest to lowest severity:

- `Critical`: Live credential, token, private key, production connection string, exploitable secret, or exposed highly sensitive student/staff PII (e.g., state student identifier plus name and disability status) that could directly enable account takeover, system access, or serious privacy harm.
- `High`: Confirmed exposure of FERPA-protected student data, regulated staff PII, broad confidential business data, internal infrastructure details that materially aid intrusion, or secrets that appear plausible but need rotation confirmation.
- `Medium`: Narrower or partially mitigated exposure, lower-sensitivity PII, internal details with limited blast radius, logs/errors that reveal data to authenticated staff, or test/dev secrets that could still be reused or misunderstood.
- `Low`: Defense-in-depth redaction issue, localized over-disclosure, stale placeholder secret, or internal detail that should be cleaned up but has limited present-day impact.

Prefer fewer, higher-confidence findings over long speculative lists.

## What To Look For

- Hardcoded credentials, API keys, JWT/Azure AD secrets, passwords (e.g., embedded admin/reviewer passwords), private keys, connection strings, SMTP credentials, storage paths, or service URLs in source, docs, scripts, tests, examples, or config under `generate.web/Config`, `generate.background`, or `generate.update`.
- Realistic-looking student or staff PII in seed data, tests, examples, screenshots, static content, generated docs, JSON fixtures, SQL test-case scripts under `generate.database/TestCases`, or comments.
- Student identifiers, names, birthdates, disability/program status, discipline records, or staff contact details exposed through file-submission downloads, data-migration jobs, reports, logs, or notifications without an authorization check tied to the requesting SEA.
- Backend errors, exception handling, validation responses, Serilog output, or telemetry that can reveal SQL text, connection strings, server paths, stack traces, tokens, email addresses, or record details.
- File-submission, data-migration, import, export, report, and download paths whose filenames, metadata, or path structure reveal private student records or internal infrastructure.
- Angular templates, notification/dialog components, HTTP interceptors, and route guards that surface raw server messages or sensitive model fields to the wrong audience, or that store tokens insecurely (e.g., `HttpConfigInterceptor.ts` reading an access token out of client storage).
- Public or lightly authenticated controllers that disclose internal deployment details, admin workflows, database table/column names, maintenance endpoints, environment names, internal hostnames, or operational runbooks.
- SQL scripts under `generate.database` and deployment/update scripts under `generate.update`/`generate.console` that include real users, real emails, production-like identifiers, internal network details, or irreversible operational secrets.
- Data-migration and file-submission flows that move more student/staff fields than the destination export or downstream consumer actually needs.
- Weak redaction patterns where sensitive values are logged, serialized, echoed back in responses, or included in exported files after validation failure.

## Output Format

Return the review as Markdown.

Use Markdown structure intentionally so findings are easy to scan.

- Start with a short `## Findings` heading.
- Give each finding its own `### <Severity>: <Short Title>` heading.
- Put supporting fields on separate lines with bold labels such as `**Impact:**`, `**Evidence:**`, `**Data Class:**`, `**Exposure Path:**`, `**Change Risk:**`, `**Business Decision:**`, and `**Recommended Change:**`.
- Use inline code for literals, identifiers, routes, and file paths where helpful.
- Use Markdown horizontal rules between findings.
- Do not wrap the entire review in a fenced code block.

Lead with findings. Do not use Markdown tables by default. In this app, review tables often force horizontal scrolling and are harder to read than stacked finding blocks.

Present confirmed findings as a severity-sorted sequence of compact finding blocks. Give each finding its own short heading, then place the supporting fields on separate lines underneath it.

Separate findings with a Markdown horizontal rule `---` on its own line so each issue stands out clearly. Do not put a divider before the first finding; place one between findings only.

Never label user-facing findings as `P0`, `P1`, `P2`, or `P3`. Always use the human-readable severity words from the rubric: `Critical`, `High`, `Medium`, or `Low`.

For normal user-facing reviews, do not emit `::code-comment` directives. The app surfaces them as separate finding cards, so they are not internal-only. Only emit `::code-comment` when the user explicitly wants inline review comments, line-specific callouts, or code annotations.

Use this block shape for each finding:

- `### High: File-submission download endpoint returns student records without authorization`
- `**Impact:** Any caller who can reach the route can retrieve identifiable EDFacts student records for a state.`
- `**Evidence:** path/to/file:line, path/to/other-file:line`
- `**Data Class:** FERPA-protected student data: state student identifier, name, birthdate`
- `**Exposure Path:** Unauthenticated API controller`
- `**Change Risk:** Medium`
- `**Business Decision:** Yes`
- `**Recommended Change:** Require SEA-scoped authorization before streaming the submission file.`

Example:

## Findings

### High: File-submission download endpoint returns student records without authorization
**Impact:** Any caller who can reach the route can retrieve identifiable EDFacts student records for a state.
**Evidence:** path/to/file:line
**Data Class:** FERPA-protected student data: state student identifier, name, birthdate
**Exposure Path:** Unauthenticated API controller
**Change Risk:** Medium
**Business Decision:** Yes
**Recommended Change:** Require SEA-scoped authorization before streaming the submission file.

---

### Medium: Error response reveals SQL table names
**Impact:** Authenticated users can learn internal schema details that make targeted probing easier.

Keep each field to one or two short sentences. Let text wrap naturally. If two evidence references are enough, prefer two over a longer list.

If multiple findings share context, add a short `## Notes` section after the findings. Insert a Markdown horizontal rule `---` before `## Notes` so it is clearly separated from the last finding. Only use a Markdown table when the user explicitly asks for one.

Always pair the recommended change with the change-risk level and business-decision flag. Treat change risk as the likelihood that implementing the fix will cause regressions, require broad coordination, or reshape shared behavior. Mark business decision as `Yes` when the best fix changes data-retention policy, disclosure rules, public-content strategy, logging policy, report audience, or operational visibility rather than being a straightforward engineering correction.

If there are no confirmed findings, say that explicitly and mention residual risks or artifacts not inspected.

## Review Notes

- Review both frontend and backend when both can expose data, but treat server-side filtering, redaction, authorization, and logging as authoritative.
- Do not report every email address, domain name, table name, or file path automatically. Confirm that the value is private, confidential, production-like, or exposed to a broader audience than intended.
- Treat unauthenticated or lightly authenticated routes, committed config, database scripts, logs, generated files, reports, exports, and file-submission downloads as higher-risk than purely internal implementation details.
- Distinguish security vulnerabilities from privacy leaks: a finding can be privacy-only even when it does not create an immediate exploit path.
- Keep summaries short. Do not bury findings under an architecture overview.
