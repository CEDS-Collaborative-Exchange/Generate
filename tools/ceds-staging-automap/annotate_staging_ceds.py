"""
Auto-annotate CEDS extended properties on Staging-schema columns (CIID-9057, epic CIID-9029).

For every Staging column that lacks a CEDS_GlobalId extended property, this tool proposes the best
CEDS Ontology element using three signals, in order of confidence:

  1. Same column name already annotated on another Staging/warehouse table (near-certain).
  2. Exact match of the de-camelCased column name to a CEDS element label.
  3. Semantic similarity via the fine-tuned CEDS Copilot sentence-embedding model.

Confident matches (1, 2, and embeddings >= --high) are written as idempotent sp_addextendedproperty
SQL (CEDS_GlobalId, CEDS_Element, CEDS_Def_Desc, CEDS_URL when known, MS_Description) plus a rollback
script. Everything below --high is written to a "needs guidance" list with the top suggestions.

Inputs (exported via sqlcmd FOR JSON; see README):
  staging_unannotated.json  [{table, column, dataType}]
  ceds_annotations.json     [{schema, table, column, globalId, element, definition, url}]
Ontology: the CEDS-Ontology.rdf shipped with the app.

Nothing touches the database: this tool only emits SQL for review/apply.
"""
import argparse
import csv
import json
import os
import re
import xml.etree.ElementTree as ET
from collections import Counter, defaultdict

TERMS_BASE = "https://w3id.org/CEDStandards/terms/"
RDF_NS = "{http://www.w3.org/1999/02/22-rdf-syntax-ns#}"
RDFS_NS = "{http://www.w3.org/2000/01/rdf-schema#}"
SKOS_NS = "{http://www.w3.org/2004/02/skos/core#}"

MS_DESCRIPTION = "See the CEDS_GlobalId, CEDS_Element, CEDS_URL, and CEDS_Def_Desc extended properties."

# Internal warehouse plumbing that does not map to a CEDS element (excluded from auto-apply and the
# guidance list). Extend as needed.
INTERNAL_TABLES = {"stagingvalidationresults", "sourcesystemreferencedata"}
INTERNAL_COLUMNS = {"id"}  # surrogate primary keys


def load_json_fragmented(path):
    """SQL Server FOR JSON splits output into ~2KB fragments across lines; raw newlines are
    fragment separators (real newlines in data are escaped as \\n), so stripping them is safe."""
    raw = open(path, encoding="utf-8-sig").read()
    raw = raw.replace("\r", "").replace("\n", "").strip()
    return json.loads(raw) if raw else []


def decamel(name):
    """AssessmentFamilyShortName -> 'Assessment Family Short Name' (also splits letter/digit runs)."""
    if not name:
        return ""
    s = re.sub(r"(?<=[a-z0-9])(?=[A-Z])", " ", name)
    s = re.sub(r"(?<=[A-Za-z])(?=[0-9])", " ", s)
    s = re.sub(r"(?<=[0-9])(?=[A-Za-z])", " ", s)
    s = re.sub(r"(?<=[A-Z])(?=[A-Z][a-z])", " ", s)  # acronym then word: SEAName -> SEA Name
    s = s.replace("_", " ")
    return re.sub(r"\s+", " ", s).strip()


def norm_key(s):
    return re.sub(r"[^a-z0-9]", "", (s or "").lower())


def parse_ontology(rdf_path):
    """Returns list of {globalId, isClass, label, definition} for CEDS C/P elements.

    Iterates the root's direct children over the full tree. (An iterparse approach must not clear
    child nodes on their own end events, or the parent's label/definition lookups read empty nodes.)
    """
    elements = []
    root = ET.parse(rdf_path).getroot()
    for elem in root:
        tag = elem.tag
        if not (tag.endswith("}Class") or tag.endswith("}Property")):
            continue
        about = elem.get(f"{RDF_NS}about", "")
        if not about.startswith(TERMS_BASE):
            continue
        token = about[len(TERMS_BASE):]
        if len(token) < 2 or token[0] not in ("C", "P") or not token[1].isdigit():
            continue
        label = elem.findtext(f"{RDFS_NS}label") or elem.findtext(f"{SKOS_NS}prefLabel")
        definition = elem.findtext(f"{SKOS_NS}definition") or elem.findtext(f"{RDFS_NS}comment")
        if label:
            elements.append({
                "globalId": token[1:],
                "isClass": token[0] == "C",
                "label": label.strip(),
                "definition": (definition or "").strip(),
            })
    return elements


