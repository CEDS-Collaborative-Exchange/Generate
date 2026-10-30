---
name: managing-issue
description: Retrieve one or more Generate GitHub issues through the `gh` CLI, validate the issue details (with an optional milestone gate), implement the required changes in this Generate (CIID EDFacts/IDEA reporting) Angular/.NET/SQL repository, verify with targeted builds and tests, run the reviewing-code review loop, commit the work, comment on the GitHub issue, track time savings, and update status labels. Use when the user asks Claude to address, implement, fix, start, pick up, or work on a GitHub issue number such as #123 (a `CIID-XXXX` internal ticket reference may also be given or expected in commit messages alongside it).
---

# Managing Generate GitHub Issues

## Keywords
address issue, work on ticket, implement story, fix bug, start ticket, work on issue, task, implement ticket, pick up ticket, tackle issue, resolve issue, address multiple tickets, work on several issues

## Overview

Workflow for addressing one or more Generate GitHub issues: fetch all issue details in parallel, optionally verify each issue's milestone status, then implement eligible issues on the currently checked-out branch.

**Use this skill when:** A user wants to start working on one or more GitHub issues and implement their requirements.

---

## Generate Repository Context

Generate is CIID's open-source EDFacts / IDEA special-education reporting tool for State Education Agencies (Apache 2.0, GitHub repo `CEDS-Collaborative-Exchange/Generate`). This repository has these main implementation areas:

- `generate.web/`: ASP.NET Core web host — `Controllers/Api` (REST endpoints, split into `App`, `ODS` sub-areas plus root-level controllers), `Controllers/Web` (MVC views), `ClientApp` (Angular 20.3.x SPA), `DatabaseScripts`/`DatabaseFiles`, `Security`, `Helpers`, `Utilities`, `Updates`, and `Config` (environment-specific `appsettings.*.json`).
- `generate.core/`: shared domain layer — `Dtos/{App,ODS,RDS}`, `Models/{App,IDS,RDS,Staging}`, `Interfaces/{Helpers,Repositories,Services}`, `ViewModels`, `Examples`.
- `generate.database/`: raw SQL — `Functions`, `StoredProcedures/{Create,Drop}`, `Tables/{Create,Drop}`, `TableTypes/{Create,Drop}`, `Views/{Create,Drop}`, `Indexes`, `Jobs`, `Scripts` (ad hoc/one-off scripts), and `VersionUpdates/<version>/` (versioned release migrations, e.g. `5.3/`, `11.0/`, `11.2/`, mirroring the same Functions/StoredProcedures/Tables/Views/Indexes/Metadata sub-structure).
- `generate.infrastructure/`, `generate.filestorage/`, `generate.background/`, `generate.console/`, `generate.shared/`, `generate.update/`, `generate.overnighttest/`: supporting projects.
- `generate.test/`: xUnit 2.9.3 + Moq 4.20 + Selenium (UI tests) + EFCore InMemory/Sqlite (data tests) + altcover, mirroring prod structure under `Background/`, `Console/`, `Core/`, `Infrastructure/`, `Shared/`, `TestData/`, `Update/`, `UserInterface/`, `Web/`.

Representative feature traces (verified against real files in this repo):

- **File submission**: `generate.web/Controllers/Api/App/FileSubmissionController.cs` → `generate.core/Interfaces/Services/IFileSubmissionService.cs` (plus `IAppRepository`/`IEdfactsFileService`) → `generate.core/Dtos/App/FileSubmissionDto.cs` and `generate.core/Models/App/FileSubmission.cs`.
- **Generate report**: `generate.web/Controllers/Api/App/GenerateReportController.cs` → `generate.core/Interfaces/Services/IGenerateReportService.cs` → `generate.core/Dtos/App/GenerateReportDto.cs` (and sibling `GenerateReportDataDto.cs`, `GenerateReportFilterDto.cs`) → consumed on the frontend by `generate.web/ClientApp/src/app/services/app/generateReport.service.ts`, which calls `api/app/generatereports` and `api/app/filesubmissions` and maps responses to `generate.web/ClientApp/src/app/models/app/generateReportDto.ts`.
- Backend API controller tests live one-to-one under `generate.test/Web/Tests/Controllers/Api/{App,ODS}/<Name>ControllerShould.cs` (e.g. `GenerateReportControllerShould.cs`), following an `<X>Should` naming convention rather than `<X>Tests`.

Common related-file graph:

- Angular page changes usually involve `.component.ts`, `.component.html`, `.component.scss`, a feature-local or `shared` service (`generate.web/ClientApp/src/app/services/**`), matching models under `generate.web/ClientApp/src/app/models/**`, and shared components under `generate.web/ClientApp/src/app/shared`.
- ASP.NET endpoint changes usually involve a controller (`generate.web/Controllers/Api/**`), a service interface + implementation (`generate.core/Interfaces/Services`), a DTO and/or Model (`generate.core/Dtos/**`, `generate.core/Models/**`), and a matching `<X>ControllerShould.cs` test under `generate.test/Web/Tests/Controllers/Api/**`.
- SQL/data changes usually involve raw SQL under `generate.database/Scripts/` (one-off) or `generate.database/VersionUpdates/<version>/` (versioned release migrations), plus `generate.core`/`generate.database` object definitions they replace. Schema or data migration work is high-risk; plan it explicitly before editing.

---

## Issue Tracker: `gh` CLI Reference

This repository uses **GitHub Issues** on `CEDS-Collaborative-Exchange/Generate` — there is no `.mcp.json` and no Jira/Atlassian MCP server configured, so the `gh` CLI is the only available issue-tracker tool. Confirm `gh` is installed and authenticated (`gh auth status`) before relying on it; if it is unavailable in your environment, tell the user rather than guessing at issue state.

