---
name: reviewing-code
description: Orchestrate a multi-dimensional repository code review using subagents and the repo's reviewing-* skills, consolidate and de-duplicate findings, address eligible issues through repeated review/fix iterations, run lint/format gates, and report addressed and deferred findings. Use when the user asks for a complete code review loop, multi-dimensional review, all-reviewer pass, or convergence workflow across accessibility, documentation, maintainability, performance, privacy, security, SEO, stability, and usability for this Generate (CIID EDFacts/IDEA reporting) Angular/ASP.NET Core repository.
---

# Reviewing Code

## Overview

Use this skill to run a full review-and-fix loop across the repository's specialized reviewing skills. This skill coordinates the review dimensions, consolidates the results, fixes eligible findings, repeats review passes until convergence, and reports what was addressed and what was deferred.

This skill is an orchestrator. The actual review findings must come from independent subagents using the specialized reviewing skills, not from a single combined review in the parent context.

This skill also owns lint/formatting gates for review completion. They are required verification, not optional examples, even though the repository does not currently wire them into a working CI pipeline (see step 1).

## Review Dimensions

For every iteration, start one independent subagent for each of these skills:

- `reviewing-accessibility`
- `reviewing-documentation`
- `reviewing-maintainability`
- `reviewing-performance`
- `reviewing-privacy`
- `reviewing-security`
- `reviewing-seo`
- `reviewing-stability`
- `reviewing-usability`

Each subagent must review the same current worktree and scope. Subagents should return findings only; the parent agent is responsible for consolidation and fixes.

If the current environment does not expose the Agent tool (or an equivalent subagent/multi-agent capability), stop and tell the user this skill requires subagents. Do not substitute a single-context review, because independent reviewer perspectives are part of the skill's purpose.

## Workflow

1. Inspect the worktree.
   - Run `git status --short` before the first review pass.
   - Preserve user changes and do not revert unrelated work.
   - If the user supplied a scope, use it. Otherwise review the current repository worktree.
   - Determine which lint/format gates apply from the changed-file scope:
     - UI changes under `generate.web/ClientApp/`: run `npm run lint` (equivalently `ng lint`) from `generate.web/ClientApp`.
     - C#/.NET changes anywhere under `generate.web/`, `generate.core/`, `generate.infrastructure/`, `generate.console/`, or `generate.test/`: run `dotnet format generate.sln --verify-no-changes --no-restore --verbosity minimal` from the repo root, after restore/build has made dependencies available.
   - Neither gate is currently wired into a working CI pipeline in this repository (`bitbucket-pipelines.yml` is an unused commented-out stub, and there are no `.github/workflows/*` files). Run them anyway as this skill's own quality gate — they are good practice regardless of CI, not a claim that they mirror an existing pipeline job.

2. Start the review iteration.
   - Track the iteration number, starting at 1.
   - Capture a baseline of known findings from prior iterations, including whether each finding was addressed, deferred, persistent, or regressed.

3. Spawn reviewers in parallel.
   - Use one subagent per review dimension, launched via the Agent tool (e.g. `subagent_type: "general-purpose"` or `"Explore"` for read-only passes).
   - In each subagent's prompt, tell it to invoke the Skill tool for that dimension's skill (e.g. `skill: "reviewing-security"`) and follow its guidance to review the current worktree.
   - Tell each subagent not to edit files.
   - Ask each subagent to return only concrete findings with file and line references where applicable, following that reviewing skill's normal report format.

   Example subagent prompt shape:

   ```text
   Invoke the Skill tool with skill: "reviewing-security", then follow its guidance to review the
   current worktree for concrete security findings only. Do not edit files. Return prioritized
   findings with file and line references, impact, and recommended remediation. If there are no
   findings, say so clearly.
   ```

4. Consolidate findings.
   - Normalize every finding into: dimension, severity, title, evidence, impact, recommended change, change risk, business-decision status, and fingerprint.
   - Normalize severities to `Critical`, `High`, `Medium`, or `Low`. If a reviewer uses P0-P3, map P0 to Critical, P1 to High, P2 to Medium, and P3 to Low.
   - De-duplicate findings that share the same root cause, evidence location, or required fix. Merge all contributing dimensions onto the consolidated finding and keep the highest severity.
   - Preserve specialized context from individual reviewers, such as privacy exposure path, security exploit path, accessibility user impact, or stability reproduction details.

