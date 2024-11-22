---
description: Frequently Asked Questions
hidden: true
---

# Implementation FAQ

The following information covers frequently asked questions of a more technical nature and are generally related to using the Generate Data Store. For questions not covered in this document, please send an inquiry email to [**CIIDTA@AEMcorp.com**](mailto:ciidta@aemcorp.com).

### Generate Data Store (Extract, Transform, Load (ETL)) <a href="#toc108711262" id="toc108711262"></a>

<details>

<summary>🤔 How do I determine which records should be used to populate the Person Table?</summary>

State IT staff will need to refer to the ETL checklist to identify data elements that populate the various tables in the Data Store.

</details>

<details>

<summary>🗺️ How do I map racial ethnic category for Hispanic/Latino in the ODS.SourcesystemReferenceData script?</summary>

The Hispanic or Latino Ethnicity is stored as a BIT flag ODS.PersonDetail.HispanicLatinoEthnicity and is not mapped to the ODS.SourceSystemReferenceData.

</details>

<details>

<summary>❓Where do I find the permitted values/output codes for data elements used by Generate?</summary>

Look up the values in the ODS.SourceSystemReferenceData in the ODS (within the Generate database) to find the code sets to map to. The ODS.SourceSystemReferenceData match the names of the elements in CEDS, so look them up in CEDS then find the actual values in the ODS.

</details>

### Organization Tables <a href="#toc108711263" id="toc108711263"></a>

<details>

<summary>❓Should the LEA_ and School_OperationalStatusEffectiveDate be an open date or a close date?</summary>

This would be the date that the current operational status took effect. Most often, it will be an open or close date but at the LEA level, if there is an operational status with a changed boundary or with a new LEA scheduled to open in the future, this date would be the date the boundary was changed, or when a “future” LEA was identified.

</details>

<details>

<summary>🤔 Is the school type the same as school level?</summary>

**No, they are not the same**. School Type in CEDS is defined as “The type of education institution as classified by its primary focus.” The options for School Type are Regular School, Special Education School, Career & Technical Education School, and Alternative School. School Level in CEDS is defined as “An indication of the level of the education institution.” It has options such as Adult, Elementary, High School, Infant/toddler, etc. You can find these in the CEDS Domain Entity Schema ([https://ceds.ed.gov/domainEntitySchema.aspx](https://na01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fceds.ed.gov%2FdomainEntitySchema.aspx\&data=02%7C01%7C%7C50d539b066d84f4bbbec08d644bc23a3%7C7a41925ef6974f7cbec30470887ac752%7C1%7C0%7C636771972175081488\&sdata=slC970XAsAaKkL14rlJO3bFdyZvyU6dlTHdKXfWcYCg%3D\&reserved=0)).

</details>

<details>

<summary>❓ What information should I put in the LEAOrganizationId, SchoolOrganizationId, and SEAOrganizationId fields when using the ETL templates?</summary>

These fields should be left blank. They are populated by the encapsulated code. They are used for troubleshooting, updating records, and to process the data faster.

</details>

<details>

<summary>❓Is the ‘OrganizationPersonRoleId_School’ column different than ‘Student_Identifier_State’?</summary>

**Yes, they are different**. The OrganizationPersonRoleId\_School field is used by the encapsulated code to keep track of the student's school enrollment record in the IDS. You should leave this field NULL. The Student\_Identifier\_State field in the Staging table is the unique ID assigned by the state to the student supplied from the source data system.&#x20;

</details>

### Enrollment Table <a href="#toc108711264" id="toc108711264"></a>

<details>

<summary>❓In the Enrollment table, what is the difference between the cohort_year and the cohort_graduation_year?</summary>

Cohort Year is the school year in which the student entered the baseline group used for computing completion rates (e.g., high school, program). Cohort Graduation Year is the year the cohort graduated with a regular high school diploma.

</details>

<details>

<summary>❓ Is the cohort_year in the Enrollment table the same as the school_year?</summary>

It is a four-digit year (fiscal year) for each instance. So, for the 2018-2019 school year, cohort year would be “2019” if the student entered the cohort for the first time in the 2018-2019 school year. Cohort\_year is sometimes referred to as the “year entered ninth grade” or the “year entered cohort.”

</details>

<details>

<summary>🤔 How is the PersonID column in the Enrollment table used? Is it different than Student_Identifier_State column?</summary>

The PersonId, OrganizationId\_School, OrganizationPersonRole\_School, and RunDateTime are all used by the Encapsulated code for troubleshooting, updating records, and to process the data faster. The Student\_Identifier\_State value is used by the Encapuslated code for searching the CEDS ODS for the student’s record. If a record is found, the Encapsulated code copies the PersonId into the Staging.Enrollment table. The same is true for the School\_Identifier\_State. The Encapsulated code searches the ODS for that Identifier. If a record is found, it copies the OrganizationId value in the Staging table in the OrganizationId\_School field.  If the PersonId or OrganizationId cannot be found, the Encapsulated code leaves those columns NULL and data is not written into the ODS. This can be resolved by ensuring the student or organization records are being added to the ODS by the Person or Organization staging table and associated Encapsulated code.

</details>
