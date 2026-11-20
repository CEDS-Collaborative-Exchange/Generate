---
description: Reporting, migration, utility, and user interface updates in Generate 14.1.
icon: sparkles
cover: ../.gitbook/assets/GenerateBanner14_1.avif
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

# Release Notes 14.1

Generate 14.1 improves IDEA and non-IDEA reporting, migration accuracy, utilities, and upgrade feedback.

### Upgrade actions

#### Update configuration files

{% hint style="warning" %}
**Action required:** Add the new `appSettings.json` parameters before upgrading to Generate 14.1.
{% endhint %}

Add the four new parameters to the `appSettings.json` file in `\web\config` on the web server where Generate is installed:

{% code title="web/config/appSettings.json" %}
```json
"AzureAppServiceResourceId": "",
"AzureStorageContainerUrl": "",
"BackgroundApiScope": "",
"EnableAzureDeployment": false,
```
{% endcode %}

Add the three parameters in the `appSettings.json` file in `\background` on the web server where Generate is installed:

{% code title="background/appSettings.json" %}
```json
"AzureAppServiceResourceId": "",
"AzureStorageContainerUrl": "",
"EnableAzureDeployment": false
```
{% endcode %}

### Summary of changes

#### IDEA reporting

**Discipline (006)**

Updated removal-duration aggregation to align with PSC guidance.

Generate now combines all in-school suspensions, out-of-school suspensions, and expulsions. A student qualifies when the combined duration exceeds 0.5 days. The student is then reported in every discipline-removal category they experienced.

Previously, Generate applied the 0.5-day threshold separately to each removal type.

**Exiting (009)**

Updated state-level aggregation for students whose final exit is an MKC.

The update covers students who remain in special education at year-end but had an MKC exit during the year. Generate now applies this aggregation across every category set, Subtotals 2–6, and the Education Unit Total.

Previously, this logic relied on the Basis of Exit value. That value is unavailable in those subtotals and the total.

#### Non-IDEA reporting

**English Learner Assessment (050, 126, 137, 138, and 139)**

* Added a dedicated Fact Type for these assessment files. They no longer use the Assessment Fact Type.
* Renamed `EnglishLearnerParticpation` to `TitleIIIEnglishLearnerParticipationStatus` in `Staging.ProgramParticipationTitleIII`.
* Added `TitleIIIEnglishLearnerParticipationStatus` to `rds.DimTitleIIIStatuses` and updated migration code.

### User interface changes

* **Generate Update:** Improved upgrade feedback during processing.
* **Toggle:** Removed a duplicate Exiting question and reordered the question sequence to group the graduation questions together.

### General changes

#### Utilities

* Added `[Utilities].[Cleanup_DataMigrationHistories]`. See [Cleanup Data Migration Histories](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/generate-utilities/cleanup-data-migration-histories).
* Updated `[Utilities].[CreateSnapshotFromStaging]` to reconcile snapshot tables with Staging schema changes. See [Create Snapshot from Staging](https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/generate-utilities/staging-table-snapshot).&#x20;

#### Migrations and data quality

* Corrected student and staff migration to `rds.DimPeople_Current`. This prevents potential migration mismatches.
* Corrected the column name, StatedDefinedIndicatorStatus to remove the "d" in stated in `Staging.OrganizationSchoolIndicatorStatus`.
* Corrected the spelling of Puerto Rico in `rds.DimSubGroups`.

#### BI reports

* Added views for Significant Disproportionality and NCADEMI reports.

### Coming next

Generate 14.2 is planned for May 2027. It is expected to include July-due file updates, validation rules, user interface improvements, and tool enhancements.

### Release Tickets

Review [Generate 14.1 release tickets](https://github.com/CEDS-Collaborative-Exchange/Generate/issues?q=is%3Aissue%20state%3Aopen%20label%3Av14.1) in the CEDS Collaborative Exchange.

***

### Generate Office Hour

{% embed url="https://www.youtube.com/watch?v=nNXJssaDd14" %}