def sql_escape(value):
    return (value or "").replace("'", "''")


def emit_add_property(schema, table, column, prop, value):
    if value is None:
        return ""
    v = sql_escape(value)
    obj = f"{schema}.{table}"
    return (
        f"IF NOT EXISTS (SELECT 1 FROM sys.extended_properties "
        f"WHERE major_id = OBJECT_ID('{obj}') "
        f"AND minor_id = COLUMNPROPERTY(OBJECT_ID('{obj}'), '{column}', 'ColumnId') AND name = '{prop}')\n"
        f"    EXEC sys.sp_addextendedproperty @name=N'{prop}', @value=N'{v}', "
        f"@level0type=N'SCHEMA', @level0name=N'{schema}', "
        f"@level1type=N'TABLE', @level1name=N'{table}', "
        f"@level2type=N'COLUMN', @level2name=N'{column}';\n"
        f"ELSE\n"
        f"    EXEC sys.sp_updateextendedproperty @name=N'{prop}', @value=N'{v}', "
        f"@level0type=N'SCHEMA', @level0name=N'{schema}', "
        f"@level1type=N'TABLE', @level1name=N'{table}', "
        f"@level2type=N'COLUMN', @level2name=N'{column}';\n"
    )


def emit_drop_property(schema, table, column, prop):
    obj = f"{schema}.{table}"
    return (
        f"IF EXISTS (SELECT 1 FROM sys.extended_properties "
        f"WHERE major_id = OBJECT_ID('{obj}') "
        f"AND minor_id = COLUMNPROPERTY(OBJECT_ID('{obj}'), '{column}', 'ColumnId') AND name = '{prop}')\n"
        f"    EXEC sys.sp_dropextendedproperty @name=N'{prop}', "
        f"@level0type=N'SCHEMA', @level0name=N'{schema}', "
        f"@level1type=N'TABLE', @level1name=N'{table}', "
        f"@level2type=N'COLUMN', @level2name=N'{column}';\n"
    )


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    ap = argparse.ArgumentParser()
    ap.add_argument("--data-dir", default=here)
    ap.add_argument("--rdf", default=r"C:\Repos\Generate\generate.web\CedsOntology\CEDS-Ontology.rdf")
    ap.add_argument("--model", default=r"C:\Repos\CEDS-Copilot\test\data\CEDS_Copilot_tuned_model.model")
    ap.add_argument("--schema", default="Staging")
    ap.add_argument("--high", type=float, default=0.90, help="auto-apply confidence floor (embeddings)")
    ap.add_argument("--low", type=float, default=0.55, help="floor to show a suggestion at all")
    args = ap.parse_args()

    unannotated = load_json_fragmented(os.path.join(args.data_dir, "staging_unannotated.json"))
    annotations = load_json_fragmented(os.path.join(args.data_dir, "ceds_annotations.json"))
    print(f"Unannotated Staging columns: {len(unannotated)}; existing annotations: {len(annotations)}")

    # GlobalId -> canonical (element label, definition, url) and column-name answer key
    by_global = {}
    url_by_global = {}
    known_votes = defaultdict(Counter)         # column key -> Counter(globalId)
    known_tables = defaultdict(set)            # column key -> set(schema.table already annotated)
    for a in annotations:
        gid = (a.get("globalId") or "").strip()
        if not gid:
            continue
        by_global.setdefault(gid, {"element": a.get("element"), "definition": a.get("definition")})
        if a.get("url") and gid not in url_by_global:
            url_by_global[gid] = a["url"]
        ck = norm_key(a.get("column"))
        if ck:
            known_votes[ck][gid] += 1
            known_tables[ck].add(f"{a.get('schema')}.{a.get('table')}")

    ontology = parse_ontology(args.rdf)
    print(f"CEDS ontology elements (C/P): {len(ontology)}")
    ont_by_label = {}
    for e in ontology:
        ont_by_label.setdefault(norm_key(e["label"]), e)  # first wins; C generally precedes usage

    # Embedding corpus: annotated column names (answer-key distribution) + ontology labels
    corpus_texts, corpus_meta = [], []
    seen_ann = set()
    for a in annotations:
        ck = norm_key(a.get("column"))
        gid = (a.get("globalId") or "").strip()
        if ck and gid and (ck, gid) not in seen_ann:
            seen_ann.add((ck, gid))
            corpus_texts.append(decamel(a.get("column")))
            corpus_meta.append(("column", gid, a.get("element")))
    for e in ontology:
        corpus_texts.append(e["label"])
        corpus_meta.append(("label", e["globalId"], e["label"]))

    from sentence_transformers import SentenceTransformer
    model = SentenceTransformer(args.model)
    print("Encoding corpus...")
    corpus_emb = model.encode(corpus_texts, normalize_embeddings=True, show_progress_bar=False)

    queries = [decamel(c["column"]) for c in unannotated]
    query_emb = model.encode(queries, normalize_embeddings=True, show_progress_bar=False)
    sims = model.similarity(query_emb, corpus_emb)  # rows = queries

    confident, uncertain, skipped = [], [], []
    for i, col in enumerate(unannotated):
        column = col["column"]
        ck = norm_key(column)

        # Internal warehouse plumbing: not a CEDS element
        if norm_key(col["table"]) in INTERNAL_TABLES or ck in INTERNAL_COLUMNS:
            skipped.append(col)
            continue

        # Signal 1: same column name already annotated elsewhere
        if ck in known_votes:
            gid = known_votes[ck].most_common(1)[0][0]
            meta = by_global.get(gid, {})
            confident.append({**col, "globalId": gid, "element": meta.get("element"),
                              "definition": meta.get("definition"), "url": url_by_global.get(gid),
                              "confidence": 0.99, "source": "same column annotated on " + ", ".join(sorted(known_tables[ck])[:3])})
            continue

        # Signal 2: exact de-camelCased label match
        if ck in ont_by_label:
            e = ont_by_label[ck]
            confident.append({**col, "globalId": e["globalId"], "element": e["label"],
                              "definition": e["definition"], "url": url_by_global.get(e["globalId"]),
                              "confidence": 0.97, "source": "exact CEDS label match"})
            continue

        # Signal 3: embedding similarity; keep best per GlobalId for top-3 suggestions
        row = sims[i]
        best_by_gid = {}
        for j, score in enumerate(row.tolist()):
            _, gid, disp = corpus_meta[j]
            if gid not in best_by_gid or score > best_by_gid[gid][0]:
                best_by_gid[gid] = (score, disp)
        ranked = sorted(best_by_gid.items(), key=lambda kv: kv[1][0], reverse=True)
        top = ranked[0]
        top_score = top[1][0]

        if top_score >= args.high:
            gid = top[0]
            meta = by_global.get(gid) or {}
            label = meta.get("element") or next((e["label"] for e in ontology if e["globalId"] == gid), top[1][1])
            definition = meta.get("definition") or next((e["definition"] for e in ontology if e["globalId"] == gid), "")
            confident.append({**col, "globalId": gid, "element": label, "definition": definition,
                              "url": url_by_global.get(gid), "confidence": round(top_score, 4),
                              "source": "embedding"})
        else:
            suggestions = []
            for gid, (score, disp) in ranked[:3]:
                if score >= args.low:
                    label = (by_global.get(gid) or {}).get("element") or disp
                    suggestions.append({"globalId": gid, "label": label, "score": round(score, 4)})
            uncertain.append({**col, "topScore": round(top_score, 4), "suggestions": suggestions})

    uncertain.sort(key=lambda u: u["topScore"], reverse=True)
    write_outputs(args, confident, uncertain, skipped)


