# File Comparison

## Introduction

Generate version 5.3, released in early 2023, introduced a new utility to allow states to compare an E&#x44;_&#x46;acts_ file produced by the state’s legacy process (“Legacy File”) to an E&#x44;_&#x46;acts_ file produced by Generate (“Generate File”) to determine if the ETL used to populate Generate accurately migrated all data needed for the E&#x44;_&#x46;acts_ report.

The Submission File Comparison Utility is not available in the Generate user interface – it can only be used withing SQL Server Management Studio (SSMS).

This document provides instructions for using the utility.

## Submission File Comparison Utility Overview

The Generate Submission File Comparison Utility (“Comparison Utility”) provides tools to load legacy E&#x44;_&#x46;acts_ files into SQL tables, then compares the Generate versions of those same files to the legacy file to identify differences.

The basic steps for comparing a legacy file to a Generate file are to:

1. Load the legacy file into a SQL table
2. Run a Generate migration for the same file
3. Depending on the file specification (noted in this document), you may need to create an actual Generate E&#x44;_&#x46;acts_ file, preferably in Tab-delimited format, and load it into a SQL table.
4. Run the comparison utility
5. Review the results of the comparison
6. Resolve issues and repeat steps 2-5 as needed until satisfied with the comparison

{% embed url="https://www.figma.com/board/5qr4sYgmsUUpcaCRcdQD4y/Generate-EdFacts-File-Submission-Comparison-Utility?node-id=1:365&t=RMHT6TfCov4nrrfF-1" fullWidth="false" %}

### Office Hour Demonstration

{% embed url="https://youtu.be/MmfmSMswVFM?t=722" %}
