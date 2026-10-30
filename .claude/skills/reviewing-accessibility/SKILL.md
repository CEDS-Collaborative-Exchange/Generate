---
name: reviewing-accessibility
description: Perform repository-grounded accessibility code reviews of this Generate repo (CIID's EDFacts / IDEA special-education reporting tool for State Education Agencies) and produce a prioritized list of concrete accessibility issues or concerns with file and line references, covering the Angular 20 SPA (generate.web/ClientApp), its MatDialog-based shared dialogs (confirmation, ok, yes-no, upload), toast/snackbar notifications, routing and focus flows, settings/reports forms and dense report tables, file upload flows, and the ASP.NET Core (.NET) Razor shell and error pages that host it. Use when the user asks for an accessibility review, WCAG review, Section 508 review, screen-reader review, keyboard-navigation review, focus-management review, semantics or ARIA review, color-contrast review, form accessibility review, table accessibility review, modal or dialog accessibility review, or inclusive UX assessment for this codebase.
---

# Reviewing Accessibility

Review the code that exists before making claims. Prefer concrete, user-impacting accessibility defects over generic best-practice advice.

## Generate Stack Focus

Tailor the review to this repository's stack and layout:

- Frontend: Angular 20.3 in `generate.web/ClientApp`, mostly NgModule-based lazy routes (`app-routing.module.ts` plus per-feature `*-routing.module.ts`) with a handful of newer standalone components (e.g. `FlextableComponent`), legacy Material Design Lite (`mdl-*`) markup intermixed with Angular Material (`mat-*`) components and Angular Flex Layout (`fxLayout`/`fxFlex`), reactive forms, Angular Material `mat-table`/`MatSort`/`MatPaginator` and `@generic-ui/ngx-grid` (Fabric/Hermes) for dense report grids, MatDialog-based shared dialogs, and per-component toast/snackbar notification blocks.
- Shared UI infrastructure: `generate.web/ClientApp/src/app/app.component.*`, `app.module.ts`, `app-routing.module.ts`, `shared/guards/` (`admin.guard.ts`, `confirmation.guard.ts`, `login.guard.ts`), `shared/services/` under `services/{app,ods}/` and `services/base.service.ts`, `shared/components/` (including `dialog/`, `confirmationdialog.component.*`, `ok-dialog.component.*`, `yes-no-dialog.component.ts`, `upload/` and `upload/dialog/`, `report-library-table/`, `flextable/`, `autocomplete/`, `combo-box/`, `datepicker/`), and `shared/reportcontrols/` (many small report-filter components).
- Feature hotspots: the reactive-form-heavy survey/toggle screen in `settings/toggle/`, admin migration screens in `settings/datastore/` (`datastore`, `odsmigration`, `rdsmigration`), dense EDFacts/SPP-APR report tables and filters in `reports/` (`edfacts/`, `library/`, `sppapr/`, `summary/`), `resources/` (including `resources/tutorials/`), `about/`, and `home/`.
- Backend: ASP.NET Core on .NET 10 in `generate.web` (`Program.cs` top-level startup; `Controllers/Api/{App,ODS}/*.cs` JSON REST endpoints; `Controllers/Web/AccountController.cs` and `ErrorController.cs` MVC/Razor controllers; `Views/Shared/_Layout.cshtml`, `Views/App/Index.cshtml`, `Views/Error/Index.cshtml`) mostly serves the Angular SPA and JSON APIs, but still matters for user-facing error pages, auth flows (Azure AD/MSAL, JWT bearer, cookies), download/export file naming, and the server-rendered shell around the SPA.

## Workflow

1. Identify the relevant user flows, assistive-technology interactions, and UI surfaces before diving into files.
2. Read only the files needed to trace what users actually perceive: Angular templates, component classes, route guards, shared dialog and notification markup, Material Design Lite / Angular Material markup, reactive forms, and any backend code that shapes user-facing content.
3. Use [references/accessibility-review-checklist.md](references/accessibility-review-checklist.md) as the default checklist. Use [references/generate-stack-accessibility.md](references/generate-stack-accessibility.md) for repo-specific starting points and hotspots.
4. For each suspected issue, confirm the rendered interaction, the code path that produces it, the affected user group or assistive technology, and the practical impact. Do not report speculative findings that lack a plausible user-facing failure mode.
5. Spend most time on blockers for keyboard-only users, screen-reader users, low-vision users, and users navigating complex forms, dialogs, tables, or upload workflows.

## Finding Standard

Only report a finding when all of these are true:

- The inaccessible behavior is present in code, markup, or configuration.
- A realistic user flow reaches it.
- The impact is meaningful and not purely theoretical.

When evidence is incomplete, say so explicitly and label it as an assumption or open question instead of a confirmed finding.

## Priority Rubric

Sort findings from highest to lowest priority:

- `Critical`: Core workflow is unusable for affected users, such as keyboard traps, inaccessible authentication or navigation, unlabeled required form flows, or other defects that block task completion or violate a foundational accessibility requirement across broad surfaces.
- `High`: Major barrier in a common workflow, such as broken dialog focus handling, inaccessible tables or upload flows, missing accessible names on important controls, or route transitions that strand focus or context.
- `Medium`: Confirmed accessibility issue with narrower scope, stronger preconditions, or a partial mitigation already present.
- `Low`: Defense-in-depth improvement, localized semantics issue, or maintainability concern that matters less on its own but should still be corrected.

Prefer fewer, higher-confidence findings over long speculative lists.

## What To Look For

- Missing, misleading, or duplicated accessible names on buttons, icon-only controls, form fields, links, menus, and custom interactive elements.
- Custom focus manipulation that breaks expected Angular, Angular Material (CDK), or dialog behavior, including route changes that do not restore meaningful focus.
- Clickable non-semantic elements such as `div`, `td`, or other containers using `tabindex`, `role`, or click handlers instead of native interactive elements, and `href="#"` links wired up as buttons via `(click)`.
- Manually numbered `tabindex` values that are easy to leave stale when controls are added, removed, or reordered.
- Dialog, menu, tooltip, accordion, navigation, and wrapper-component flows that can open visually but are confusing or unusable with screen readers or keyboard navigation.
- Reactive-form and template markup that lacks labels, instructions, required-state signaling, error association, fieldset or legend structure, or accessible validation feedback.
- `mat-table`, `MatSort`/`MatPaginator`, `@generic-ui/ngx-grid` (Fabric/Hermes), and legacy MDL table/grid flows that hide headers, action context, row meaning, or sort state from assistive tech.
- Router transitions, landmarks, headings, and skip-to-content behavior that fail to orient users after navigation.
- Upload and attachment flows that depend on pointer use or visual context alone.
- Status, progress, validation, and notification (toast/snackbar) patterns that rely only on color, iconography, or visual placement without accessible text.
- Misused ARIA roles, `aria-hidden`, `tabindex`, or landmark attributes that override or conflict with native semantics — including `aria-hidden="true"` applied to a container that still holds real focusable/interactive content, and `aria-labelledby`/`aria-describedby` references pointing at an id that does not exist in the rendered DOM.
- Generated files, downloads, help documents, or server-produced messages whose metadata or structure can create inaccessible downstream experiences.

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

For normal user-facing reviews, do not emit `::code-comment` directives. The app surfaces them as separate finding cards, so they are not internal-only. Only emit `::code-comment` when the user explicitly wants inline review comments, line-specific callouts, or code annotations.

Use this block shape for each finding:

- `### High: Missing dialog focus trap`
- `**Impact:** Keyboard and screen-reader users can lose context in shared modal flows. Include WCAG or Section 508 framing only when it materially helps.`
- `**Evidence:** path/to/file:line, path/to/other-file:line`
- `**Change Risk:** Medium`
- `**Business Decision:** No`
- `**Recommended Change:** Restore the standard focus trap pattern used elsewhere in the repo.`

Example:

## Findings

### High: Missing dialog focus trap
**Impact:** Keyboard and screen-reader users can lose context in shared modal flows.
**Evidence:** path/to/file:line
**Change Risk:** Medium
**Business Decision:** No
**Recommended Change:** Restore the standard focus trap pattern used elsewhere in the repo.

---

### Medium: Error text is not associated to the field
**Impact:** Screen-reader users may not hear the validation failure in context.

Keep each field to one or two short sentences. Let text wrap naturally. If two evidence references are enough, prefer two over a longer list.

If multiple findings share context, add a short `## Notes` section after the findings. Insert a Markdown horizontal rule `---` before `## Notes` so it is clearly separated from the last finding. Only use a Markdown table when the user explicitly asks for one.

Always pair the recommended change with the change-risk level and business-decision flag. Treat change risk as the likelihood that implementing the fix will cause regressions, require broad coordination, or reshape shared behavior. Mark business decision as `Yes` when the best fix changes product policy, workflow requirements, accepted UX tradeoffs, public content strategy, or compliance posture instead of being a straightforward engineering correction.

If there are no confirmed findings, say that explicitly and mention residual risks or testing gaps.

## Review Notes

- Review both frontend and backend when both matter, but expect most confirmed findings in Angular templates, component logic, shared UI components, and route wrappers.
- Pay special attention to shared dialogs (`shared/components/dialog/`, `confirmationdialog`, `ok-dialog`, `yes-no-dialog`, `upload/dialog`), toast/snackbar notification blocks, the app shell (`app.component.html`, `app-header`, `app-drawer`, `app-footer`), the `settings/toggle` survey form, `reports/` tables, and the `shared/components/upload/` file-upload flow, because accessibility bugs there fan out across many screens.
- If a safer or more accessible pattern already exists elsewhere in the repo, call out the inconsistency — for example, `@angular/cdk/a11y`'s `LiveAnnouncer` is already used to announce table sort changes in `report-library-table` and `flextable`; treat that as the baseline other data tables should match.
- There is no automated accessibility check in this repo: linting runs through legacy TSLint plus Codelyzer (`tslint.json`), whose rules are code-style and type rules only, and `npm run lint` (`ng lint`) is not wired into any CI gate (`bitbucket-pipelines.yml` is an empty, commented-out stub and there are no `.github/workflows/*`). Do not claim or recommend fixes that assume a CI accessibility gate exists; treat every review as manual.
- Treat keyboard and screen-reader blockers as more important than cosmetic semantics issues.
- Keep summaries short. Do not bury findings under an architecture overview.
