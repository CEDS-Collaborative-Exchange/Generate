# Privacy Review Checklist

Use this checklist to guide a repository review, then spend most of the time on the highest-impact confirmed exposure paths.

## Triage First

- Which files or routes are public, committed, exported, logged, or downloaded?
- Which data classes appear: credentials, secrets, student/staff PII, confidential business data, internal infrastructure, or operational details?
- Who can realistically see the data: anonymous users, authenticated users, admins/reviewers, repository readers, log readers, or external systems consuming a file submission?
- Is the data real, production-like, reusable, sensitive by itself, or sensitive in combination with other fields (e.g., state student identifier plus disability status)?

## Generate Repo Sweep

- `generate.web/Config/appsettings.json`, `appsettings.Development.json`, `appsettings.Production.json`, `appsettings.Stage.json`, `appsettings.Test.json`
- `generate.web/Program.cs`
- `generate.web/Security/`
- `generate.web/Controllers/Api/App/`, `Controllers/Api/ODS/`, `Controllers/Web/`
- `generate.web/DatabaseScripts/` and `DatabaseFiles/`
- `generate.infrastructure/Services/`
- `generate.infrastructure/Repositories/`
- `generate.core/Models/RDS/`, `Models/IDS/`, `Models/Staging/`
- `generate.core/Dtos/App/`, `Dtos/RDS/`, `Dtos/ODS/`
- `generate.database/Scripts/`, `StoredProcedures/`, `TestCases/`, `VersionUpdates/`
- `generate.background/` (Controllers and its own `appsettings*.json`)
- `generate.filestorage/Metadata/`
- `generate.update/` and `generate.console/`
- `generate.web/ClientApp/src/app/shared/interceptors/`, `shared/guards/`
- `generate.web/ClientApp/src/app/services/`

## Secrets And Credentials

- Hardcoded connection strings, passwords, embedded admin/reviewer credentials, Azure AD client/tenant identifiers, API keys, tokens, private keys, or Active Directory bind settings
- Environment placeholders that are actually real values
- Test/dev credentials that could work in shared or production-adjacent systems
- Secrets echoed in logs, errors, comments, docs, or deployment/update scripts

## PII And Confidential Data

- State student identifiers, names, birthdates, sex, race, disability status, program participation, discipline, attendance, or assessment records
- Staff identifiers, names, birthdates, email addresses, or phone numbers
- Sensitive SEA/LEA/school workflow status, data-migration jobs, file submissions, reports, imported files, or exported files
- Realistic data in tests, seed/test-case SQL scripts, screenshots, examples, static content, or docs
- PII combined with disability, program, or discipline context in ways that increase sensitivity

## Internal Infrastructure Details

- Internal hostnames, URLs, IPs, database names, table names, schema names, network paths, local filesystem paths, deployment commands, environment names, or maintenance endpoints
- Stack traces, SQL text, stored procedure names, server paths, build artifacts, or debug-only data in user-visible responses
- Comments, generated docs, or public-facing content that reveal non-public operational details

## Exposure Surfaces

- Unauthenticated or lightly authenticated API/Web controllers, file-submission download endpoints, and downloadable EDFacts artifacts
- API responses, validation errors, exception handling, and Serilog telemetry
- Reports, exports, data-migration jobs, CSV/fixed-width file submissions, and generated downloads
- Angular notification/dialog components, HTTP interceptors, route guards, and raw server-message display
- Committed config, database scripts, deployment/update scripts, documentation, examples, and generated files

## Severity Calibration

- `Critical`: Live secret, reusable credential, private key, production connection string, or serious exposed student/staff PII with direct harm potential
- `High`: FERPA-protected student data, confidential records, or internal infrastructure details exposed to a wrong or broader audience
- `Medium`: Narrower exposure, partially protected data, lower-sensitivity PII, or dev/test secret with reuse risk
- `Low`: Local over-disclosure, stale placeholder, weak redaction, or cleanup issue with limited present-day impact