| Purpose | Command |
|---|---|
| View an issue (with comments) | `gh issue view <number> --comments` |
| View machine-readable issue fields (e.g. milestone) | `gh issue view <number> --json title,body,labels,assignees,milestone,state,comments` |
| Search issues | `gh issue list --search "<query>"` (GitHub search syntax: `is:issue`, `label:`, `milestone:`, `assignee:`, `is:open`/`is:closed`) |
| Comment on an issue | `gh issue comment <number> --body "..."` |
| Add/remove labels, edit title/body/assignee | `gh issue edit <number> --add-label "..." --remove-label "..." --add-assignee "..."` |
| Close an issue | `gh issue close <number>` |
| Reopen an issue | `gh issue reopen <number>` |
| List labels that exist in the repo | `gh label list` |
| Create a label | `gh label create "<name>" --description "..." --color "..."` |
| List milestones | `gh api repos/CEDS-Collaborative-Exchange/Generate/milestones` |

There is no dedicated "get comments" call — `gh issue view <number> --comments` includes the comment thread in its output. GitHub Issues has no Jira-style workflow-transition engine or Fix-Version field; status and release-readiness are modeled via labels and milestones instead (see the gates below).

Commit messages and branch names in this repo use an internal `CIID-XXXX` reference (e.g. branch `feature/CIID-8438`, commit `CIID-8438 : Fix an issue with membership migration`). Treat `CIID-XXXX` as a human-readable reference to preserve in commit messages and comments alongside the GitHub issue number — **the GitHub issue number is the system of record**, not `CIID-XXXX`. If the user gives only a `CIID-XXXX` reference, ask them for (or search for) the corresponding GitHub issue number before proceeding, since `gh` operates on issue numbers.

**Labels confirmed to exist in this repo:** `bug`, `triage` (from `.github/ISSUE_TEMPLATE/BugReport.yml`), and `enhancement`, `question` (referenced in `docs/developer-guides/github-guide.md`). **No `in-progress`, `code-review`, or `todo` status labels were found** — the label-based status workflow in Step 4/Step 5 below assumes such labels exist or should be created with `gh label create`; verify with `gh label list` before relying on them, and create them (or fall back to a plain progress comment) if they're missing.

---

## Workflow

Follow this process to address one or more GitHub issues.

---

### Step 0: Inspect Worktree and Start Timing

1. Run `git status --short`.
2. Note the wall-clock start time for issue comments and time-savings tracking.
3. Preserve user changes. Do not revert unrelated files.
4. If unrelated changes exist, keep your edits scoped and stage only files for the current issue work.

---

### Step 1: Identify the GitHub Issue(s)

If the user did not supply any issue numbers, ask for them before proceeding.

#### Prompting for Issue Numbers

If no issue number was provided in the user's request, ask:

> "Which GitHub issue(s) would you like to address? Please provide one or more issue numbers separated by spaces (e.g., #123 #124), or the CIID-XXXX reference if that's what you have."

Wait for the user's response before continuing. If the user only has a `CIID-XXXX` reference, search for the matching GitHub issue (e.g. `gh issue list --search "CIID-XXXX"`) or ask them to look it up before proceeding.

#### Validate Issue Number Format

A valid issue reference is a bare or `#`-prefixed number (e.g., `123`, `#123`). If any provided value doesn't match, ask the user to confirm or correct it.

Parse all issue numbers from the user's input — they may be space-separated, comma-separated, or listed on separate lines.

---

### Step 2: Fetch Issue Details, Comments, and Milestone Status

Fetch all issue details **in parallel** using `gh issue view <number> --comments` (or `--json ... --comments` for structured fields), one call per issue.

**Read the comments** carefully. Comments often contain clarifications, follow-up requirements, or failure feedback that supersedes or supplements the original description.

#### Required Information to Collect (per issue)

- **Title** — the issue title
- **Body** — full requirements, acceptance criteria, or bug reproduction steps
- **Labels** — issue type/scope signal (e.g. `bug`, `enhancement`, `question`, `triage`, plus any file-spec or feature labels used by this repo)
- **State** — `open` or `closed`
- **Assignees** — who the issue is assigned to
- **Milestone** — assigned milestone, if any, and whether it is open or closed (see the gate below)
- **Linked issues / PRs** — cross-references mentioned in the body or comments
- **Recent comments** — fetch the latest comments and read them carefully for additional context

#### Milestone Gate (Soft — Verify Before Treating as a Hard Blocker)

GitHub Issues has no built-in release/fix-version field like Jira. The closest analog is a GitHub **milestone**: an issue can be assigned to a milestone, and a milestone has an open/closed state and an optional due date.

**This gate's status in this repo is unconfirmed.** `gh` was not available to query `gh api repos/CEDS-Collaborative-Exchange/Generate/milestones` while this skill was written, so it is unknown whether this repo actually uses milestones as a release gate in practice. Treat this gate as **optional/soft**, not a strict blocker, until a human confirms milestone usage:

1. Inspect the issue's `milestone` field (`gh issue view <number> --json milestone`).
2. If the repo is confirmed to use milestones as a release gate: an issue is eligible only when it has an assigned, **open** milestone. If not open, stop work on that issue, notify the user with wording like:

   > "Stopped work on #123: the issue does not have an open milestone assigned. Assign an open milestone, then ask me to resume."

3. If the repo is **not** confirmed to use milestones this way (the common case until verified), do not block on this — proceed to the next step, but mention in your summary to the user that no milestone gate was enforced and why, so a human can decide whether to tighten this later.
4. When processing multiple issues under a confirmed hard gate, skip each ineligible issue and continue only with eligible issues. If none are eligible, end the workflow after notifying the user.

#### Ignoring "Human Only" Sections

When reading the issue body or comments, **skip any content under a "Human Only" heading** (e.g., `## Human Only`, `### Human Only`, or similar). These sections contain instructions intended only for human developers or reviewers and should not influence your implementation.

#### Interpreting Comments

- Always read the most recent comments before planning or coding — they may refine, correct, or expand the original requirements
- **If the issue has a label or comment indicating a failed/rejected prior attempt** (e.g., a `qa-failed`, `review-failed`, or similar label, or comment text to that effect): the previous implementation was rejected. The comments will contain the reviewer's or tester's feedback explaining what was wrong or insufficient. Treat this feedback as the primary requirements for the fix — do not simply re-implement the original description. **Note:** Track which issues were previously rejected — you will need to perform a root cause analysis for these after implementation (see Step 8b)
- If comments reference specific files, line numbers, or behaviors, prioritize those over general description text

