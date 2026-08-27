# Documentation Review Checklist

Use this checklist to guide a repository review, then spend most of the time on the highest-impact confirmed documentation gaps.

## Triage First

- Which files or interfaces are reused broadly?
- Which workflows would be hard to understand for a new teammate without tribal knowledge?
- Which code surfaces are likely to be summarized, searched, or interpreted by AI tools?

## Generate Repo Sweep

- `generate.web/Program.cs` (startup wiring, middleware order, DI registration, Swagger configuration)
- `generate.web/Controllers/Api/App/` and `generate.web/Controllers/Api/ODS/`
- `generate.web/Controllers/Web/`
- `generate.web/Security/`, `generate.web/Helpers/`, `generate.web/Utilities/`, `generate.web/Updates/`
- `generate.core/Interfaces/{Helpers,Repositories,Services}/`
- `generate.core/Dtos/{App,ODS,RDS}/` and `generate.core/ViewModels/`
- `generate.core/Models/{App,IDS,RDS,Staging}/`
- `generate.infrastructure/{Contexts,Repositories,Services,Helpers}/` (where core interfaces are actually implemented)
- `generate.database/StoredProcedures/`, `generate.database/Functions/`, `generate.database/Tables/`, `generate.database/TableTypes/`, `generate.database/Views/`
- `generate.database/VersionUpdates/<version>/` (release-specific migration and metadata scripts)
- `generate.web/ClientApp/src/app/core` equivalents: `services/`, `shared/`
- Feature modules under `generate.web/ClientApp/src/app`: `about/`, `home/`, `reports/edfacts/`, `reports/library/`, `reports/sppapr/`, `reports/summary/`, `settings/datastore/`, `settings/metadata/`, `settings/toggle/`, `settings/update/`, `resources/`

## Core Questions

- Does the code explain intent, not just mechanics?
- Are inputs, outputs, constraints, and side effects documented where they are not obvious?
- Would a human and an AI infer the same meaning from the comments and names?
- Are historical comments helping understanding or drowning it in noise?

## API And Contract Documentation

- Endpoint summaries and method intent (note where Swagger is reachable but carries no authored summary)
- DTO and model property meaning
- Status, validation, and error behavior
- Interface contracts and expectations between `generate.core` interfaces and their `generate.infrastructure` implementations

## Workflow And Component Documentation

- Task-level explanation in complex Angular report-building and settings/migration components
- Form state transitions and save/submit rules
- File submission, data migration, and metadata-update flows
- Shared services whose behavior affects many screens
- SQL stored procedures and version-update scripts that drive data migrations (do they state purpose, preconditions, and why a change was made?)

## Comment Quality

- Accurate, current, and specific
- Not merely paraphrasing code
- No stale TODOs, commented-out dead code, or contradictory author-initialed notes left unexplained
- Historical notes separated from present behavior when possible

## AI-Usable Clarity

- Stable names and summaries
- Structured comments near shared interfaces
- Clear semantics on DTOs, enums, flags, and sentinel values
- Predictable organization that makes retrieval and summarization easier
- Accurate `sp_addextendedproperty` metadata (`Required`, `Lookup`, etc.) on table columns, since it is a structured, queryable documentation layer this repo already relies on

## Priority Calibration

- `Critical`: Missing or misleading docs likely cause incorrect use or repeated regressions
- `High`: Major gap in commonly changed or widely reused code
- `Medium`: Confirmed gap with narrower scope or partial mitigation
- `Low`: Local wording, consistency, or formatting issue
