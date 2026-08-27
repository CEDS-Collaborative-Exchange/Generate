---
name: adapting-agent
description: Adapt a Codex agent (instructions plus profile/capability configuration) — or another assistant's agent file — into a Claude Code-compatible subagent, optionally for a different repository with a different tech stack and business domain. Use when the user wants to port, convert, adapt, replicate, or reuse an agent for Claude Code, including converting Codex agents to Claude Code subagents, or says things like "make this Codex agent work in Claude Code", "convert this agent from Codex", or "I have an agent from another project/assistant I want to use here". Covers the agent instructions, capability/tool configuration, referenced skills/files, persona, and repo-specific rules. Distinct from adapting-skill because agents have profile/configuration, tool capability choices, memory/deployment context, and role behavior to adapt.
---

# Adapting an Agent to Claude Code for a New Repository

Take an existing agent — most often a Codex agent, but possibly one written for another assistant — and adapt it into a Claude Code-compatible subagent, optionally for a different repository that has a different tech stack and/or business domain. The output should be a Claude Code subagent file (`.claude/agents/<name>.md` or `~/.claude/agents/<name>.md`), not a Codex agent or other assistant-specific configuration. Agents differ from skills because they include profile/configuration, tool capability choices, optional memory or knowledge behavior, a persona or role definition, critical rules tied to a specific stack, and reference tables (file types, path patterns, commands) that are often tightly coupled to the source repo.

## Inputs

The caller provides:

1. **The source agent** — a Codex agent (instructions plus its capability configuration: web search, image generation, connector apps, memory, deployment channel), an agent file from another assistant ecosystem, or equivalent contents written for a different repository. An agent file may also have sub-files alongside it (e.g., a `references/` subdirectory) and may reference skills that themselves have sub-files — all of these must also be adapted.
2. **The target repository** — the codebase the agent should be adapted to. This is typically the current working directory, and is often the *same* repository the Codex agent already lives in (only the assistant platform changes, not the tech stack).
3. **The Claude Code agent destination** — optional when the user only wants rewritten content, but required before writing files. Use the current repo's `.claude/agents/<name>.md` when the agent is project-specific; use `~/.claude/agents/<name>.md` when it should be personally available across every project.

If the user hasn't provided the source agent or target repository, ask for it before proceeding. If only the destination is missing, proceed with analysis and ask before writing files.

## Workflow

### Step 1: Analyze the Source Agent

Read the source agent file and its capability/profile configuration. If it comes from Codex or another assistant ecosystem, treat its configuration and tool/capability setup as source material to convert, not as Claude Code configuration to preserve verbatim. Also check whether it has sub-files — look for a `references/` subdirectory or any other files alongside the agent that it links to. Read those sub-files too. Apply the same five-category classification to the agent file **and** to each sub-file.

Classify every section into one of five categories:

| Category | Description | Examples from a typical Codex agent | Action |
|---|---|---|---|
| **Assistant-platform config** | Source-assistant mechanics such as capability toggles, connector apps, deployment channel, memory setting, or agent layout | Web search on/off, image generation, connector apps (Slack/Notion/etc.), "deploy to API channel", "respond only when mentioned in Slack" | Convert to Claude Code subagent frontmatter (`tools`, `model`, `mcpServers`) or drop if there is no Claude Code equivalent |
| **Universal logic** | Workflow steps, output format templates, general guidelines, git commands that work in any repo | "Read every file in full", "Return the scope description as your final output", `git diff --name-only` | Keep unchanged |
| **Agent behavior** | Persona, response style, user-facing behavior, knowledge usage, starter prompts | "Act as a senior engineer", "use memory for per-user preferences" | Fold into the Claude Code subagent's markdown body (its system prompt) while preserving intent |
| **Tech stack conventions** | Persona/role definition referencing a stack, file type identification tables, path pattern mappings, framework-specific rules | "React 19, Angular 18, Drupal 11, .NET 8 Web API", `src/app/components/*/*.component.ts → component`, `modules/custom/*/src/Controller/*Controller.php → controller` | Replace with target repo equivalents (skip if source and target repo are the same) |
| **Domain specifics** | Business domain references, entity names, feature-specific examples | "grants management platform", "communities of practice portal", "compliance reporting dashboard" | Replace with target repo equivalents (skip if source and target repo are the same) |

