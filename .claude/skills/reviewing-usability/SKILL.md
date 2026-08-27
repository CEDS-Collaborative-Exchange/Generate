---
name: reviewing-usability
description: Perform repository-grounded usability code reviews and produce a prioritized list of concrete usability issues or concerns with file and line references. Use when the user asks for a usability review, UX review, task-flow review, form UX review, navigation review, workflow friction review, onboarding review, error-handling review, feedback-state review, or user-efficiency assessment for this Generate Angular and ASP.NET Core codebase — CIID's EDFacts/IDEA special-education reporting tool used by State Education Agency (SEA) data-management staff to standardize data and submit EDFacts/SPP-APR reports — including its report generation, data migration, toggle/metadata configuration, and file upload/download workflows.
---

# Reviewing Usability

Review the code that exists before making claims. Prefer concrete task-friction problems over generic UX advice.

## Generate Stack Focus

Tailor the review to this repository's stack and layout. Generate is a data-heavy internal tool for SEA data-management staff working through complex reporting and data-quality workflows, not a consumer app — weigh task completion, correctness confidence, and recovery from mistakes over visual polish.

- Frontend: Angular 20.3.x SPA in `generate.web/ClientApp`. The UI mixes eras: legacy Material Design Lite (`mdl-*` classes) grids and buttons on older screens, Angular Material (`mat-dialog`, `mat-paginator`, `mat-list`, `mat-progress-bar`, `mat-raised-button`) on newer ones, `@angular/flex-layout` (`fxLayout`/`fxFlex`) for dialog layout, FontAwesome icons, and `@generic-ui/ngx-grid` (`gui-grid`)/pivottable for data-grid and pivot-table screens. Forms mix template-driven patterns (raw `#ref` DOM element access, e.g. `settings/toggle/toggle-assessment.component.html`) with reactive forms — there is no single canonical form pattern to check against, so call out inconsistency between screens rather than assuming one convention is "correct."
- Shared UX infrastructure: `app.component.ts`/`app.component.html` (global shell: `app-app-drawer`, `generate-app-header`, `generate-app-footer`, a skip-to-content link, `router-outlet`), `app.module.ts`, `app-routing.module.ts` with `LoginGuard`, `AdminGuard`, and `ConfirmationGuard` (an unsaved-changes `canDeactivate` guard backed by a confirmation dialog), `shared/interceptors/HttpConfigInterceptor.ts`, `shared/components/dialog/` (the `generate-app-dialog` wrapper), `shared/components/upload/` (a `mat-dialog` upload flow with per-file progress bars), `shared/components/breadcrumbs.component.*` and `pagetitle.component.*`, `shared/components/app-drawer/` (primary navigation), `shared/components/combo-box/`, `autocomplete/`, `datepicker/`, `flextable/`, `pivottable/`, `report-library-table/`, and the `services/app/*.service.ts` / `services/ods/*.service.ts` / `services/base.service.ts` API wrappers.
- Feature hotspots: `reports/` (`edfacts/`, `sppapr/`, `summary/`, `library/` — report generation, filtering, and download flows), `settings/datastore/` (staging/ODS/RDS data-migration workflows with long-running progress, cancel, and confirmation dialogs), `settings/toggle/` (assessment/question/section toggle configuration — filterable, sortable tables with add/edit/delete dialogs), `settings/metadata/`, `settings/update/` (application update flow), `resources/tutorials/`, `home/`, and `about/`.
- Backend: ASP.NET Core (.NET 10) in `generate.web`. `Controllers/Api/App/*.cs` (report generation, file submission/download, data migration, toggle configuration, CEDS connection) and `Controllers/Api/ODS/*.cs` are mostly JSON endpoints, but still shape usability through validation responses, defaults, sorting/filtering behavior, user-facing errors, and generated file downloads — for example `FileSubmissionController.Get` streams CSV/fixed-width export files directly to the HTTP response with no try/catch or user-facing error path if generation fails partway through. `Controllers/Web/AccountController.cs` and `ErrorController.cs`, plus the Razor views under `Views/App`, `Views/Error`, and `Views/Shared`, shape login and error-page UX.

## Workflow

1. Identify the core user tasks, decision points, and feedback states before diving into files.
2. Read only the files needed to trace what users must understand and do: Angular templates, component classes, shared services, route structure, and backend code that shapes user-visible messages or workflow outcomes.
3. Use [references/usability-review-checklist.md](references/usability-review-checklist.md) as the default checklist. Use [references/generate-stack-usability.md](references/generate-stack-usability.md) for repo-specific hotspots and interpretation guidance.
4. For each suspected issue, confirm the user task, the code path that creates the friction, and the practical impact on completion, clarity, recovery, or confidence. Do not report speculative findings that lack a plausible user-facing failure or confusion path.
5. Spend most time on blockers or slowdowns in common form flows, navigation, data-entry, review and submit flows, dialogs, table actions, uploads, downloads, and error recovery.

## Finding Standard

Only report a finding when all of these are true:

- The usability problem is present in code, markup, workflow logic, or configuration.
- A realistic user flow reaches it.
- The impact is meaningful and not purely theoretical.