#### Initial Defect + Enhancement Split Check

Before summarizing, labeling, estimating, or implementing an issue, check the body and comments for mixed scope. If an issue describes both:

- A **defect** or bug fix: existing behavior is incorrect, broken, or regressed
- An **enhancement** or improved functionality: new behavior, expanded behavior, or a better workflow beyond restoring the expected existing behavior

Then add a comment using `gh issue comment <number> --body "..."` and stop work on that issue. Do not label it in-progress, estimate it, validate it further, implement it, or include it in later workflow steps. If processing multiple issues, continue with the remaining issues that do not have this mixed scope.

Use this comment format:

```
This issue was picked up for AI implementation, but it appears to include both a defect and an enhancement/improved-functionality request.

To keep the work clear and reviewable, please split this into two separate issues:
- One Bug issue for the existing behavior that is broken, including the current behavior, expected behavior, and reproduction steps.
- One Enhancement issue for the improved or new functionality, including acceptance criteria.

Please link the separated issue(s) here when ready.
```

After fetching, running the milestone gate, and completing the initial split check, summarize all issues that are still eligible for implementation for the user:

```
Issue: #123 (CIID-8438)
Labels: bug | Priority: (from label/body if present)
Title: <title text>
State: open
---
<Body / acceptance criteria>

Issue: #124
Labels: enhancement
Title: <title text>
State: open
---
<Body / acceptance criteria>
```

Then proceed to Step 3.

---

### Step 3: Validate Issue Quality Against Guidelines

Before beginning any work, check whether the issue descriptions are clear enough for AI implementation.

#### 3a: Check for Guidelines Document

Check whether the file `docs/writing-issues-for-ai.md` exists in the repository. If it does **not** exist, skip this step entirely and proceed to Step 4.

#### 3b: Evaluate Each Issue Against the Guidelines

If the guidelines document exists, read it, then evaluate **each** issue's body (and comments) against the guidelines. Check for these problems:

| Guideline | What to flag |
|-----------|-------------|
| **Explicit behavior** (Guideline 1) | Body only says something is "broken" or "not working" without explaining current vs. expected behavior |
| **Self-contained** (Guideline 2) | Body references prior issues, conversations, or assumed knowledge without explaining them (e.g., "same issue as before", "as we discussed") |
| **No environment-specific data** (Guideline 3) | Body references specific user names, record IDs, or data that only exists in a particular environment as the primary way to understand the issue |
| **No screenshot dependency** (Guideline 4) | Key information is conveyed only through an attached screenshot with no text description of what it shows |
| **Description field usage** (Guideline 6) | Critical requirements are only in comments rather than the body, making the issue hard to understand without reading the full comment thread |
| **Business rules stated** (Guideline 7) | The issue involves calculations, validation, or conditional logic but does not state the expected rule |
| **One issue per ticket** (Guideline 9) | The body contains multiple unrelated issues bundled into a single ticket |

**Do not flag minor or cosmetic issues.** Only flag problems that would genuinely prevent you from implementing the correct fix — i.e., you cannot determine with reasonable confidence what needs to change or what the correct behavior should be.

#### 3c: If Issues Are Found — Comment and Stop

If any issue has **significant** guideline problems (you cannot confidently determine what to implement):

1. Add a comment to the GitHub issue using `gh issue comment <number> --body "..."` with the following format:

```
This issue was picked up for AI implementation but the description needs revision before work can begin.

**Issues identified:**
- <Describe each problem clearly, referencing the specific guideline>

**What would help:**
- <Specific suggestions for improving the description>

For reference, the team's guidelines for writing AI-friendly issues can be found in `docs/writing-issues-for-ai.md` in the repository.

Please revise the description and re-request when ready.
```

2. **Stop work on that issue.** Do not label it in-progress, do not begin implementation.
3. If processing multiple issues, continue evaluating the remaining issues — only skip the ones that fail validation. Issues that pass validation proceed to Step 4 normally.
4. Inform the user which issues were skipped and why.

#### 3d: If No Issues Are Found — Proceed

If all issues are clear enough to implement confidently, proceed to Step 4.

---

### Step 4: Estimate Human Effort and Label All Issues In Progress

For **each** issue, estimate the work and mark it **in progress**.

#### 4a: Estimate Human Development Time (per issue)

Based on the issue body, labels, and scope, estimate how long a **human developer** (without AI assistance) would realistically need to complete the work. Use these guidelines:

| Complexity | Examples | Estimate |
|------------|----------|----------|
| Trivial | Typo fix, label change, single-line tweak | 30m |
| Simple | Cosmetic/styling change, single-component UI addition | 1h |
| Small | Simple bug fix with clear root cause, minor feature tweak | 2h |
| Moderate | New UI component, service method addition, moderate bug fix | 4h |
| Standard | New page or feature spanning 2–3 files, API + frontend wiring | 1d |
| Large | Multi-file feature, new workflow, cross-layer changes | 2d–3d |
| Complex | New subsystem, significant architectural change | 1w+ |

