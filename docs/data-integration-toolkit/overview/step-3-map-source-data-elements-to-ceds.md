---
description: 'The CIID Data Integration Toolkit: Step 3 - Map Source Data Elements to CEDS'
---

# Step 3: Map Source Data Elements to CEDS

In Step 3, SEA project teams will locate and document the source elements and associated metadata required&#x20;by EDFacts and align each element with the CEDS standard, resolving discrepancies as a team. This is the first&#x20;step towards writing the extract, transform and load (ETL) code that moves data into the CEDS data warehouse.

## Why complete Step 3?

CEDS is an accessible, searchable, and centralized location for metadata. Aligning source data to CEDS allows&#x20;SEA staff and stakeholders to improve their understanding of SEA data and to share metadata. The resulting&#x20;documentation of business rules can be used internally (e.g., to train new staff ) and publicly (i.e., published&#x20;CEDS maps) to communicate how source data maps to CEDS.

Aligning source elements to CEDS is important because it describes how source data should be transformed&#x20;to create accurate files for EDFacts reporting. Aligning source elements to CEDS is the first step in translating&#x20;source data to a common language and creates an understanding of how the SEA’s data relates to the&#x20;standard. Sharing Align maps and viewing other states’ maps can help identify commonalities and encourage&#x20;partnerships or information sharing.

## Process and Timing

Tasks in Step 3 of the toolkit are iterative and may be repeated over a period of weeks or months depending&#x20;whether the project team maps all the source data collections at once or maps data sets individually in&#x20;preparation for specific EDFacts due dates. Mapping one data set may take a Subject Matter Expert (SME)&#x20;several hours. Tasks include preparing the documentation and aligning elements to CEDS. Following initial&#x20;mapping, the SME and technical staff with knowledge of the intended use of the data elements within the data&#x20;system should meet to review the alignments and reconcile any gaps or discrepancies.

### Task 3.1: Document data systems and elements associated with the&#xD; data integration effort

The project team will use the **ETL Checklist** to create a data dictionary of all data elements and data sources&#x20;required for E&#x44;_&#x46;acts_ submissions, including detailed information on each element. The ETL checklist is a&#x20;technical requirements document that provides the information ETL developers need to write the ETL. It&#x20;provides clear and complete requirements on where the source data reside; and the rules for extracting,&#x20;transforming, and loading the data into the CEDS Data Warehouse. The ETL checklist is also the official&#x20;documentation for communicating within SEAs what data are used for reporting to E&#x44;_&#x46;acts_. E&#x44;_&#x46;acts_&#x20;Coordinators and SMEs will use ETL Checklists to communicate and officially track the business rules used for&#x20;E&#x44;_&#x46;acts_ reporting.

Upon completion of this task, the project team will have created and organized a list of all source elements&#x20;needed for E&#x44;_&#x46;acts_ reporting and their attributes. If issues arise during this process that cannot be addressed&#x20;quickly and easily, consider using the Issue Tracker tool to document and keep track of items for future&#x20;resolution.

#### Activity 3.1.1: Locate or create a data dictionary for needed source systems and document&#xD; metadata in the ETL checklist

To document source systems, SEAs may use existing data dictionaries such as system user guides, data manuals,&#x20;or technical specifications. For each source system, SMEs identified in Activity 2.1.2 Document Data Stewards&#x20;and Systems, will locate or create lists of required elements from each source.

If no data dictionary exists, project teams can leverage the CEDS Align template and online Align tool to create&#x20;and manage a data dictionary or use the ETL Checklist as the basis for a data dictionary.\
Using the information from the data dictionary, begin entering metadata into the ETL Checklists. Download the&#x20;ETL Checklist(s) that are in the project’s scope from the CIID website. Take some time to review the checklists&#x20;and familiarize yourself with the tabs and columns. Navigate to the ETL tab within the workbook and scroll to&#x20;the right (Row 2, CEDS Element Details, Columns R and S) to see the specific CEDS elements needed to align to&#x20;your source data dictionary. The CEDS element metadata from the ETL checklist will provide context to the SME&#x20;in creating or locating items in the source system’s data dictionary.

Enter the following source metadata for each data source/set and the associated data elements from the data&#x20;dictionary in the ETL Checklists (Columns A-M):

* System Name&#x20;
* Technical Name
* Database Name
* Schema Name
* Table Name
* Column Name
* Element Name
* Element Definition
* Data Type
* Length
* Option Set
* Option Description
* Data Steward

Review and update your data dictionary and ETL Checklists on a regular basis, at least annually, reflecting&#x20;any federal or SEA data element or definition changes. Each year, E&#x44;_&#x46;acts_ publishes release notes specifying&#x20;changes in E&#x44;_&#x46;acts_ reporting requirements; these will need to be updated in each ETL Checklist.

#### Activity 3.1.2: Complete the Source-to-CEDS Alignments&#x20;

After the data dictionary is located or created, and metadata has been entered into the ETL Checklist, the project&#x20;team including data stewards, will review the ETL Checklist(s) to ensure all elements needed to address the&#x20;scope defined in Step 1 are included in the dictionary. The team will also define and document the selection&#x20;criteria (Column N) and transformation rules (Column O) in the ETL checklist.\
&#xNAN;_&#x54;ip: Both IT and program staff must understand the ETL checklists and know where they are stored._

{% hint style="success" %}
CEDS Tips

* If using CEDS Align for your data dictionary, create an Align map for  &#x20;each source system involved in the data integration effort. For example,  &#x20;Directory data required for EDFacts file FS029 may be in an organization  &#x20;management system while special education data may come from a  &#x20;statewide IEP system. Each system should have a separate Align map in  &#x20;CEDS.
* For maintenance of sources to CEDS alignments in future years, the team  &#x20;may find it easiest to download the Align map, make any additional  &#x20;changes for the new school year, then upload it to the Align tool as a new  &#x20;map.
{% endhint %}

For each ETL Checklist,&#x20;schedule a team meeting to&#x20;review the data dictionary&#x20;information completed in the&#x20;previous activity. This team&#x20;should include a SME and&#x20;technical staff who understand&#x20;intended uses for the data&#x20;elements in the data system&#x20;in question. Use the ETL tab in&#x20;the ETL Checklist to review and&#x20;confirm the data dictionary&#x20;information and record the&#x20;transformation rules. Data stewards will verify that they have addressed all discrepancies and verify that the&#x20;proposed logic makes sense.&#x20;

Establish procedures and assign someone, e.g., data stewards or those responsible for the data, to maintain the&#x20;ETL documentation to keep it current. Document the assignment in the Roles and Responsibilities tab of the&#x20;Data Integration Project Planner. As federal reporting requirements change, new data elements will be added&#x20;or removed, and keeping this information up to date helps to ensure the data remains accurate.

{% hint style="success" %}
If your data dictionary is in CEDS, start by&#x20;downloading the Data Dictionary + CEDS report&#x20;for each CEDS align map needed for the&#x20;applicable EDFacts file. This report will have similar column&#x20;headers as the ETL Checklist. Copy and paste the source&#x20;information (on the left portion of the report) into the ETL&#x20;Checklist. Note that the ETL Checklist contains a unique&#x20;row for each option set.
{% endhint %}

**Resources**

[ETL Checklist](https://ciidta.communities.ed.gov/#communities/pdc/documents/17074)
