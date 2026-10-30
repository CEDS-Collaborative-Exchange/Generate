# Generate Documentation Focus

Use this reference to adapt a documentation review to the Generate repository structure.

## Existing Documentation Conventions

- C# controllers, interfaces, DTOs, and models generally do **not** use `/// <summary>` XML doc comments. Comment coverage is sparse and inconsistent: expect scattered inline `//` notes (sometimes author-initialed, e.g. old "MER changed to..." remarks) and blocks of commented-out dead code rather than structured documentation.
- Swagger (`AddSwaggerGen` / `UseSwaggerUI`) is configured in `generate.web/Program.cs`, but the project does not set `GenerateDocumentationFile`, so the generated Swagger UI only reflects auto-derived schema shapes — there are no authored endpoint summaries to lose or preserve. Treat "Swagger is reachable but undocumented" as a real, reportable gap rather than assuming rich API docs already exist.
- `generate.database` stored procedures frequently open with a `/* ... */` block comment giving a date, a short purpose statement, and a numbered list of assumptions/preconditions (e.g. "the @Database parameter is a valid database on the server"), plus inline `--` comments beside parameters showing example values or defaults. Table-creation scripts sometimes carry a single `--` line at the top describing the table's purpose.
- Column-level semantics in `generate.database/Tables/Create/*.sql` are also captured as structured, queryable metadata via `sp_addextendedproperty` calls immediately after `CREATE TABLE` (tags such as `Required`, `Lookup`). This is a real documentation surface specific to this repo — check it for accuracy and completeness, not just for the presence of prose comments.
- `generate.database/README.md` states an explicit repo standard: changes to `VersionUpdates/<version>/*.MetaData.sql` and `*.TableChanges.sql` must "provide documentation in the file to explain why the changes were required." A review should check whether recent release folders under `generate.database/VersionUpdates/` actually meet that bar.
- Angular services and components rely on typed models, dependency injection, and descriptive naming rather than JSDoc; JSDoc-style comment blocks are uncommon. Do not flag their absence as a gap where names and types already carry the meaning — focus instead on workflow-heavy components where logic is not obvious from structure alone.
- The published product/user documentation lives in `docs/` (GitBook-published: `docs/developer-guides/`, `docs/user-guide/`, `docs/data-integration-toolkit/`, `docs/release-notes/`, etc.) and is largely audience-facing (installation, CEDS/EDFacts concepts, migration guidance) rather than inline code documentation — it is a useful cross-reference for domain terms (CEDS, EDFacts, SPP/APR, Align/Connect/myConnect) but does not define a code-comment style standard.

These conventions mean the repo invests unevenly in documentation: SQL objects and version-update scripts have real (if inconsistent) conventions worth holding code to, while C# and Angular code leans almost entirely on naming and structure. Review whether existing documentation is accurate, useful, and current, and call out the biggest gaps concretely rather than asking for documentation everywhere uniformly.

## Backend Starting Points

- `generate.web/Program.cs`: startup wiring, middleware order, DI registration, identity/authentication setup, and Swagger configuration deserve explanation because they affect the whole app.
- `generate.web/Controllers/Api/App/` and `generate.web/Controllers/Api/ODS/`: endpoint intent, route/authorization expectations, validation behavior, and file-submission/report/migration semantics.
- `generate.web/Controllers/Web/`: account and error-handling controllers backing the Razor-rendered shell around the Angular SPA.
- `generate.web/Security/`: authentication/authorization helpers and claims handling.
- `generate.core/Interfaces/{Helpers,Repositories,Services}/`: the contracts that `generate.infrastructure` implements — these are the shared abstractions most worth documenting well.
- `generate.infrastructure/{Repositories,Services,Contexts,Helpers}/`: the actual data-access and business-logic implementations, including SQL-heavy repository methods, migration orchestration, and EF Core contexts.

## Contract And Model Starting Points

- `generate.core/Dtos/{App,ODS,RDS}/`: request/response shapes crossing the API boundary — property meaning, units, and nullability are rarely explained beyond the property name.
- `generate.core/Models/{App,IDS,RDS,Staging}/`: domain models spanning the CEDS Integrated Data Store (IDS), reporting data store (RDS), and staging layers used during data migration.
- `generate.core/ViewModels/`: view/request models such as login and migration-status shapes.
- `generate.web/ClientApp/src/app/services/` and feature-local `models/` folders: client-side contracts that often mirror API DTOs.

## Frontend Starting Points

- `generate.web/ClientApp/src/app/shared/`: shared components, guards, interceptors, and services that many features depend on.
- `generate.web/ClientApp/src/app/services/`: Angular services wrapping API calls (e.g. data migration, report generation, metadata updates) — check whether non-obvious request/response shaping is explained.
- Feature modules: `reports/edfacts/`, `reports/library/`, `reports/sppapr/`, `reports/summary/` (EDFacts and SPP/APR report generation and review), `settings/datastore/`, `settings/metadata/`, `settings/toggle/`, `settings/update/` (data migration, metadata configuration, feature toggles, app updates), plus `about/`, `home/`, and `resources/`.
- Form-heavy and report-building components: validation rules, field dependencies, submission-year/report-type behavior, and save/submit behavior where those are not obvious from names alone.

## Repo-Specific Hotspots

- Controllers and services reachable through the configured-but-undocumented Swagger surface, where a summary would be a genuine, low-risk improvement.
- SQL stored procedures where a block-comment header exists but no longer matches the procedure's actual parameters, preconditions, or side effects (stale docs are worse than none).
- `generate.database/VersionUpdates/<version>/` scripts that skip the "why" explanation the repo's own README requires for metadata and table changes.
- Table scripts where `sp_addextendedproperty` metadata (`Required`, `Lookup`) is missing, incomplete, or inconsistent with the column's actual validation behavior.
- Commented-out dead code and author-initialed inline notes in controllers/services that read as unresolved uncertainty rather than documented intent.
- Data-migration flows (staging to ODS/IDS to RDS, submission-file comparison, metadata callbacks) where documentation must describe side effects, ordering assumptions, and recovery expectations.
- Shared DTOs, models, and Angular services that are likely read by both humans and AI tools but currently rely on naming alone.

## Practical Review Heuristics

- Treat stale or misleading comments as high-value findings.
- Favor structured, semantic documentation close to reusable code surfaces (SQL header blocks, extended properties, DTO property names) over asking for prose everywhere.
- Do not reward comment volume for its own sake; useful summaries beat repetitive boilerplate.
- When a stored procedure's header comment is long, check whether the actual operative SQL underneath still matches what it claims.
