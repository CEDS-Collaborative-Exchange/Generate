---
description: CIID's Internal Quality Assurance Generate Testing Process
icon: handshake
---

# Quality Assurance

## **Approach**

The data migration process is all written in SQL, which is classically difficult to test when compared to coding language like C#. For Generate, we took a mathematical approach--trying it two different ways and comparing the results. Below is the process we use to test the full stack of data migrations in Generate. We recently started running all of the Generate end-to-end tests with a fresh set of data produced on a nightly basis by Hydrate.&#x20;

{% hint style="info" %}
**Hydrate** is an internal tool that produces randomized unit level test data for any configuration we need for testing the migration process.
{% endhint %}

1. **Run Hydrate:** This creates a large sampling of randomized student-level data.  Right now, we are leveraging Ohio's directory data, but all student data is produced on-demand using assigned distributions of random data (e.g. 20% of students are identified as Special Ed students, but Hydrate randomly chooses which students those are).
2. **Run the Generate Migrations:** After Hydrate is done producing the sample data, we run all data Staging-to-RDS data migrations. This populates all of the slowly changing dimensions (e.g. _DimPeople_, _DimLeas_, _DimK12Schools_, etc.) and the fact tables needed to run the E&#x44;_&#x46;acts_ reports (e.g. _FactK12StudentCounts_, _FactK12StudentAssessments_, _FactK12StudentDisciplines_, etc.).  Once this data has been processed, we run the report migrations.  &#x20;
3. **Update Toggle:** Select Toggle settings are changed to static settings, such as the Child Count Date, to ensure they are valid. We also update Toggle Assessments based on the randomized data that was produced by Hydrate so that Generate has access to the assessment metadata for the state. &#x20;
4. **Compile Submission Counts from Staging Data:** The business logic embedded in the Report Migrations is replicated in static SQL, but the counts are produced using raw data in the Staging environment. This is the "try it two ways" step. For each individual value within numbers compiled in this step, we compare it to what was produced by the Report Migrations. If any value does not match, we record that mismatch as a testing error. &#x20;
5. **Back Up the Test Database:** No test run is the same. To ensure we have the exact data that was used in the test run, we back up the test Generate database. This allows us to find issues that only occur under certain situations in the randomized data. &#x20;
6. **Review Test Results:** The above process is run nightly.  QA tester reviews the overall test results and creates a ticket in Jira for any file spec that contains an error. All failed tests are triaged by a SQL tester. The defect ticket is then prioritized by the Generate team using the established prioritization rubric along with all other tickets in Jira. If the randomized data created by Hydrate, or live data we uncover in our work directly with states, exposes an issue in the code we manually create the record/those records in Hydrate so that specific scenario is being tested every time moving forward.