List what you found in each category before proceeding.

### Step 2: Explore the Target Repository

If the target repository is the same repository the source agent already lives in, skip the tech-stack and domain discovery below and go straight to identifying Claude Code capabilities (item 7) — the platform mechanics are what's changing, not the stack.

Otherwise, discover the target repo's conventions by examining its actual structure:

1. **Tech stack identification** — Look at the root for framework indicators:
   - `package.json` (or `requirements.txt`, `go.mod`, `Cargo.toml`, `Gemfile`, `pom.xml`, etc.) for language/framework
   - Config files: `next.config.*`, `angular.json`, `vite.config.*`, `webpack.config.*`, `settings.py`, etc.
   - Entry points: `src/main.ts`, `app/layout.tsx`, `cmd/main.go`, `src/lib.rs`, etc.

   From these, identify the primary language, framework, ORM, API layer, and database.

2. **Directory structure** — Run a directory listing from the repo root. Identify the top-level organization pattern (feature-based, layer-based, hybrid).

3. **File naming conventions** — Note casing, suffixes, and patterns (e.g., `*.controller.ts`, `*.service.py`, `*_handler.go`, `*.spec.ts`, `*_test.go`).

4. **Trace 2–3 complete features** — Pick 2–3 representative features and trace them across layers:
   - Route / endpoint / handler
   - Business logic / service layer
   - Types / models / schemas / DTOs
   - Tests (location relative to source, naming convention)
   - UI components (if applicable)
   - How layers import and reference each other

5. **Build the file type taxonomy** — Create the full list of file types present in this repo (e.g., controller, model, middleware, hook, store, resolver, migration, fixture, interceptor, pipe, decorator, etc.).

6. **Build the "related files" graph** — For each file type, note which other types are commonly co-referenced.

7. **Identify Claude Code capabilities** — Check which frontmatter the adapted subagent needs:
   - **`tools`** — a comma-separated allowlist of Claude Code tools (`Read, Grep, Glob, Bash, Edit, Write, WebFetch, WebSearch, Agent, ...`), or omit the field entirely to allow all tools. Map the source agent's capability toggles onto this list: web search → `WebFetch`/`WebSearch`; file/codebase inspection → `Read, Grep, Glob`; running commands/tests → `Bash`; editing code → `Edit, Write`; delegating to further subagents → `Agent`.
   - **`model`** — an alias (`sonnet`, `opus`, `haiku`, `fable`), a full model ID, or `inherit` (default) if the source agent had a model preference worth preserving; otherwise omit and let it inherit.
   - **`mcpServers`** — if the source agent used connector apps (Slack, Notion, Jira, etc.), map them to the equivalent MCP server(s) available in the target environment, if any.
   - **No equivalent**: Claude Code subagents are invoked by a parent session (or the user) via the Agent tool inside a single CLI/IDE session — there is no built-in notion of "deploying" a lone subagent file to a Slack channel, API endpoint, or schedule the way a Codex Workspace Agent can be. If the source agent's deployment/channel behavior is essential to what the user wants, flag this explicitly rather than silently dropping it — building a standalone deployed agent is a job for the Claude Agent SDK (or, for Slack specifically, Claude Tag), not a subagent markdown file, and the user should decide whether that's actually what they need.
   - Image generation and most other Codex connector-app capabilities likewise have no direct Claude Code subagent equivalent — flag them rather than guessing at a substitute.

Document your findings before proceeding.

### Step 3: Build the Mapping

Create an explicit mapping between the source agent, Claude Code subagent frontmatter, and the target repo:

