---
name: adapting-skill
description: Adapt a Codex skill (SKILL.md plus any agents/*.yaml interface metadata) — or any other assistant's instruction file — into a Claude Code-compatible skill, optionally for a different repository with a different tech stack and business domain. Use when the user wants to port, convert, adapt, replicate, or reuse a skill for Claude Code, including converting Codex skills to Claude Code skills, or says things like "make this Codex skill work in Claude Code", "convert this skill from Codex", or "I have a skill from another project/assistant I want to use here". Also use when the user has a generic skill template they want customized as a Claude Code skill.
---

# Adapting a Skill to Claude Code for a New Repository

Take an existing skill — most often a Codex skill, but possibly one written for another assistant — and adapt it into a Claude Code-compatible skill, optionally for a different repository that has a different tech stack and/or business domain. The output should be a Claude Code skill folder whose primary artifact is `SKILL.md`, not a Codex skill, Codex agent, or other assistant-specific configuration file.

## Inputs

The caller provides:

1. **The source skill** — a Codex `SKILL.md` (optionally paired with an `agents/*.yaml` interface file), a skill/instruction file from another assistant ecosystem, or equivalent skill contents written for a different repository. A skill may also include sub-files (e.g., a `references/`, `scripts/`, or `assets/` subdirectory) that are part of the skill and must also be adapted.
2. **The target repository** — the codebase the skill should be adapted to. This is typically the current working directory, and is often the *same* repository the Codex skill already lives in (only the assistant platform changes, not the tech stack).
3. **The Claude Code skill destination** — optional when the user only wants rewritten content, but required before writing files. Use the current repo's `.claude/skills/<skill-name>/` when the skill is project-specific; use `~/.claude/skills/<skill-name>/` when the skill should be personally available across every project.

If the user hasn't provided the source skill or target repository, ask for it before proceeding. If only the destination is missing, proceed with analysis and ask before writing files.

## Workflow

### Step 1: Analyze the Source Skill

Read the source skill. If it is a Codex skill, read `SKILL.md` and, if present, its sidecar `agents/*.yaml` file (Codex's optional interface metadata — typically `interface.display_name`, `short_description`, and `default_prompt`). If it comes from another assistant ecosystem, read the closest primary instruction file and treat it as source material to convert. Also check for sub-files — a `references/`, `scripts/`, or `assets/` subdirectory, or any other files linked from the primary instruction file. Read those sub-files too. Apply the same four-category classification to the primary file **and** to each sub-file.

Classify every section into one of four categories:

| Category | Description | Action |
|---|---|---|
| **Assistant-platform conventions** | Codex-specific (or other source-assistant) frontmatter, `agents/*.yaml` interface metadata, `$CODEX_HOME`/`~/.codex` path references, Workspace Agent mechanics, or other source-assistant mechanics | Convert to Claude Code skill structure or drop if there is no Claude Code equivalent |
| **Universal logic** | Workflow steps, git commands, output formats, guidelines, general principles | Keep unchanged |
| **Tech stack conventions** | File path patterns, naming conventions, file type taxonomies, framework-specific references, "related files" mappings | Replace with target repo equivalents (skip if source and target repo are the same) |
| **Domain examples** | Concrete illustrations using the source repo's business domain (feature names, entity names, sample outputs) | Replace with examples drawn from the target repo (skip if source and target repo are the same) |

List what you found in each category before proceeding. This ensures nothing is missed and gives the user a chance to correct misclassifications.

### Step 2: Explore the Target Repository

If the target repository is the same repository the source skill already lives in, skip straight to Step 3 — the tech stack and domain conventions don't need rediscovering, only the platform mechanics change.

Otherwise, discover the target repo's conventions by examining its actual structure. Do all of the following:

1. **Directory structure** — Run a directory listing from the repo root (e.g., `find . -type f -name '*.ts' -o -name '*.py' -o -name '*.go' -o -name '*.rs' -o -name '*.java' -o -name '*.rb' | head -80` or similar, adjusted to the languages present). Identify the top-level organization pattern.

2. **File naming conventions** — Note how files are named: kebab-case, camelCase, PascalCase, suffixes like `.controller.ts`, `.service.py`, `.spec.ts`, `_test.go`, etc.

3. **Trace 2–3 complete features** — Pick 2–3 features that are representative of the codebase and trace them end-to-end across layers. For each feature, identify:
   - Where the route/endpoint/handler lives
   - Where the business logic / service layer lives
   - Where types, models, schemas, or DTOs are defined
   - Where tests live relative to source files
   - Where UI components live (if applicable)
   - How layers import/reference each other

4. **Identify the file type taxonomy** — Based on what you found, build the list of file types that exist in this repo (e.g., controller, model, middleware, hook, store, resolver, migration, fixture, etc.).

5. **Identify the "related files" graph** — For each file type, note which other file types are commonly co-referenced (e.g., "a controller typically imports a service and a DTO", "a component typically imports a hook and a store").

Document your findings before proceeding.

### Step 3: Build the Mapping

Create an explicit mapping between the source skill's conventions, Claude Code skill requirements, and the target repo's conventions:

```
Source → Target
─────────────────────────────────
[source assistant-specific concept] → [Claude Code skill equivalent or dropped]
[source path pattern] → [target path pattern]
[source file type] → [target file type]
[source related-file rule] → [target related-file rule]
[source domain term] → [target domain term]
...
```

Review this mapping with the user before rewriting if the conversation is interactive. If running autonomously, proceed with your best mapping.

### Step 4: Build New Examples

If the target repo differs from the source repo, pick 1–2 real, completed features from the target repo and write out what the adapted Claude Code skill's output **should** look like for those features. Follow the source skill's output format when it remains appropriate for Claude Code — only the content changes. Skip this step if the source and target repo are the same.

These examples should be:
- **Real** — drawn from actual files in the repo, not hypothetical
- **Representative** — covering the most common patterns in the codebase
- **Complete** — showing every section of the output format so the skill consumer knows what to expect

### Step 5: Rewrite the Skill

Produce the adapted Claude Code `SKILL.md` by:

1. **Copying universal logic verbatim** — workflow steps, git commands, output format templates, and guidelines.
2. **Converting assistant-platform conventions** — rewrite Codex-specific (or other source-assistant-specific) mechanics into Claude Code skill instructions. Do not preserve Codex-only concepts such as `$CODEX_HOME` paths, Workspace Agent references, or Codex's own tool names in the Claude Code `SKILL.md`.
3. **Replacing tech stack conventions** — swap in the target repo's path patterns, file type taxonomy, and related-files mapping using the Step 3 mapping (skip if source and target repo are the same).
4. **Replacing domain examples** — swap in the Step 4 examples (skip if source and target repo are the same).
5. **Updating the Claude Code frontmatter** — keep the same `name` unless the user wants to rename it; it must be lowercase and match the destination folder name. Set `description` to state plainly what the skill does *and* when Claude should use it — Claude auto-invokes a skill by matching this description against the conversation, so it needs to be explicit and trigger-phrase-rich, not just a label. Only add other frontmatter fields (`allowed-tools`, `model`, `effort`, `context: fork`, etc.) if the skill genuinely needs them; the rest of this repo's skills keep frontmatter to just `name` and `description`, so match that convention unless there's a concrete reason not to.
6. **Folding in Codex sidecar metadata** — if the source skill has an `agents/*.yaml` interface file, there is no Claude Code sidecar equivalent. Fold its `default_prompt` (and any other user-facing framing) into the `SKILL.md` description's trigger phrases so the same invocation intent still gets recognized, then drop the YAML file — Claude Code does not read it. Do not create a `agents/openai.yaml`-style file in the adapted skill.
7. **Adapting sub-files** — if the skill has sub-files (e.g., `references/patterns.md`), apply the same four-category classification and rewrite each one. Use the same Step 3 mapping and Step 4 examples. Preserve the sub-file's structure and section headings; only replace assistant-platform conventions, tech stack references, and domain examples.

### Step 6: Validate

Before presenting the final skill, do a quick sanity check across the SKILL.md **and all adapted sub-files**:

- [ ] Every file path pattern in the skill corresponds to real paths in the target repo
- [ ] Every file type in the taxonomy exists in the target repo
- [ ] Every example references real files that exist in the target repo
- [ ] The final output is a Claude Code skill with valid `SKILL.md` frontmatter (`name` matches the folder, `description` states what it does and when to use it)
- [ ] No Codex-specific paths (`$CODEX_HOME`, `~/.codex`), `agents/*.yaml` sidecar files, Workspace Agent references, or other source-assistant mechanics remain unless explicitly discussed as source material to convert
- [ ] No references to the source repo's tech stack or domain remain (unless they happen to overlap, or source and target repo are the same)
- [ ] The output format is unchanged from the original skill
- [ ] Universal guidelines are preserved
- [ ] All sub-files have been adapted (no sub-file still refers to Codex mechanics, or the source repo's stack or domain when it differs)
- [ ] Sub-file structure and section headings are preserved
- [ ] The skill is written to `.claude/skills/<name>/SKILL.md` (project-scoped) or `~/.claude/skills/<name>/SKILL.md` (personal-scoped) per the requested destination

Fix any issues found, then present the adapted SKILL.md and any adapted sub-files to the user.

## Guidelines

- **Explore before you write.** The most common failure mode is guessing at the target repo's conventions instead of reading the actual code. Always run Step 2 thoroughly when the target repo differs from the source.
- **Preserve the original skill's intent.** The goal is adaptation, not reinvention. If the original skill has a specific workflow or output format, keep it. Only change what's platform- or repo-specific.
- **Target Claude Code deliberately.** The adapted artifact is a Claude Code skill. Convert Codex (or other source-assistant) mechanics into Claude Code instructions, and keep only the pieces that help Claude perform the task.
- **The description is load-bearing.** Unlike a Codex `default_prompt` shown in a picker, Claude Code's `description` field is what triggers auto-invocation. A vague or generic description means the skill silently never fires — be concrete about the triggering phrases and situations.
- **When in doubt, include more context.** If you're unsure whether a convention mapping is correct, note the uncertainty and include both options for the user to choose from.
- **Handle partial matches gracefully.** The target repo may not have an equivalent for every concept in the source skill. If a section doesn't apply (e.g., the source skill references DTOs but the target repo doesn't use them), drop that section and note the omission.
- **Handle new concepts gracefully.** The target repo may have layers or patterns the source skill didn't account for (e.g., middleware, guards, interceptors). Add them to the appropriate sections of the adapted skill.
- **Adapt issue tracker references.** Issue-tracker tooling (`gh` CLI vs. Jira MCP tools) is not assistant-specific — Claude Code and Codex both support MCP servers using the same `mcp__<server>__<tool>` naming convention — so these references usually carry over unchanged. Only rewrite them if the target repo actually uses a different tracker than the source. To detect the target repo's issue tracker, check for `.github/` directories (GitHub) or a `.mcp.json` / MCP configuration referencing `atlassian-rovo-mcp` (Jira).

  **GitHub → Jira:** If the source skill references GitHub (e.g., `gh issue create`, `gh label create`, GitHub Actions, PR workflows) but the target repository uses Jira, replace those references with Jira equivalents using the **`atlassian-rovo-mcp`** MCP server. All tool calls use the `mcp__atlassian-rovo-mcp__` prefix, and every call requires a `cloudId` parameter (obtain it once with `mcp__atlassian-rovo-mcp__getAccessibleAtlassianResources` and reuse). The core Jira tools are:

  | Tool | Purpose |
  |------|---------|
  | `mcp__atlassian-rovo-mcp__getJiraIssue` | Fetch a single issue (response includes comments) |
  | `mcp__atlassian-rovo-mcp__searchJiraIssuesUsingJql` | Search issues via JQL |
  | `mcp__atlassian-rovo-mcp__createJiraIssue` | Create a new issue |
  | `mcp__atlassian-rovo-mcp__editJiraIssue` | Update issue fields (e.g., `timetracking`) |
  | `mcp__atlassian-rovo-mcp__addCommentToJiraIssue` | Add a comment to an issue |
  | `mcp__atlassian-rovo-mcp__getTransitionsForJiraIssue` | List available workflow transitions |
  | `mcp__atlassian-rovo-mcp__transitionJiraIssue` | Move an issue to a new status |
  | `mcp__atlassian-rovo-mcp__addWorklogToJiraIssue` | Log work time on an issue |
  | `mcp__atlassian-rovo-mcp__lookupJiraAccountId` | Resolve a user's account ID |
  | `mcp__atlassian-rovo-mcp__getVisibleJiraProjects` | List accessible projects |
  | `mcp__atlassian-rovo-mcp__search` | Rovo Search across Jira and Confluence (use instead of JQL for general keyword searches) |

  There is **no dedicated "get comments" tool** — comments are included in the `getJiraIssue` response. Always fetch transitions dynamically with `getTransitionsForJiraIssue` rather than hardcoding transition IDs.

  **Jira → GitHub:** If the source skill references Jira (e.g., `mcp__atlassian-rovo-mcp__*` tools, JQL queries, Jira transitions) but the target repository uses GitHub Issues, replace those references with `gh` CLI equivalents. The core GitHub issue commands are:

  | Jira Concept | `gh` CLI Equivalent |
  |---|---|
  | `getJiraIssue` | `gh issue view <number>` (add `--comments` for comment thread) |
  | `searchJiraIssuesUsingJql` | `gh issue list --search "<query>"` (uses GitHub search syntax: `is:issue`, `label:`, `milestone:`, `assignee:`, `is:open`/`is:closed`) |
  | `createJiraIssue` | `gh issue create --title "..." --body "..." --label "..." --assignee "..."` |
  | `editJiraIssue` (fields) | `gh issue edit <number> --title "..." --body "..." --add-label "..." --add-assignee "..."` |
  | `addCommentToJiraIssue` | `gh issue comment <number> --body "..."` |
  | `getTransitionsForJiraIssue` | No direct equivalent — GitHub issues use open/closed state plus labels for status |
  | `transitionJiraIssue` (close) | `gh issue close <number>` |
  | `transitionJiraIssue` (reopen) | `gh issue reopen <number>` |
  | `transitionJiraIssue` (status via label) | `gh issue edit <number> --add-label "in-progress" --remove-label "todo"` |
  | `addWorklogToJiraIssue` | No direct equivalent — add a comment with time tracking info instead |
  | `lookupJiraAccountId` | GitHub usernames are used directly; verify with `gh api /users/<username>` |
  | `getVisibleJiraProjects` | `gh repo list <org>` or `gh api /orgs/<org>/repos` |
  | JQL (`project = X AND status = "In Progress"`) | GitHub search syntax (`is:issue is:open label:"in-progress" repo:<org>/<repo>`) |

  Note that GitHub Issues has no native workflow engine — "status" is modeled via labels or GitHub Projects board columns. When adapting Jira workflow transitions, prefer label-based status conventions (`todo`, `in-progress`, `in-review`, `done`) unless the target repo uses GitHub Projects, in which case use `gh project item-edit --field-id <id> --single-select-option-id <id>` to move cards between columns.
- **Keep the skill self-contained.** The adapted SKILL.md should work on its own without needing to reference the source skill.
