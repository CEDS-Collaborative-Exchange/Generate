# Generate Privacy Focus

Use this reference to adapt a privacy and confidential-information review to the Generate repository structure.

## Backend Starting Points

- `generate.web/Config/appsettings.json` and per-environment variants (`appsettings.Development.json`, `appsettings.Production.json`, `appsettings.Stage.json`, `appsettings.Test.json`): embedded admin/reviewer credentials, Active Directory bind settings (`ADDomain`, `ADContainer`, group names), Azure AD tenant/client configuration, file-storage URLs, and local filesystem paths (`WebAppPath`, `fsMetaFileLoc`).
- `generate.web/Program.cs`: authentication scheme wiring (cookie auth, ASP.NET Core Identity, and Azure AD/JWT bearer depending on configuration), Serilog logging setup, and startup middleware order.
- `generate.web/Security/`: `ApplicationUser.cs`, `ApplicationUserManager.cs`, `ApplicationUserStore.cs`, `ApplicationRoleStore.cs`, `EmbeddedUserManager.cs`, `EmbeddedUserStore.cs`, `SignInManager.cs`, and `ApplicationClaimsPrincipleFactory.cs` — the actual identity, claims, and embedded-account behavior.
- `generate.web/Controllers/Api/App/`, `Controllers/Api/ODS/`, and `Controllers/Web/`: file-submission, data-migration, report, toggle/survey, organization, and account/error controllers, including which ones carry (or omit) authorization attributes.
- `generate.infrastructure/Services/`: `FileSubmissionService.cs`, `EdfactsFileService.cs`, `DataMigrationService.cs`, `RDSDataMigrationService.cs`, `SppAprReportService.cs`, `GenerateReportService.cs`, and other services that read, transform, or stream student and staff records.
- `generate.infrastructure/Repositories/`: raw data access into `App`, `IDS`, `RDS`, and `Staging` layers.

## Frontend Starting Points

- `generate.web/ClientApp/src/app/shared/interceptors/HttpConfigInterceptor.ts`: how the access token is read from client-side storage and attached to requests, and whether errors are surfaced raw to the UI.
- `generate.web/ClientApp/src/app/shared/guards/`: `admin.guard.ts`, `confirmation.guard.ts`, `login.guard.ts` — client-side route protection, which must be backed by server-side checks.
- `generate.web/ClientApp/src/app/services/app/` and `services/ods/`: API wrapper services for reports, file submissions, organizations, and user/session state.
- `generate.web/ClientApp/src/app/shared/components/`: notification, dialog, and confirmation-dialog components where server messages or record data are surfaced to users.
- `generate.web/ClientApp/src/app/reports/`, `settings/`, and `resources/`: report screens, data-store/metadata/toggle settings screens, and downloadable resources.

## Data, Config, And Artifact Starting Points

- `generate.database/Scripts/`, `StoredProcedures/`, `Tables/`, `Views/`, `Functions/`, and `VersionUpdates/<version>/`: schema, stored procedure, and migration definitions that move student/staff data between layers.
- `generate.database/TestCases/`: SQL test-case scripts (e.g., `App.DimK12Students_TestCase.StoredProcedure.sql`) that assert on real-shaped student fields such as `FirstName` and `BirthDate` — check whether the values are synthetic.
- `generate.web/DatabaseScripts/` and `DatabaseFiles/`: database restore and setup scripts.
- `generate.filestorage/Metadata/`: file-storage metadata used by EDFacts file-submission layout/metadata calls.
- `generate.background/` and `generate.update/` and `generate.console/`: background job controllers, packaged application updates, and console utilities, each with their own `appsettings*.json`.
- `generate.web/logs/` and `generate.background/logs/`: Serilog file output (gitignored, not committed, but worth checking locally for what gets written when reviewing log redaction).

## Repo-Specific Hotspots

- EDFacts file-submission download flow: `FileSubmissionController.cs` streams membership/student-count rows (state ANSI code, organization identifiers, grade level, race, sex, student counts) directly to the response as an attachment — confirm authorization is enforced before the file is generated, not just assumed from routing.
- Data-migration jobs (`DataMigrationController.cs`, `DataMigrationService.cs`, `RDSDataMigrationService.cs`): move raw student/staff records (name, birthdate, disability status) between staging, IDS, and RDS layers; check for over-broad logging or debug output of migrated rows.
- Student and staff dimension/fact models: `generate.core/Models/RDS/DimK12Student.cs` (`StateStudentIdentifier`, `FirstName`, `MiddleName`, `LastName`, `BirthDate`, sex/race), `DimK12Staff.cs` (`StaffMemberIdentifierState`, name, `BirthDate`, `TelephoneNumber`, `ElectronicMailAddress`), and disability/program models under `generate.core/Models/Staging/` (`Disability.cs`, `ProgramParticipationSpecialEducation.cs`, `IdeaDisabilityType.cs`).
- Auth and identity: embedded admin/reviewer accounts with credentials sourced from `appsettings.json`, Active Directory group-based roles, and Azure AD tenant/client configuration — confirm which scheme actually guards a given surface in the running app rather than assuming JWT-everywhere or cookie-everywhere.
- Reports and exports: `GenerateReportService.cs`, `SppAprReportService.cs`, `StateDefinedReportService.cs`, and the report DTOs under `generate.core/Dtos/RDS` and `Dtos/ODS` that shape what leaves the system as a report or download.
- SQL and data scripts: `generate.database/TestCases/` and `VersionUpdates/` that may carry real-looking student/staff identifiers, names, or birthdates in fixture data.
- Error handling and logging: Serilog configuration in `generate.web/Program.cs`, and any service that logs raw exception messages, file paths, or record identifiers via `_logger.LogError`/`LogInformation`.
- Internal infrastructure: local filesystem paths and AWS/API endpoint URLs hardcoded in `appsettings.json` (`WebAppPath`, `fsMetaFileLoc`, `fsWSURL`), Active Directory container/group names, and Azure AD tenant/client identifiers.

## Practical Review Heuristics

- Treat committed secrets as findings even if they appear to be dev-only, unless the value is clearly synthetic and non-reusable — the embedded admin/reviewer passwords in `appsettings.json` are a concrete example worth checking each time they're touched.
- Treat real-looking student/staff names, birthdates, state identifiers, and disability/program values as sensitive until code or context proves they are harmless synthetic examples.
- Do not mark ordinary public organization/school names or public EDFacts terminology as PII by itself; look for personal identifiers, disability/program status, credentials, or non-public context.
- Prefer reporting the exposure path and intended audience mismatch (e.g., "SEA A's data reachable without an SEA-scoped check") over simply naming the sensitive field.
- If the best fix requires changing what the organization is allowed to publish, export, log, retain, or migrate, mark `Business Decision: Yes`.