def write_outputs(args, confident, uncertain, skipped):
    here = args.data_dir
    props = [("CEDS_GlobalId", "globalId"), ("CEDS_Element", "element"),
             ("CEDS_Def_Desc", "definition"), ("CEDS_URL", "url")]

    apply_path = os.path.join(here, "Staging_CEDS_ExtendedProperties.generated.sql")
    rollback_path = os.path.join(here, "Staging_CEDS_ExtendedProperties.rollback.sql")
    with open(apply_path, "w", encoding="utf-8") as f, open(rollback_path, "w", encoding="utf-8") as rb:
        f.write("-- Auto-generated CEDS extended properties for Staging columns (CIID-9057).\n")
        f.write("-- Review before running. Rollback: Staging_CEDS_ExtendedProperties.rollback.sql\n\n")
        rb.write("-- Rollback: drops the CEDS extended properties added by the generated script.\n\n")
        for c in confident:
            f.write(f"-- {c['table']}.{c['column']}  ->  {c['element']} ({c['globalId']})  "
                    f"[{c['source']}; conf {c['confidence']}]\n")
            for prop, key in props:
                stmt = emit_add_property(args.schema, c["table"], c["column"], prop, c.get(key))
                if stmt:
                    f.write(stmt)
            f.write(emit_add_property(args.schema, c["table"], c["column"], "MS_Description", MS_DESCRIPTION))
            f.write("\n")
            for prop, _ in props + [("MS_Description", None)]:
                rb.write(emit_drop_property(args.schema, c["table"], c["column"], prop))
        f.write("\nPRINT 'Applied CEDS extended properties to " + str(len(confident)) + " Staging columns.';\n")

    uncertain_csv = os.path.join(here, "uncertain_columns.csv")
    with open(uncertain_csv, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["Table", "Column", "DataType",
                    "Suggestion1", "Score1", "Suggestion2", "Score2", "Suggestion3", "Score3",
                    "ChosenGlobalId (fill in)", "Notes"])
        for u in uncertain:
            s = u["suggestions"] + [None] * (3 - len(u["suggestions"]))
            cells = []
            for sug in s:
                if sug:
                    cells += [f"{sug['label']} ({sug['globalId']})", sug["score"]]
                else:
                    cells += ["", ""]
            w.writerow([u["table"], u["column"], u["dataType"], *cells, "", ""])

    md_path = os.path.join(here, "uncertain_columns.md")
    with open(md_path, "w", encoding="utf-8") as f:
        f.write(f"# Staging columns needing guidance ({len(uncertain)})\n\n")
        f.write("| Table | Column | Type | Top suggestion | Alt 1 | Alt 2 |\n")
        f.write("|---|---|---|---|---|---|\n")
        for u in uncertain:
            s = u["suggestions"] + [None] * (3 - len(u["suggestions"]))
            def fmt(x):
                return f"{x['label']} ({x['globalId']}) · {x['score']:.2f}" if x else "—"
            f.write(f"| {u['table']} | {u['column']} | {u['dataType']} | {fmt(s[0])} | {fmt(s[1])} | {fmt(s[2])} |\n")

    print(f"\nConfident (auto-annotated): {len(confident)}")
    src = Counter(c["source"].split(" on ")[0].split(" (")[0] for c in confident)
    for k, v in src.most_common():
        print(f"  {v:4d}  {k}")
    strong = sum(1 for u in uncertain if u["topScore"] >= 0.75)
    print(f"Needs guidance: {len(uncertain)}  (of which {strong} have a suggestion >= 0.75)")
    print(f"Skipped as internal (no CEDS mapping): {len(skipped)}")
    print(f"\nWrote:\n  {apply_path}\n  {rollback_path}\n  {uncertain_csv}\n  {md_path}")


if __name__ == "__main__":
    main()
