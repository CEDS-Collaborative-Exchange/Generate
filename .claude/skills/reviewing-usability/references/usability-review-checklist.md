# Usability Review Checklist

Use this checklist to guide a repository review, then spend most of the time on the highest-impact confirmed task-friction paths.

## Triage First

- What are the most important user tasks?
- Which screens are form-heavy, table-heavy, dialog-heavy, or upload-heavy?
- Where can a user get stuck, make a preventable mistake, or lose confidence?

## Generate Repo Sweep

- `generate.web/ClientApp/src/app/app.component.ts` and `app.component.html`
- `generate.web/ClientApp/src/app/app.module.ts`
- `generate.web/ClientApp/src/app/app-routing.module.ts`
- `generate.web/ClientApp/src/app/services/app/`
- `generate.web/ClientApp/src/app/services/ods/`
- `generate.web/ClientApp/src/app/shared/guards/`
- `generate.web/ClientApp/src/app/shared/interceptors/`
- `generate.web/ClientApp/src/app/shared/components/dialog/`
- `generate.web/ClientApp/src/app/shared/components/upload/`
- `generate.web/ClientApp/src/app/shared/components/app-drawer/`
- Representative feature areas that own the relevant workflow (`reports/`, `settings/`, `resources/`)
- `generate.web/Controllers/Api/App/` and `generate.web/Controllers/Api/ODS/`
- Backend endpoints or services that shape validation, errors, statuses, or file workflows

## Navigation And Workflow

- Clear route flow between list, details, edit, review, and submit states
- Users can tell where they are and what mode they are in
- Back, cancel, and recovery paths are predictable
- Long workflows do not depend on users remembering hidden context

## Forms And Data Entry

- Required fields, allowed formats, defaults, and dependencies are clear
- Validation messages are timely and actionable
- Save and submit actions have clear outcomes
- Large forms are broken into understandable sections when possible

## Tables, Menus, And Dense Data

- Row actions are understandable without guesswork
- Sort, filter, and pagination behavior is understandable
- Important status or action context is visible
- Table-heavy screens do not hide the primary next action

## Dialogs, Notifications, And Feedback

- Confirmations explain consequences
- Success, warning, loading, and failure states are visible and specific
- Destructive actions are distinguished from routine actions
- Notifications help users recover, not just acknowledge failure

## Uploads, Downloads, And Files

- Accepted types and next steps are clear
- Progress and completion are visible
- Replace, remove, and retry paths are understandable
- Download actions use meaningful names and obvious context

## Backend-Driven UX

- API validation and error messages are understandable to end users
- Backend defaults and statuses map cleanly to frontend concepts
- Redirect or auth failures do not produce abrupt, unexplained task loss

## Priority Calibration

- `Critical`: Users are blocked or likely to fail a core task repeatedly
- `High`: Major friction in a common workflow
- `Medium`: Confirmed issue with narrower scope or partial mitigation
- `Low`: Local clarity, consistency, or efficiency issue
