# Accessibility Review Checklist

Use this checklist to guide a repository review, then spend most of the time on the highest-impact confirmed barriers.

## Triage First

- What user workflows are essential to complete the task?
- Which screens are form-heavy, modal-heavy, or table-heavy?
- Where can a keyboard, screen-reader, or low-vision failure block the whole journey?

## Generate Repo Sweep

- `generate.web/ClientApp/src/app/app.component.ts` and `app.component.html`
- `generate.web/ClientApp/src/app/app.module.ts`
- `generate.web/ClientApp/src/app/app-routing.module.ts`
- `generate.web/ClientApp/src/app/shared/components/app-header.component.ts`/`.html`, `app-drawer/`, `app-footer.component.*`
- `generate.web/ClientApp/src/app/shared/components/dialog/`, `confirmationdialog.component.*`, `ok-dialog.component.*`, `yes-no-dialog.component.ts`, `upload/`, `upload/dialog/`
- `generate.web/ClientApp/src/app/shared/guards/admin.guard.ts`, `confirmation.guard.ts`, `login.guard.ts`
- Representative feature modules that own the relevant user journey: `reports/` (`edfacts/`, `library/`, `sppapr/`, `summary/`), `settings/` (`toggle/`, `datastore/`), `resources/`, `about/`, `home/`

## Navigation And Focus

- Landmarks, headings, and skip-to-content behavior
- Focus order after route changes, dialog opens, dialog closes, and validation failures
- Keyboard traps, lost focus, or focus sent to hidden or non-interactive elements
- Custom `tabindex`, focus hacks, or DOM manipulation that bypasses framework behavior
- Manually numbered `tabindex` values left stale after controls are added, removed, or reordered

## Controls And Semantics

- Native controls used where possible
- Buttons, links, menus, and icon-only actions with clear accessible names
- Custom widgets with correct keyboard interaction and state exposure
- ARIA used to supplement semantics, not replace them unnecessarily

## Forms And Validation

- Programmatic labels for every input and select
- Required, invalid, hint, and error states exposed accessibly
- Grouped controls using `fieldset` and `legend` where needed
- Validation messages tied to the correct field and surfaced at the right time

## Tables, Lists, And Dense Data

- Headers and row context exposed clearly
- Sort and pagination state conveyed accessibly (e.g. via `@angular/cdk/a11y` `LiveAnnouncer`, already used for `matSort` changes in `report-library-table` and `flextable`)
- Action buttons in rows include enough context
- Dense data views (`mat-table`, `@generic-ui/ngx-grid`, legacy MDL grid markup) remain navigable without relying on sight alone

## Dialogs, Sidenavs, And Overlays

- Initial focus and focus return behavior for `MatDialog`-based dialogs (`dialog/`, `confirmationdialog`, `ok-dialog`, `yes-no-dialog`, `upload/dialog`) and the `app-drawer` side nav
- Background content not reachable when modal interaction is expected
- Dismiss, submit, and cancel controls are discoverable and labeled
- Screen-reader users receive the dialog title and purpose

## Uploads And File Flows

- Non-pointer (keyboard-only) path through the file-selection flow in `shared/components/upload/` (a plain `<input type="file">` triggered by a button, no drag-and-drop in this repo)
- Instructions, accepted formats, and errors available to assistive tech
- Add, remove, and progress states are labeled clearly
- File lists or upload progress views are operable from the keyboard

## Content And Feedback

- Important status changes announced or otherwise exposed accessibly (toast/snackbar blocks using `aria-live="assertive"`, `aria-atomic="true"`, `aria-relevant="text"`, seen in `app-header`, `login`, and `settings/toggle`)
- Color, icon, or position not used as the only signal
- Decorative content hidden only when it should be
- Visible text and accessible name do not conflict

## Visual And Styling Clues

- Code-defined color choices or CSS states that likely rely on color alone
- Hidden text, clipped content, or overflow behavior that can obscure meaning
- Focus indicators not removed or suppressed in CSS

## Backend And Generated Content

- User-facing error text (`Controllers/Web/ErrorController.cs`, `Views/Error/Index.cshtml`), downloads, or generated reports/exports preserve usable labels and instructions
- Server-rendered shell content (`Views/Shared/_Layout.cshtml`, `Views/App/Index.cshtml`) still has accessible structure when rendered in the browser
- APIs (`Controllers/Api/{App,ODS}/*.cs`) do not force the frontend into inaccessible patterns by omitting labels or context needed for announcements

## Priority Calibration

- `Critical`: Blocks task completion or creates a fundamental barrier across a core workflow
- `High`: Major barrier in a common workflow with clear user impact
- `Medium`: Confirmed issue with narrower scope or partial mitigation
- `Low`: Localized issue or defense-in-depth improvement