5. Classify each consolidated finding.
   - Defer any finding whose fix is high-risk, requires a database schema change, or requires a business decision.
   - For iteration 1, address all non-deferred findings.
   - For iteration 2, address all non-deferred findings except `Low` severity findings.
   - For iteration 3, address all non-deferred findings except `Medium` and `Low` severity findings.
   - For iteration 4 or higher, address only regressed non-deferred findings. Defer newly found issues.

6. Fix eligible findings.
   - Make narrow, repository-patterned edits for eligible findings only.
   - Prefer local fixes over broad refactors unless the finding cannot be fixed narrowly.
   - Do not fix deferred findings.
   - If fixing a finding would require a high-risk change, database schema change, or business decision, move it to deferred instead.
   - Run targeted verification after edits, such as unit tests, linting, build checks, or focused manual inspection.

7. Loop until convergence.
   - Repeat the review pass after fixes.
   - Stop when all reviewers report no remaining eligible issues to address.
   - Also stop when all remaining findings are deferred by the iteration rules or deferral rules.
   - If an iteration produces no eligible fixes and no edits were made, stop and explain why the remaining findings are deferred.

8. Run required lint/format gates before finalizing.
   - Run every applicable lint/format command identified in step 1 after the final edit set.
   - These commands are mandatory even when builds and targeted tests pass.
   - If lint/format fails because of the current change, fix the issue narrowly and rerun the affected gate.
   - If lint/format fails for a clearly pre-existing or unrelated reason, record the evidence and do not claim it passed.
   - Do not report review convergence as complete until applicable lint/format gates pass or are explicitly documented as unrelated/pre-existing failures.

## Deferral Rules

Always defer findings in these categories:

- High-risk changes: broad authentication or authorization redesign, public contract changes, production configuration changes, dependency upgrades with meaningful blast radius, large rewrites, or changes with unclear ownership.
- Database schema changes: table, column, key, stored procedure, migration, ETL schema, or backfill changes that alter persisted data shape or require coordinated deployment.
- Business decisions: changes to policy, reporting semantics, user-facing workflow, data retention, public content, compliance posture, or product behavior that need an owner decision.

For iteration 4 or higher, treat only these as addressable:

- A finding that was absent in an earlier iteration and appeared because of changes made during this loop.
- A finding that was previously addressed but reappeared in substantially the same location or root cause.
- A finding whose severity increased because of changes made during this loop.

Persistent pre-existing findings are not regressions. Newly discovered unrelated findings in iteration 4 or later must be deferred.

## Fix Discipline

When addressing findings:

- Keep edits scoped to the files and behavior required by the consolidated finding.
- Follow existing Angular, ASP.NET Core, EF Core/data-access, `generate.database` SQL script, and documentation patterns already present in the repository.
- Add or update tests when the change affects behavior, validation, security/privacy boundaries, data handling, accessibility behavior, or shared utilities.
- Re-run the most relevant verification after fixes, including the required lint/format gates for touched areas.
- Do not claim convergence until a post-fix review pass has run.

## Final Report

When the loop is complete, report both addressed and deferred findings. Include enough detail that the user can audit the loop without reading every subagent transcript.

Use this shape:

```markdown
## Summary
- Iterations completed: <n>
- Findings addressed: <count>
- Findings deferred: <count>
- Verification: <commands/checks run, including applicable lint/format gates>

## Addressed Findings
### <Severity>: <Title>
**Dimensions:** <reviewing skills that reported it>
**Evidence:** <file/line references>
**Change:** <what was changed>
**Verification:** <checks that covered it>

## Deferred Findings
### <Severity>: <Title>
**Dimensions:** <reviewing skills that reported it>
**Reason Deferred:** <high-risk | database schema change | business decision | iteration threshold | newly found after iteration 3>
**Evidence:** <file/line references>
**Recommended Next Step:** <owner decision or future work>

## Iterations
- Iteration 1: <review result and fix summary>
- Iteration 2: <review result and fix summary>
```

If no findings were addressed or no findings were deferred, say that explicitly.