**Agent configuration:**
```
Source → Target
─────────────────────────────────
name: [source name] → [Claude Code subagent name — lowercase, no ":" or leading "-", matches the filename]
description: [source desc] → [Claude Code description: when the parent session should delegate to this subagent]
capabilities/connector apps: [source capabilities] → [Claude Code tools: ...] or [mcpServers: ...] or [flagged as no equivalent]
model preference: [source model] → [Claude Code model: sonnet|opus|haiku|fable|inherit, or omitted]
skills/reference files: [source skills/files] → [adapted Claude Code skills under .claude/skills, or flagged missing dependencies]
```

**Persona / role definition:**
```
Source: "senior software engineer ... in the [X] codebase — a [description] built with [stack A, stack B, stack C]"
Target: "senior software engineer ... in the [Y] codebase — a [description] built with [stack D, stack E, stack F]"
```

**File type identification table:**
```
Source Path Pattern → Target Path Pattern
─────────────────────────────────────────
[source pattern] ([source type]) → [target pattern] ([target type])
[source pattern] ([source type]) → [target pattern] ([target type])
...
```

**Critical rules:**
```
Source Rule → Target Equivalent (or dropped / added)
─────────────────────────────────────────────────────
[source rule] → [adapted rule or "N/A — no equivalent"]
[no source equivalent] → [new rule needed for target repo]
```

Review this mapping with the user if the conversation is interactive.

### Step 4: Build New Examples (if the agent contains examples)

If the source agent includes example outputs or sample scenarios, and the target repo differs from the source, replace them with real examples from the target repo. Pick 1–2 completed features and write out what the Claude Code subagent's output should look like using the same output format when it remains appropriate for Claude Code.

### Step 5: Rewrite the Agent

Produce the adapted Claude Code subagent file by working through each section:

1. **Frontmatter** — Set `name` (lowercase, no `:` or leading `-`, matching the destination filename) and `description` (the trigger for when the parent session should delegate to this subagent — be specific, since this is what drives selection). Add `tools` and `model` per the Step 3 mapping only when the source agent's capabilities call for restricting them; omitting `tools` grants all tools and omitting `model` inherits the session model, both reasonable defaults. Do not preserve Codex-only configuration (connector app toggles, deployment channel, starter prompts, memory UI setting) as literal frontmatter — either map it to `tools`/`mcpServers`/`model`, fold the intent into the system-prompt body, or drop it with a note.

2. **Persona / objective** — Rewrite the opening paragraph to reference the target repo's name, domain description, and tech stack. Keep the same role and objective structure.

3. **Tool-use instructions** — Convert source capability assumptions into instructions for how this subagent should use its Claude Code `tools`: when to search the web (if `WebSearch`/`WebFetch` are granted), when to inspect files (`Read`/`Grep`/`Glob`), when to run commands (`Bash`), when to edit (`Edit`/`Write`), and when to delegate further (`Agent`).

4. **Workflow section** — Keep the workflow steps. Update any references to specific frameworks, file types, or patterns.

5. **Critical rules** — Adapt each rule to the target stack. Drop rules that don't apply. Add new rules for target-repo-specific concerns that the source agent didn't need.

6. **Reference tables** (file types, path patterns, commands) — Replace entirely with the target repo's equivalents from Step 2 (skip if source and target repo are the same).

7. **Output format** — Keep unchanged unless the target repo requires different metadata in the output.

8. **Guidelines** — Keep universal guidelines unchanged. Update any that reference specific tech or Codex-specific mechanics.

9. **Sub-files** — If the agent has sub-files (e.g., `references/patterns.md`), apply the same five-category classification and rewrite each one using the Step 3 mapping. Preserve sub-file structure and section headings; only replace assistant-platform conventions, agent behavior framing, tech stack references, and domain examples.

### Step 6: Check for Skill Dependencies

If the source agent references skills that are specific to Codex or the source repo:

1. Check if adapted versions already exist in the target repo's `.claude/skills/` directory.
2. If not, flag each missing skill and ask the user whether they want to adapt those skills as well (using the `adapting-skill` skill if available, or manually).
3. When adapting referenced skills, apply the full `adapting-skill` workflow — including discovering and adapting any sub-files (e.g., `references/` directories) those skills contain.
4. Update the Claude Code subagent's instructions or skill references to use the correct adapted skill names for the target repo (e.g., invoking `$skill-name` or referencing it by name in the workflow).

