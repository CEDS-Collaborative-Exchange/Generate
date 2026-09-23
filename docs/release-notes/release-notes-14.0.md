---
description: >-
  Technical enhancements, reporting updates, and upgrade actions in Generate
  14.0.
icon: sparkles
cover: ../.gitbook/assets/GenerateBanner14_0.avif
coverY: 0
layout:
  width: default
  cover:
    visible: true
    size: hero
    mask: none
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
  metadata:
    visible: true
  tags:
    visible: true
  actions:
    visible: true
  anchors:
    visible: true
---

# Release Notes 14.0

Generate 14.0 updates staging columns for CEDS v14. It also improves IDEA and non-IDEA reporting, navigation, and migration debugging.

### Upgrade actions

#### Review staging column changes

{% hint style="warning" %}
**Action required:** Review your source-to-staging ETL migrations before upgrading. CEDS v14 renames, adds, and removes staging columns. Update any affected migration or debugging code. Prioritize columns used for EDFacts reporting.
{% endhint %}

CEDS v14 renames, adds, and removes staging columns. Review the complete [SEA impact documentation](https://github.com/CEDS-Collaborative-Exchange/Generate/blob/master/docs/Generate%20File%20Storage/SEA%20Impact%20-%20Generate%20changes%20to%20support%20CEDS%20v14.xlsx).

#### Configure OAuth API access

{% hint style="warning" %}
**Action required for OAuth states:** Generate now uses JWT Bearer tokens for API authorization. This replaces custom token authorization.

If your state uses OAuth for login validation, configure the `access_as_user` API scope before upgrading.
{% endhint %}

Start with [oauth-configuration.md](../developer-guides/installation/oauth-configuration.md "mention"), then follow the instructions below:

1. Open the Generate Azure app registration.
2. Select **Expose an API**.
3. Add the `access_as_user` scope.
4. Allow admin and user consent.
5. Enable the scope.

### Summary of changes

#### IDEA reporting

* **Discipline (006):** Updated removal-duration aggregation. This aligns with PSC guidance across removal types.
  * If a student has an in-school removal < .5 days and an out-of-school removal < .5 days but the 2 together total > .5 days the student is included in the Generate counts because their total removal length is > .5 days. The question was how to report the student by Removal Type. Generate was using tie-breaker logic to pick one of the removal types. The guidance we received from PSC was that the student should be reported in EACH removal type they experienced whether or not that removal type exceeded .5 days.

#### Non-IDEA reporting

* **Membership (039):** Loads LEA grades offered directly into staging.
* **Membership (226):** Adds zero-count logic to the new report migration.
* **Neglected or Delinquent (218–221):** Adds zero-count logic to the new report migration.

### User interface changes

* **Assessments:** Updated the Toggle Assessments interface by adding filtering and sorting to better manage the loaded Assessments.
* **Reports:** Added a loading icon to the reports page as a visual indicator for more intensive and longer loading reports.
* **Navigation:** Added page-level navigation across the application to help users understand where they are and return to previous sections.

### General changes

#### Utilities

* Added `[Utilities].[GetEdFactsReportSubmissionData]` to return report data in EDFacts format. See [get-edfacts-report-submission-data.md](../developer-guides/generate-utilities/get-edfacts-report-submission-data.md "mention").
* Added `[Utilities].[CompareRecordsAcrossMigrations]` to compare records across migrations. See [compare-records-across-migrations.md](../developer-guides/generate-utilities/compare-records-across-migrations.md "mention").

#### Debugging and validation

Run every Staging-to-Fact stored procedure in debug mode. See [debugging-the-staging-to-fact-migrations.md](../developer-guides/migration/troubleshooting/debugging-the-staging-to-fact-migrations.md "mention").

### Release tickets

Review [Generate 14.0 release tickets](https://github.com/CEDS-Collaborative-Exchange/Generate/issues?q=is%3Aissue%20state%3Aopen%20label%3Av14.0) in the CEDS Collaborative Exchange.

***

### Generate Office Hour

{% embed url="https://www.youtube.com/watch?v=qdxFJqlbd_I" %}
Video: Generate 14.0 Office Hour recording
{% endembed %}
