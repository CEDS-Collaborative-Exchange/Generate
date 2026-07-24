# CEDS Staging auto-annotation (CIID-9057)

Proposes CEDS Ontology mappings for Staging-schema columns that lack the CEDS extended properties,
so more of the warehouse is covered by the ETL automapper. Uses the fine-tuned CEDS Copilot
sentence-embedding model plus two deterministic signals.

## How it decides

For each Staging column without a `CEDS_GlobalId` extended property:

1. **Same column name already annotated** on another table → applied (near-certain).
2. **Exact de-camelCased label match** to a CEDS element → applied (certain).
3. **Embedding similarity** (tuned model) vs the annotated-column answer key + ontology labels:
   - `>= --high` (default 0.90) → applied (spot-check recommended).
   - `--low`..`--high` → "needs guidance" with the top 3 suggestions.
   - `< --low` (0.55) → "needs guidance", no strong suggestion.

Internal plumbing (see `INTERNAL_TABLES` / `INTERNAL_COLUMNS` in the script — e.g. surrogate `Id`
columns, `StagingValidationResults`, `SourceSystemReferenceData`) is skipped entirely.

## Run

```
# 1. Export DB facts (from repo root, PowerShell) — see the two FOR JSON queries below.
#    staging_unannotated.json  and  ceds_annotations.json
# 2. Match + generate SQL (CEDS-Copilot venv has the tuned model + sentence-transformers):
C:\Repos\CEDS-Copilot\.venv\Scripts\python.exe annotate_staging_ceds.py --high 0.90 --low 0.55
# 3. Review, then apply:
sqlcmd -S localhost -E -d Generate -i Staging_CEDS_ExtendedProperties.generated.sql
# Rollback:
sqlcmd -S localhost -E -d Generate -i Staging_CEDS_ExtendedProperties.rollback.sql
```

## Outputs

- `Staging_CEDS_ExtendedProperties.generated.sql` — idempotent sp_add/updateextendedproperty for the
  confident matches (CEDS_GlobalId, CEDS_Element, CEDS_Def_Desc, CEDS_URL when known, MS_Description).
- `Staging_CEDS_ExtendedProperties.rollback.sql` — drops exactly those properties.
- `uncertain_columns.csv` / `.md` — columns needing human guidance, with top-3 suggestions.

The `*.json` inputs are raw DB dumps and are git-ignored.