### Step 7: Validate

Before presenting the final agent, verify:

- [ ] The final output is a Claude Code subagent file, not a Codex agent or other assistant-specific configuration
- [ ] Frontmatter is valid: `name` is lowercase with no `:` or leading `-` and matches the filename; `description` clearly states when to delegate to this subagent
- [ ] Any `tools`, `model`, or `mcpServers` values used are valid (real Claude Code tool names; `model` is `sonnet`/`opus`/`haiku`/`fable`/a full model ID/`inherit`)
- [ ] The persona references the correct repo name, domain, and tech stack
- [ ] Every file path pattern in reference tables corresponds to real paths in the target repo
- [ ] Every file type in the taxonomy exists in the target repo
- [ ] No Codex-specific capability toggles, connector app references, deployment/channel mechanics, or other source-assistant configuration remain as literal frontmatter unless explicitly flagged as unmapped
- [ ] No references to the source repo's name, tech stack, or domain remain (unless they overlap, or source and target repo are the same)
- [ ] Critical rules are appropriate for the target stack (no leftover framework-specific rules from the source)
- [ ] The output format is unchanged from the source agent
- [ ] Any referenced skills exist under `.claude/skills/` or have been flagged as needing adaptation
- [ ] Examples (if any) reference real files in the target repo
- [ ] All agent sub-files have been adapted (no sub-file still refers to Codex mechanics, or the source repo's stack or domain when it differs)
- [ ] Sub-file structure and section headings are preserved
- [ ] All skill sub-files (from adapted skill dependencies) have also been adapted
- [ ] The agent is written to `.claude/agents/<name>.md` (project-scoped) or `~/.claude/agents/<name>.md` (personal-scoped) per the requested destination

Fix any issues found, then present the adapted agent file, any adapted sub-files, and any adapted skills to the user.

## Guidelines

- **Explore before you write.** The most common failure mode is guessing at conventions instead of reading the actual codebase. Always run Step 2 thoroughly when the target repo differs from the source.
- **Preserve the original agent's intent.** Adaptation, not reinvention. The workflow, output format, and role should remain structurally identical.
- **Target Claude Code deliberately.** The adapted artifact is a Claude Code subagent. Convert Codex (or other source-assistant) capability configuration into `tools`/`model`/`mcpServers` frontmatter or system-prompt instructions, and keep only the pieces that help Claude perform the task.
- **Agents are more than skills.** An agent has a persona, tool/capability configuration, optional model preference, and skill dependencies on top of the instructional content. Don't overlook frontmatter and the opening paragraph.
- **Handle missing equivalents explicitly.** If the target repo lacks an equivalent for something in the source agent (e.g., the source has DTOs but the target uses raw types), note the omission in the adapted file rather than silently dropping it. Likewise, if a Codex capability (deployment channel, image generation, a specific connector app) has no Claude Code subagent equivalent, say so explicitly instead of inventing one.
- **Handle new concerns explicitly.** If the target repo has layers the source agent didn't account for (e.g., middleware, GraphQL resolvers, state management), add them to the appropriate tables and rules.
- **Flag unadapted skill dependencies.** Never silently reference a skill that hasn't been ported. Either adapt it, remove the reference, or inline the essential instructions.
- **Adapt issue tracker references.** Issue-tracker tooling (`gh` CLI vs. Jira MCP tools) is not assistant-specific — both Codex and Claude Code support MCP servers via the same `mcp__<server>__<tool>` naming convention — so these references usually carry over unchanged. Only rewrite them if the target repo actually uses a different tracker than the source. To detect the target repo's issue tracker, check for `.github/` directories (GitHub) or Jira config files, and run `gh repo view --json hasIssuesEnabled 2>/dev/null` to confirm GitHub Issues availability.
- **Keep the agent self-contained.** The adapted agent should work on its own without needing to reference the source agent.
