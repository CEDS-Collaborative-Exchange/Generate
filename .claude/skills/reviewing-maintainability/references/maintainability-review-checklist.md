# Maintainability Review Checklist

Use this checklist to guide a repository review, then spend most of the time on the highest-impact confirmed maintenance risks.

## Triage First

- Which files or modules are touched by many features?
- Which routine product changes seem likely to require edits across multiple layers?
- Where would a new teammate struggle to discover the right ownership boundary?

## Generate Repo Sweep

- `generate.web/Program.cs`
- `generate.web/Controllers/Api/App/`
- `generate.web/Controllers/Api/ODS/`
- `generate.web/Controllers/Web/`
- `generate.core/Interfaces/Repositories/App/IAppRepository.cs`
- `generate.infrastructure/Repositories/App/AppRepository.cs`
- `generate.infrastructure/Services/`
- `generate.core/Interfaces/Services/`
- `generate.core/Models/{App,IDS,RDS,Staging}/`
- `generate.database/VersionUpdates/`
- `generate.web/ClientApp/src/app/services/`
- `generate.web/ClientApp/src/app/shared/`
- Large feature areas in `reports/edfacts`, `reports/sppapr`, `reports/library`, `reports/summary`, `settings/datastore`, `settings/metadata`, `settings/toggle`, and `settings/update`

## Architecture And Ownership

- Clear layer responsibilities
- One obvious path for implementing a feature
- Minimal overlap between legacy and newer abstractions
- Dependencies that express ownership instead of hiding it

## Class And Component Size

- Large files that mix orchestration, validation, persistence, and presentation
- Services or managers that accumulate unrelated responsibilities
- Components with very large forms, many injected dependencies, or long lifecycle methods
- Controllers that coordinate too many downstream services or repositories

## Coupling And Change Amplification

- Similar changes required in many places
- Broad shared services that every feature depends on
- Hidden coupling through generic wrappers, strings, or implicit conventions
- Changes that require touching frontend, API, services, and repositories for simple behavior

## Duplication And Drift

- Repeated repository query, API wrapper, or controller logic
- Repeated form construction, validation, or table configuration
- Old and new patterns coexisting without a clear migration boundary
- Similar concepts named or modeled differently across the App/ODS/RDS/Staging layers

## Type Safety And Clarity

- `any`, weakly typed APIs, or overly generic data plumbing
- Hard-to-follow method names or folders
- Generic utility wrappers that obscure behavior
- Imports, naming, and structure that make ownership harder to infer

## Tests And Refactorability

- Code that is difficult to isolate in tests
- Heavy concrete dependencies or difficult setup
- Assertions that mirror implementation detail because the production seams are weak
- Missing seams for extracting or replacing logic later

## Priority Calibration

- `Critical`: Core changes are unsafe or structurally hard because of design shape
- `High`: Significant maintenance burden in commonly changed code
- `Medium`: Confirmed issue with narrower scope or partial mitigation
- `Low`: Local readability, consistency, or cleanup concern
