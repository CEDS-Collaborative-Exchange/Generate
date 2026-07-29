# VersionUpdates / 14.1

## Purpose

This folder packages the **finish-generate** EDFacts new-process work as a
deployable database version update. Placing the changes here lets them ship to
**all states** through Generate's normal database-update process: when a
Generate instance starts against a database whose recorded `DatabaseVersion` is
older than `14.1`, the update runner executes every script listed in
`VersionScripts.csv` (in order) and then stamps the database version to `14.1`.

The database version is stored in `App.GenerateConfigurations`
(`GenerateConfigurationCategory = 'Database'`, `GenerateConfigurationKey = 'DatabaseVersion'`)
and is bumped by `UpdateDbVersion.sql`.

## Folder layout

Object scripts are organized in subfolders, mirroring the structure used by
prior version folders (e.g. `13.3`):

| Subfolder | Contents |
| --- | --- |
| `Views/Create`, `Views/Drop` | View create / drop scripts |
| `StoredProcedures/Create`, `StoredProcedures/Drop` | Stored-procedure create / drop scripts |
| `TestCases` | `App.FSxxx_TestCase` and related test-harness procedures |

Top-level scripts (added only as needed) follow the same names used by other
version folders: `App.TableChanges.sql`, `RDS.TableChanges.sql`,
`Staging.TableChanges.sql`, `App.Metadata.sql`, etc.

Empty subfolders are kept in source control with a `.gitkeep` placeholder;
remove the placeholder once the folder contains real scripts.

## Adding an object

1. Add the **Create** script under the correct subfolder
   (e.g. `StoredProcedures/Create/<Schema>.<Name>.StoredProcedure.sql`).
2. Add the matching **Drop** script under the sibling `Drop` subfolder
   (e.g. `StoredProcedures/Drop/<Schema>.<Name>.StoredProcedure.sql`), using the
   guarded `IF EXISTS (SELECT * FROM sys.objects ...) DROP ...` pattern used by
   the existing Drop scripts.
3. Add a line to `VersionScripts.csv` for each script, in apply order — the
   **Drop line must come before the Create line** — and place both lines
   **before** the final `UpdateDbVersion.sql` line.

Each `VersionScripts.csv` line has the form:

```
VersionUpdates\\14.1\\<subdir>,<filename>,0
```

## Important

`UpdateDbVersion.sql` must **always remain the last entry** in
`VersionScripts.csv`. It bumps the recorded database version to `14.1`, so any
script listed after it would not run on a fresh upgrade. Always insert new
script lines above it.