When the evidence is incomplete, say so explicitly and label it as an assumption or open question instead of a confirmed finding.

## Priority Rubric

Sort findings from highest to lowest priority:

- `Critical`: Core workflow is effectively blocked, dangerously confusing, or likely to cause repeated user failure, such as save or submit flows with unclear outcomes, broken navigation through required steps, or error handling that prevents recovery in a key task.
- `High`: Major friction in a common workflow, such as confusing forms, weak validation feedback, unclear table or menu actions, hidden state changes, or dialog or upload flows that make routine work error-prone.
- `Medium`: Confirmed usability issue with narrower scope, stronger preconditions, or partial mitigation already present.
- `Low`: Local polish, consistency, labeling, or efficiency issue that matters less on its own but still affects ease of use over time.

Prefer fewer, higher-confidence findings over long speculative lists.

## What To Look For

- Forms that ask users to infer required fields, valid formats, next steps, or hidden dependencies instead of guiding them clearly.
- Validation, save, submit, and success flows that do not clearly tell users what happened, what failed, or what to do next.
- Dialog, modal, and confirmation patterns that hide consequences, bury destructive actions, or make recovery unclear.
- Route-driven workflows that strand users without context, progress cues, sensible back paths, or clear distinction between edit and view modes.
- Tables, menus, and row actions that require guesswork to understand what can be edited, sorted, downloaded, deleted, or reviewed.
- Upload and download flows that obscure file state, accepted formats, progress, replacement behavior, or completion status.
- Error handling that redirects users abruptly or surfaces raw server messages without enough task-specific guidance.
- Nested or oversized forms that create high cognitive load, duplicate data entry, or require users to remember information from previous screens.
- Notification and status patterns that rely on subtle UI changes instead of explicit, timely feedback.
- Inconsistent labels, terminology, route names, or action wording across related screens.
- Backend contracts that make the frontend harder to use, such as opaque field names, weak validation messages, or status values that users cannot interpret easily.

## Output Format

Return the review as Markdown.

Use Markdown structure intentionally so findings are easy to scan.

- Start with a short `## Findings` heading.
- Give each finding its own `### <Priority>: <Short Title>` heading.
- Put supporting fields on separate lines with bold labels such as `**Impact:**`, `**Evidence:**`, `**Change Risk:**`, `**Business Decision:**`, and `**Recommended Change:**`.
- Use inline code for literals, identifiers, routes, and file paths where helpful.
- Use Markdown horizontal rules between findings.
- Do not wrap the entire review in a fenced code block.

Lead with findings. Do not use Markdown tables by default. In this app, review tables often force horizontal scrolling and are harder to read than stacked finding blocks.

Present confirmed findings as a priority-sorted sequence of compact finding blocks. Give each finding its own short heading, then place the supporting fields on separate lines underneath it.

Separate findings with a Markdown horizontal rule `---` on its own line so each issue stands out clearly. Do not put a divider before the first finding; place one between findings only.

Never label user-facing findings as `P0`, `P1`, `P2`, or `P3`. Always use the human-readable priority words from the rubric: `Critical`, `High`, `Medium`, or `Low`.

Use this block shape for each finding:

- `### High: Save flow gives no recovery guidance`
- `**Impact:** Users are more likely to abandon or repeat the action after an error.`
- `**Evidence:** path/to/file:line, path/to/other-file:line`
- `**Change Risk:** Low`
- `**Business Decision:** No`
- `**Recommended Change:** Add explicit next-step guidance and align it with adjacent flows.`

Example:

## Findings

### High: Save flow gives no recovery guidance
**Impact:** Users are more likely to abandon or repeat the action after an error.
**Evidence:** path/to/file:line
**Change Risk:** Low
**Business Decision:** No
**Recommended Change:** Add explicit next-step guidance and align it with adjacent flows.

---

### Medium: Table action labels are ambiguous
**Impact:** Users must guess which action edits, reviews, or downloads the record.

Keep each field to one or two short sentences. Let text wrap naturally. If two evidence references are enough, prefer two over a longer list.

If multiple findings share context, add a short `## Notes` section after the findings. Insert a Markdown horizontal rule `---` before `## Notes` so it is clearly separated from the last finding. Only use a Markdown table when the user explicitly asks for one.

Always pair the recommended change with the change-risk level and business-decision flag. Treat change risk as the likelihood that implementing the fix will cause regressions, require broad coordination, or reshape shared behavior. Mark business decision as `Yes` when the best fix changes task flow, approval requirements, terminology, default behavior, or other UX tradeoffs that product owners or business stakeholders should explicitly choose.

If there are no confirmed findings, say that explicitly and mention residual risks or testing gaps.

## Review Notes

- Review both frontend and backend when both shape the user experience.
- Pay extra attention to shared dialogs, notifications, error handling, and file services because usability issues there fan out across many screens.
- If a clearer pattern already exists elsewhere in the repo, call out the inconsistency.
- Treat task completion, recovery, and confidence as more important than purely visual polish.
- Keep summaries short. Do not bury findings under an architecture overview.