This estimate has no field to set on the GitHub issue itself (GitHub Issues has no native time-tracking field, unlike Jira's `timetracking`). Keep the estimate in memory — it only needs to flow into the `docs/time-savings.md` tracking file later (Step "Record Time Savings to Tracking File").

#### 4b: Mark Each Issue In Progress

For each issue (in parallel):

1. Check `gh label list` to confirm an `in-progress` label exists (create it with `gh label create "in-progress" --description "Actively being worked on" --color "..."` if it doesn't and the repo's label conventions make sense for this — otherwise skip labeling and note in the summary that status isn't being tracked via labels).
2. Apply it: `gh issue edit <number> --add-label "in-progress"` (and remove a `todo`/`triage` label if one is present and appropriate: `--remove-label "triage"`).

If labeling isn't practical (label doesn't exist and shouldn't be created), skip this sub-step for that issue and continue — it is not a blocker for implementation.

---

### Step 5: Implement the Required Changes

Implement all issues on the currently checked-out branch. The implementation strategy depends on whether the issues are related or independent.

#### Assess Relatedness

Before coding, determine whether the issues touch the same files or features:

- **Related issues** (same feature area, overlapping files): implement together in a holistic pass, then make a single combined commit referencing all issue numbers.
- **Independent issues** (different areas, no overlap): implement sequentially, committing after each one with its own commit message.

#### Review Lessons Learned

Before implementing, check whether `docs/lessons-learned.md` exists. If it does, read it and review the entries for any lessons relevant to the current issue's area (e.g., tab placement, field mapping, UI patterns, API wiring, naming conventions). Apply relevant lessons proactively to avoid repeating past mistakes.

For example, if a past lesson says "When reviewer feedback says fields should be on a specific tab, relocate the template markup — don't just rename headings," and the current issue involves moving UI elements between tabs, apply that lesson directly to your implementation approach.

#### Analysis Approach (for each issue)

1. **Read the issue thoroughly** — understand what needs to be built or fixed
2. **Explore the codebase** — find the relevant files before making changes
3. **Check the feature map** (`docs/feature-map.md`) if it exists and the issue involves a feature area — it would document the high-level feature organization across Generate (this file does not currently exist in this repo; skip this sub-step if so)
4. **Review lessons learned** — check `docs/lessons-learned.md` for relevant past takeaways that apply to this type of issue
5. **Plan before coding** — for non-trivial or high-risk work, present the approach to the user before writing code

#### Implementation Guidelines

Follow the repository's existing Generate conventions:

- **Angular**: Angular 20.3.x SPA at `generate.web/ClientApp`, feature areas such as `about`, `home`, `reports`, `resources`, `settings`, plus `shared` components/pipes and `services` (including `services/app/*.service.ts` calling `api/app/**` endpoints) and `models` for DTO-shaped TypeScript interfaces.
- **Backend**: ASP.NET Core (.NET 10), controllers under `generate.web/Controllers/{Api,Web}`, service interfaces/implementations in `generate.core/Interfaces/Services`, repositories in `generate.core/Interfaces/Repositories/{App,ODS,RDS,Staging}`, and DTOs/Models in `generate.core/{Dtos,Models}/**`.
- **Auth**: Preserve authentication/authorization attributes, claims handling, and route guards/interceptors unless the issue explicitly changes them.
- **SQL and data access**: Keep SQL parameterized where applicable, and treat schema/data migrations as high-risk changes requiring an explicit plan.
- **Shared UI components**: Check `generate.web/ClientApp/src/app/shared` before creating new components.
- Keep changes focused — only address what the issues require

#### Database Changes for GitHub Issues

**SQL script filename convention:** This repo already has a real precedent for issue-referenced SQL scripts — `generate.database/Scripts/CIID-6030 INS Script.sql` — which uses the `CIID-XXXX` reference (not the bare GitHub issue number) as a filename prefix, space-separated from a short description, not `snake_case`. Follow that established convention:

- Prefix new issue-specific SQL scripts with the `CIID-XXXX` reference for this issue when one is known (ask the user for it if only a GitHub issue number was given and a `CIID-XXXX` reference is expected by team convention); fall back to `GH-<issue-number>` only if no `CIID-XXXX` reference exists for the work.
- Follow the existing filename style used in the target folder — `generate.database/Scripts/` uses `Title Case With Spaces.sql`; `generate.database/VersionUpdates/<version>/` subfolders use `Schema.ObjectName.ObjectType.sql` (e.g. `RDS.Get_CountSQL.UserDefinedFunction.sql`) for canonical object definitions rather than one-off issue scripts. Place a new one-off issue script under `generate.database/Scripts/`; place a versioned schema/object change under the current `generate.database/VersionUpdates/<version>/` folder using its existing sub-structure (`Functions/Create`, `StoredProcedures/Create`, `Tables/Create`, `Views/Create`, `Indexes`, `Metadata`, etc.).
- Do not rename existing SQL scripts solely to adopt this convention unless the issue explicitly requires those renames.
- If one issue needs multiple SQL scripts, use the same reference prefix with a distinct descriptive suffix for each file.

**Test/shared database mechanism — unconfirmed, do not invent one.** Unlike the source skill this was adapted from (which assumed a VPN-gated shared test database reachable via an `E2E_SQL_CONNECTION_STRING` env var in a `.env` file), this repo has:
- No `.env` file found at the repo root or in `generate.web/`.
- Connection strings configured through `generate.web/Config/appsettings.*.json` (`Data:AppDbContextConnection`, `Data:ODSDbContextConnection`, `Data:StagingDbContextConnection`, `Data:RDSDbContextConnection`), overridable via environment variables in `generate.web/docker-compose.yml`.
- `generate.test` uses EFCore InMemory/Sqlite for data tests rather than a real shared database, per its test project structure.

**Do not claim to apply or verify SQL against a shared/VPN-gated test database unless you have confirmed such a mechanism exists and have working credentials for it.** If a GitHub issue requires running SQL against a real database to verify the fix, ask the user how to connect (local `docker-compose` instance in `generate.web/`, a personal dev database, or some other environment) rather than assuming the Jira-skill's original VPN/`E2E_SQL_CONNECTION_STRING` workflow applies here. If no verification database is available, note that in the implementation comment (Step "Comment on Each GitHub Issue") instead of claiming the database change was verified.

#### For Bugs

1. Reproduce the issue by tracing the code path
2. Identify the root cause
3. Fix the root cause (not just the symptom)
4. Verify adjacent code isn't also affected
5. **Write a regression test** — after fixing the bug, evaluate whether a unit test should be added to prevent this defect from recurring. Add a regression test when:
   - The bug was caused by incorrect logic, bad conditional checks, off-by-one errors, null/undefined handling, or incorrect data transformations — these are highly testable and prone to regression
   - The fix touches a service, utility, pipe, or component method with clear inputs and outputs
   - An existing spec/test file covers the same component/service (add a new test case to it)
   - The defect could plausibly recur if someone refactors nearby code without understanding the edge case

   **Do NOT add a regression test when:**
   - The bug was purely a template/HTML issue (e.g., wrong CSS class, incorrect label text) with no logic component
   - The fix is a one-line configuration or wiring change (e.g., adding a missing import, fixing a route path typo)
   - The component/service has no existing spec/test file and creating one from scratch would be disproportionate to the fix (a simple 2-line fix doesn't warrant a 50-line new test file)
   - The bug was in SQL or stored procedures that cannot be unit tested in the current test infrastructure

   **Regression test guidelines:**
   - Name the test descriptively referencing the defect, including the `CIID-XXXX` reference and/or GitHub issue number in the test name or a comment so future developers understand why the test exists (e.g., an xUnit `[Fact]` named `ShouldHandleNullValueWhenCalculatingTotals_CIID8438Regression`, or a `describe`/`it` block referencing the same)
   - Test the specific edge case or input that triggered the bug — not just the happy path
   - Place the test in the existing spec/test file for the affected component/service — for backend controllers, that's the matching `<X>ControllerShould.cs` file under `generate.test/Web/Tests/Controllers/Api/**`; only create a new file if none exists and the component/service is complex enough to warrant one
   - For frontend tests, follow this repo's Angular/Jasmine-Karma-via-`ng test` conventions (`describe`/`it`/`expect`); for backend tests, follow xUnit conventions with Moq

#### For Features / Stories

1. Map acceptance criteria to specific files and components
2. Implement each criterion in turn
3. Reuse existing patterns (services, repositories, shared components)
4. Check for shared UI components in `generate.web/ClientApp/src/app/shared` before creating new ones

#### Build Verification

Run the relevant build **once after all changes** (or after each issue if they are large and independent):

```bash
cd generate.web/ClientApp
npm run build
```

For backend changes, run:

```bash
dotnet build generate.sln
```

Fix TypeScript, template, C#, or analyzer errors before proceeding.

#### Test Verification

After the build passes, run relevant unit tests **before committing**. Which tests to run depends on what was changed:

**If frontend (Angular) files were changed:**

```bash
cd generate.web/ClientApp
npm test
```

(equivalent to `ng test --watch=false`). If the full suite is too large or slow, scope to a pattern supported by your Angular test runner configuration.

**If backend (.NET) files were changed:**

```bash
dotnet test generate.test/generate.test.csproj
```

If the full test suite is large, target tests related to the changed area:

```bash
dotnet test generate.test/generate.test.csproj --filter "FullyQualifiedName~RelevantTestName"
```

**If both frontend and backend files were changed**, run both test suites.

**Test failure handling:**
- If tests fail, analyze the failures to determine whether they are caused by your changes or are pre-existing
- Fix any test failures **caused by your changes** before committing — this includes updating existing tests that need to reflect new behavior and writing new tests if the changes introduce testable logic not covered by existing tests
- If failures are clearly pre-existing (unrelated to changed files/features), note them in the GitHub comment but proceed with the commit
- Do **not** commit code that breaks tests related to the changes being made

**Regression tests for bug fixes:**
- If any issue being addressed is a bug, ensure you have added a regression test (per the "For Bugs" guidelines above) **before** running the test suite
- The regression test must pass along with all other existing tests before committing
- If you determined a regression test is not appropriate for a particular bug (see the "Do NOT add" criteria), note the reason in the GitHub comment

#### Code Review (`reviewing-code` Skill)

Before committing, spawn a fresh review pass using the **`reviewing-code`** skill for all changes made during implementation. Invoke it with the `Skill` tool (`skill: "reviewing-code"`), passing the review scope and issue context in the prompt/args. Include the list of files changed across all issues.

**Prompt template:**
```
Run a focused review-and-fix loop for the code changes made to address the following GitHub issue(s): {issue numbers} ({CIID-XXXX reference(s) if known}).

Scope the review to these files that were added or modified:

{list all files changed during implementation, one per line}

Review only the files listed above unless a changed file clearly requires an adjacent file for context.

After the review completes, report back the final addressed findings, deferred findings, and verification summary.
```

**Important:**
- Wait for the `reviewing-code` loop to complete before committing.
- If the `reviewing-code` run applied fixes, re-run the relevant build and tests to verify everything still passes before proceeding.
- Include a brief mention of the review results in the GitHub comment (e.g., "Code review completed — N findings addressed, M deferred").
- If `reviewing-code` reports Critical or High severity findings that were **not addressed** and not explicitly deferred, pause and inform the user before committing — these may need manual intervention.

---

#### Committing the Changes

This repo's commit convention is `CIID-XXXX : <description>` (colon-separated, confirmed from real history, e.g. `CIID-8438 : Fix an issue with membership migration`). Include the GitHub issue number alongside it when a `CIID-XXXX` reference is available; use the GitHub issue number alone if no `CIID-XXXX` reference exists for this work.

**If issues are independent** — one commit per issue, each referencing its own reference(s):

```bash
git add <files for issue #123 / CIID-8438>
git commit -m "CIID-8438 : <short description of what was done> (#123)"

git add <files for issue #124>
git commit -m "#124 : <short description of what was done>"
```

**If issues are related / share files** — one combined commit referencing all references:

```bash
git add <all changed files>
git commit -m "CIID-8438, CIID-9013 : <short description covering all changes> (#123, #124)"
```

#### Comment on Each GitHub Issue

After committing, add a comment to **each** GitHub issue using `gh issue comment <number> --body "..."`. The comment should describe what was changed, which files were modified, and include a time savings line.

To calculate the time Claude took: note the wall-clock time from when you started fetching the issues to when the final commit was made. Divide proportionally among issues or report the total time on each.

```
Implemented fix for this issue.

**Changes made:**
- `path/to/file.ts` — description of what changed
- `path/to/other.cs` — description of what changed

<If this was a bug and a regression test was added:>
**Regression test added:**
- `path/to/file_test` — added test: "should handle <edge case> (<CIID-XXXX or #issue> regression)"

<If this was a bug and NO regression test was added, explain why:>
**Regression test:** Not added — <reason, e.g., "fix was a template-only change with no testable logic">

Build verified passing.
Unit tests verified passing. <or note any pre-existing failures>

**Claude time savings:** Claude addressed this issue in approximately <N> minutes (issue analysis, codebase exploration, implementation, build verification, test verification, and commit). Estimated human development time for this task was **<human estimate>**, saving roughly **<difference>** of developer time.
```

#### Post-Failure Root Cause Analysis (Previously Rejected Issues Only)

If any issue showed evidence of a previously rejected implementation when fetched in Step 2 (e.g., a QA-failed/review-failed label, or comments describing a rejected attempt), perform a root cause analysis of why the prior implementation was insufficient and add it as a **separate comment** to the GitHub issue (in addition to the standard implementation comment above).

**Analysis process:**

1. Review the original issue body and acceptance criteria
2. Review the comments describing why the prior change was rejected
3. Review the prior implementation (via git log/diff if available, or infer from the failure feedback)
4. Compare what was originally asked for vs. what was delivered vs. what was actually needed
5. Categorize the root cause into one or more of these categories:

| Category | Description | Example |
|----------|-------------|---------|
| **Unclear requirements** | The issue body was ambiguous, incomplete, or missing acceptance criteria that would have prevented the mistake | "Body said 'fix the date display' but didn't specify the expected format or timezone handling" |
| **Incomplete requirements** | The body covered the main case but omitted edge cases, error states, or secondary scenarios that the fix needed to handle | "Requirements covered the happy path but didn't mention behavior when the field is null or empty" |
| **Missed implementation detail** | The requirements were clear but the prior implementation overlooked something — a code path, a condition, a file, or a side effect | "The fix updated the service method but missed the same logic duplicated in the bulk-update handler" |
| **Regression introduced** | The prior fix was correct for the reported issue but introduced a new defect in adjacent or related functionality | "Fixing the date format broke the sort order in the table because the sort comparator depended on the old format" |
| **Misunderstood context** | The prior implementation misinterpreted the business logic, user workflow, or domain terminology | "Interpreted 'active sources' as sources with status=Active, but the business meaning includes sources in Pending Review status" |
| **Testing gap** | The prior change passed the build but lacked adequate test coverage for the specific scenario that failed | "No unit test covered the case where the input array was empty, which is what triggered the bug in QA" |

**Comment format:**

Post this as a **separate comment** (not combined with the implementation comment) using `gh issue comment <number> --body "..."`:

```
**Root cause analysis — why was the prior implementation rejected?**

**Category:** <one or more categories from the table above>

**Analysis:**
<2-4 sentences explaining what went wrong with the prior implementation and why. Be specific — reference the actual failure feedback from comments and the concrete gap in the prior change.>

**What was different this time:**
<1-2 sentences explaining what the corrective implementation did differently to address the root cause.>

**Preventive takeaway:**
<1 sentence suggesting what could prevent this class of failure in the future — e.g., "Issue descriptions for date-related fixes should specify the expected format and timezone" or "Changes to shared service methods should check for duplicate logic in bulk-update handlers.">
```

**Important:** This analysis should be honest and constructive — not blame-oriented. The goal is to identify process improvements (better issue writing, better implementation patterns, better test coverage) that reduce future failures.

#### Update Lessons Learned Reference (Previously Rejected Issues Only)

After posting the root cause analysis comment, evaluate whether the **Preventive takeaway** contains actionable, generalizable guidance that could prevent similar failures in future implementations. If so, update `docs/lessons-learned.md`.

**Criteria for adding a lesson** — add the takeaway if it:
- Describes a **pattern** that applies beyond this single issue (e.g., "always check which tab a section belongs to" vs. "issue #952 needed the Budget tab")
- Provides **actionable guidance** that can be applied during implementation (not just "be more careful")
- Is **not already captured** by an existing entry in the document (check for duplicates first)

**Do NOT add** a lesson if:
- The takeaway is too specific to be useful for other issues (e.g., "the dropdown needed option X")
- The issue was caused by a one-time data or environment problem
- An existing entry already covers the same pattern (update the existing entry instead if the new takeaway adds nuance)

**Update process:**

1. Read the existing `docs/lessons-learned.md` file. If it doesn't exist, create it using the template below.
2. Check whether an existing entry already covers this pattern. If so, update that entry with any additional nuance rather than adding a duplicate.
3. Add a new entry under the appropriate category heading. If no category matches, add it under the closest fit.
4. Each entry should include:
   - The issue reference(s) (`CIID-XXXX` and/or GitHub issue number) and date for traceability
   - A concise, actionable lesson (1-2 sentences)
   - The category from the root cause analysis

**Template** (if `docs/lessons-learned.md` does not exist):

```markdown
# Lessons Learned from Failed Implementations

Actionable takeaways from root cause analyses of failed/rejected GitHub issues. These lessons are reviewed before each implementation to avoid repeating past mistakes.

## Misunderstood Context

<!-- Lessons about misinterpreting business logic, domain terminology, or user workflows -->

## Incomplete Requirements

<!-- Lessons about missing edge cases, unstated assumptions, or omitted scenarios -->

## Unclear Requirements

<!-- Lessons about ambiguous descriptions that led to wrong implementations -->

## Missed Implementation Detail

<!-- Lessons about overlooked code paths, files, or side effects -->

## Regression Introduced

<!-- Lessons about fixes that broke adjacent functionality -->

## Testing Gap

<!-- Lessons about insufficient test coverage that missed defects -->
```

---

#### Record Time Savings to Tracking File

After commenting on the GitHub issues, update the time savings tracking file at `docs/time-savings.md`.

For **each** issue addressed:

1. Read the existing `docs/time-savings.md` file. If it doesn't exist, create it using the template below.
2. Add a new row to the markdown table for each issue with:
   - **Date** — today's date in `YYYY-MM-DD` format
   - **Issue** — the issue reference (e.g., `CIID-8438 (#123)`, or just `#123` if no `CIID-XXXX` reference applies)
   - **Summary** — brief summary of the issue (truncated to ~40 chars if needed)
   - **Human Est.** — the estimated human development time (from Step 4a), in hours (e.g., `4h`)
   - **Claude Time** — the actual wall-clock time Claude took, in minutes (e.g., `12m`)
   - **Time Saved** — the difference between human estimate and Claude time, in hours (e.g., `~3.8h`)
3. Recalculate and update the **totals** at the bottom of the file by summing all rows.
4. Recalculate the **Performance gain** and **Interpretation** lines:
   - **Performance gain** — total estimated human time ÷ total actual Claude time, rounded to one decimal place, expressed as a multiplier (e.g., `14.8x`)
   - **Interpretation** — plain-English sentence: `Work that would take a human developer {human time} was completed in {Claude time}`

**Time conversion rules** for totals:
- `30m` = 0.5h, `1h` = 1h, `4h` = 4h, `1d` = 8h, `2d` = 16h, `1w` = 40h
- Claude time in minutes → divide by 60 for hours (e.g., 15m = 0.25h)
- Round totals to one decimal place
- Performance gain = Total estimated human time ÷ Total actual Claude time (e.g., 37h ÷ 2.5h = 14.8x)

**Template** (if `docs/time-savings.md` does not exist):

```markdown
# Claude Time Savings Tracker

Tracks development time saved by using Claude to address GitHub issues.

| Date | Issue | Summary | Human Est. | Claude Time | Time Saved |
|------------|-----------|------------------------------------------|------------|-------------|------------|

---

- **Total issues addressed:** 0
- **Total estimated human time:** 0h
- **Total actual Claude time:** 0h
- **Total time saved:** 0h
- **Performance gain:** 0x
- **Interpretation:** Work that would take a human developer 0 hours was completed in 0 hours
```

#### Commit Time Savings Update with a Descriptive Subject

After the time savings file has been fully updated with all changes (new rows added and totals recalculated), commit it as a separate housekeeping commit. This repository has no confirmed `.github/workflows/*` GitHub Actions automation as of this writing (the `.github/workflows` directory exists but is empty), so there is no confirmed deployment-run-naming behavior to design around — unlike the source Jira skill's assumption that GitHub Actions surfaces the most recent commit subject in a deployment run name. Regardless, keep the final commit subject descriptive: it should still include the relevant issue reference(s) and a concise summary of the actual implementation, since commit subjects are read by humans in `git log` and PR history either way.

Use this format:

```text
<CIID reference(s) and/or issue number(s)> - <implementation summary> (time savings)
```

Examples:

```bash
git add docs/time-savings.md
git commit -m "CIID-8438 (#123) - Fix membership migration issue (time savings)"

git add docs/time-savings.md
git commit -m "CIID-8438, CIID-9013 (#123, #124) - Update reporting and migration workflows (time savings)"
```

Commit-message requirements:

- Include every issue reference (`CIID-XXXX` and/or GitHub issue number) represented by the newly added tracker rows.
- Describe the product, content, or behavior changed—not merely the bookkeeping update. Reuse or shorten the implementation commit summary when practical.
- Never use a generic standalone subject such as `Update time savings tracker`.

This keeps the time savings tracking separate from the implementation commit(s) while ensuring the final commit still communicates what is being changed.

#### Label Each Issue for Code Review

After commenting, update **each** issue's status label (in parallel) if this repo's label-based status convention is in use (see the Labels note in the "Issue Tracker" section above):

1. Confirm via `gh label list` whether an appropriate label exists (e.g. `code-review`, `in-review`). Create one with `gh label create` if it doesn't exist and the repo's conventions support adding it.
2. Apply it and remove the in-progress label: `gh issue edit <number> --add-label "code-review" --remove-label "in-progress"`.

If no such label exists and creating one isn't appropriate, skip this step and note in your summary to the user that status wasn't tracked via a label for this issue — the GitHub comment (previous step) still records the implementation status.

---

## Edge Cases & Troubleshooting

### Issue Shows a Previously Rejected Attempt
If an issue has evidence of a previously rejected implementation (a failure-indicating label, or comments describing a rejected attempt):
- The previous implementation was attempted but rejected — do **not** treat this as a fresh implementation of the body
- Read the comments immediately and thoroughly — the failure reason is almost always in the most recent comment(s)
- Identify exactly what was wrong: incorrect behavior, missing cases, wrong files changed, etc.
- Fix only the specific problem identified in the comments; do not re-implement unrelated parts
- In your GitHub comment after the fix, explicitly reference what failed and how you addressed it
- **After committing and posting the implementation comment**, perform a root cause analysis and post it as a separate comment (see "Post-Failure Root Cause Analysis" in the workflow above)

### Issue Not Found
If a GitHub issue cannot be fetched, verify:
- The issue number is correctly formatted (a bare or `#`-prefixed number)
- `gh` is installed and authenticated (`gh auth status`)
- The issue exists in `CEDS-Collaborative-Exchange/Generate`

If one issue in a batch cannot be fetched, continue with the rest and note the failure.

### Build Failures After Implementation
If `npm run build` (from `generate.web/ClientApp`) or `dotnet build generate.sln` fails:
- Fix all TypeScript, template, C#, or analyzer errors
- Re-run the build until it passes cleanly

### Test Failures After Implementation
If unit tests fail after your changes:
- Determine whether the failures are caused by your changes or are pre-existing
- **Failures caused by your changes**: fix them before committing — update tests to reflect new behavior, or fix the implementation if the test expectation is correct
- **Pre-existing failures** (unrelated to your changes): note them in the GitHub comment but do not block the commit on them
- If you are unsure whether a failure is pre-existing, `git stash` the changes and run the tests again to compare

### Large or Complex Issues
For issues that span many files or require significant architectural changes:
1. Design the approach before editing
2. Present the plan to the user for approval
3. Implement in logical phases, committing after each phase

---

## Examples

### Example 1: User provides a single issue number

> "Address #123 (CIID-8438)"

1. Fetch issue #123 details from GitHub (`gh issue view 123 --comments`) and check its milestone status per the soft gate above
2. Summarize the issue to the user
3. Validate body against `docs/writing-issues-for-ai.md` guidelines (if file exists) — if significant issues found, comment and stop
4. Estimate human effort, then label #123 **in-progress** if the label exists
5. Implement changes on the current branch
6. Build and verify passing (`npm run build` in `generate.web/ClientApp` for frontend; `dotnet build generate.sln` for backend)
7. Run relevant unit tests (`npm test` frontend; `dotnet test generate.test/generate.test.csproj` backend) and verify passing
8. Invoke the `reviewing-code` skill to review all changed files — fix eligible findings, re-verify build and tests
9. Commit referencing `CIID-8438` and `#123`
10. Add a comment to #123 describing the changes made, including a Claude time savings line
11. Update and separately commit `docs/time-savings.md` using a descriptive subject such as `CIID-8438 (#123) - Fix membership migration issue (time savings)`
12. Label #123 **code-review** if the label exists

### Example 2: User provides multiple issue numbers

> "Address #123 #124 #130"

1. Fetch #123, #124, #130 details from GitHub **in parallel**
2. Check milestone status per the soft gate; notify the user and skip any confirmed-ineligible issues only if this repo is confirmed to enforce the gate
3. Summarize all eligible issues to the user
4. Validate each eligible body against `docs/writing-issues-for-ai.md` guidelines — comment and skip any that fail
5. Estimate effort for passing issues; label **in-progress** in parallel where the label exists
6. Assess whether issues are related or independent
7. Implement changes for all issues; build once (or per-issue if large)
8. Run relevant unit tests and verify passing
9. Invoke the `reviewing-code` skill to review all changed files — fix eligible findings, re-verify build and tests
10. Commit — one commit per issue if independent, or one combined commit if related
11. Add a comment to **each** issue describing what was changed
12. Update and separately commit `docs/time-savings.md`; the final subject must include all addressed issue references and summarize the implementation, for example `CIID-8438, CIID-9013 (#123, #124) - Update migration and reporting workflows (time savings)`
13. Label all passing issues **code-review** in parallel where the label exists

### Example 3: User provides no issue number

> "/managing-issue"

1. Ask: "Which GitHub issue(s) would you like to address? Please provide one or more issue numbers (e.g., #123 #124)."
2. User responds: "#123 #124"
3. Continue with steps above

---

## When NOT to Use This Skill

- When only fetching or reading a GitHub issue for information, not implementation
- When creating a GitHub issue from meeting notes or other source material
- When triaging a bug to check for duplicates rather than implementing a fix

---

## Quick Reference

| Step | Action | Key Tool / Command |
|------|--------|--------------------|
| 1 | Get issue number(s) | Ask user if not provided; parse space/comma-separated list |
| 2 | Fetch issue details and check milestone gate | `gh issue view <number> --comments` — **in parallel**; milestone gate is soft/unconfirmed in this repo (verify with `gh api repos/CEDS-Collaborative-Exchange/Generate/milestones`), then run the initial defect/enhancement split check and treat prior-rejection signals as primary requirements |
| 3 | Validate issue quality against guidelines | Read `docs/writing-issues-for-ai.md` (does not currently exist); comment and skip issues that fail validation if it does |
| 4 | Estimate effort + label all in-progress | Estimate stays local (no GitHub time-tracking field); `gh issue edit <number> --add-label "in-progress"` — **in parallel**, only if the label exists/should exist |
| 5 | Implement all issues + build | `npm run build` in `generate.web/ClientApp` (frontend); `dotnet build generate.sln` (backend) |
| 5b | Add regression tests for bugs | Add test to existing spec/test file targeting the defect's edge case (skip if not appropriate) |
| 5c | Create required DB scripts | Name new issue SQL scripts with the `CIID-XXXX` reference following the real precedent in `generate.database/Scripts/CIID-6030 INS Script.sql`; place versioned schema changes under `generate.database/VersionUpdates/<version>/`. Do not claim to apply/verify against a shared test database — no such mechanism is confirmed in this repo |
| 6 | Run relevant unit tests | `npm test` from `generate.web/ClientApp` (frontend) and/or `dotnet test generate.test/generate.test.csproj` (backend) — including new regression tests — fix failures before committing |
| 7 | Code review via `reviewing-code` | Invoke the `reviewing-code` skill on changed files — re-verify build and tests after fixes |
| 8 | Commit | One commit per issue (independent) or one combined commit (related), formatted `CIID-XXXX : <description> (#issue)` |
| 9 | Comment on each issue | `gh issue comment <number> --body "..."` — one comment per issue |
| 9b | Root cause analysis (previously rejected only) | `gh issue comment <number> --body "..."` — separate comment analyzing why prior implementation was rejected |
| 9c | Update lessons learned (previously rejected only) | Append actionable takeaway to `docs/lessons-learned.md` if generalizable |
| 10 | Record time savings | Append row(s) to `docs/time-savings.md` and recalculate totals |
| 10b | Commit time savings update | `git add docs/time-savings.md` → `git commit -m "<issue reference(s)> - <implementation summary> (time savings)"` (separate commit with a descriptive subject) |
| 11 | Label each issue for code review | `gh issue edit <number> --add-label "code-review" --remove-label "in-progress"` — **in parallel**, only if the labels exist/should exist |

**Remember:**
- Work on the currently checked-out branch — do not create a new branch
- Fetch issues in parallel whenever possible
- The milestone gate is soft/unconfirmed for this repo — verify actual milestone usage before treating it as a hard blocker
- Name new issue-referenced SQL scripts using the `CIID-XXXX` reference, following the real precedent `generate.database/Scripts/CIID-6030 INS Script.sql`
- Build must pass before committing
- Relevant unit tests must pass before committing — run frontend tests (`npm test` in `generate.web/ClientApp`) if Angular files changed, backend tests (`dotnet test generate.test/generate.test.csproj`) if .NET files changed
- Do not claim a shared/VPN-gated test database update was verified unless such a mechanism is confirmed and was actually used — this repo has no confirmed equivalent to that infrastructure
- Commit messages must reference the relevant issue reference(s) (`CIID-XXXX` and/or GitHub issue number)
- Status labels (`in-progress`, `code-review`) are not confirmed to exist in this repo — check `gh label list` before relying on them, and skip label updates gracefully if absent
- Add a comment to **every** issue that was addressed
- For previously-rejected issues: post a **separate** root cause analysis comment after the implementation comment
