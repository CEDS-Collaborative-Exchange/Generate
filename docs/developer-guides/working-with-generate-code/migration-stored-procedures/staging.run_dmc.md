# Staging.RUN\_DMC

### Overview & Purpose

This stored procedure retrieves and formats membership report data for educational institutions. It dynamically constructs SQL queries based on input parameters to extract data from fact tables and apply various transformations including category filtering, zero count handling, and missing data obscuration. The procedure supports multiple report types and organizational levels.

#### Main Functions:

*   **Dynamic SQL Generation**

    Constructs SQL queries at runtime based on input parameters to retrieve appropriate report data
*   **Zero Count Handling**

    Includes or excludes records with zero counts based on parameters and business rules
*   **Missing Category Obscuration**

    Replaces or removes records with missing category values based on configuration

#### Key Calculations:

*   **Dynamic SQL Generation: Creates flexible queries that adapt to different report types and filtering requirements**

    Formula: `Dynamic SQL construction with parameter substitution`

    Business Significance: Enables a single procedure to handle multiple report formats and data structures

    Example: Building SQL statements with different category sets and report levels
*   **Zero Count Handling: Controls visibility of zero-value data points in reports**

    Formula: `Conditional inclusion of zero count records`

    Business Significance: Ensures reports show complete data sets when required or cleaner reports when zeros are not meaningful

    Example: Using @includeZeroCounts parameter to determine if zero count records should be included
*   **Missing Category Obscuration: Handles missing data in a consistent way across reports**

    Formula: `UPDATE @reportData SET factField = -1 WHERE CategorySetCode = X AND ReportField = 'MISSING'`

    Business Significance: Ensures data quality and consistency in reporting

    Example: Setting student counts to -1 for missing category values when appropriate

#### Data Transformations:

* Conversion of category codes to friendly names when requested
* Filtering data based on report code, level, year, and category set
* Handling of missing category values through obscuration or removal
* Dynamic inclusion of zero count records based on parameters and business rules
* Pagination of results using start record and number of records parameters

#### Expected Output:

The procedure returns two result sets: 1) A paginated set of report data with organization details, categories, and count values, and 2) A count of total records matching the criteria before pagination.

### Business Context

**System:** Educational Data Reporting System

**Necessity:** Provides flexible, consistent access to educational membership data across different organizational levels and reporting requirements

#### Business Rules:

* Some reports require special handling for zero counts based on report code and level
* Missing category values may be obscured with -1 values when specified
* Performance-related reports (c175, c178, c179) have special handling when not at SEA level
* Reports can be filtered by organization level (SEA, LEA, school)
* Category sets control which dimensions are included in reports

#### Result Usage:

The data is used to generate standardized educational reports for compliance, analysis, and decision-making

#### Execution Frequency:

On-demand when reports are requested

#### Critical Periods:

* End of school year reporting periods
* Federal and state reporting deadlines

### Parameters

| Parameter                     | Data Type   | Purpose                                                          | Required |
| ----------------------------- | ----------- | ---------------------------------------------------------------- | -------- |
| @reportCode                   | varchar(50) | Identifies the specific report to generate                       | True     |
| @reportLevel                  | varchar(50) | Specifies the organizational level for the report                | True     |
| @reportYear                   | varchar(50) | Specifies the school year for the report data                    | True     |
| @categorySetCode              | varchar(50) | Specifies which category set to use for the report               | False    |
| @includeZeroCounts            | bit         | Controls whether records with zero counts are included           | True     |
| @includeFriendlyCaptions      | bit         | Controls whether category codes are translated to friendly names | True     |
| @obscureMissingCategoryCounts | bit         | Controls handling of records with missing category values        | True     |
| @isOnlineReport               | bit         | Indicates if the report is being generated for online viewing    | False    |
| @startRecord                  | int         | Starting record number for pagination                            | True     |
| @numberOfRecords              | int         | Number of records to return for pagination                       | True     |

### Source Tables

#### rds.FactCustomCounts

**Business Purpose:** Stores custom count data for specialized reports

**Columns:**

| Name              | Data Type | Business Purpose                            |
| ----------------- | --------- | ------------------------------------------- |
| FactCustomCountId | Unknown   | Primary key for the custom count record     |
| ReportCode        | Unknown   | Identifies which report the data belongs to |

#### app.GenerateReport\_FactType

**Business Purpose:** Maps reports to fact types

**Columns:**

| Name             | Data Type | Business Purpose                  |
| ---------------- | --------- | --------------------------------- |
| GenerateReportId | Unknown   | Links to the report definition    |
| FactTypeId       | Unknown   | Links to the fact type definition |

#### rds.DimFactTypes

**Business Purpose:** Stores fact type definitions

**Columns:**

| Name          | Data Type | Business Purpose               |
| ------------- | --------- | ------------------------------ |
| DimFactTypeId | Unknown   | Primary key for fact type      |
| FactTypeCode  | Unknown   | Code identifying the fact type |

#### rds.DimSchoolYears

**Business Purpose:** Stores school year definitions

**Columns:**

| Name       | Data Type | Business Purpose                  |
| ---------- | --------- | --------------------------------- |
| SchoolYear | Unknown   | Identifies a specific school year |

#### app.FactTables

**Business Purpose:** Stores metadata about fact tables in the system

**Columns:**

| Name                  | Data Type | Business Purpose                                  |
| --------------------- | --------- | ------------------------------------------------- |
| FactTableId           | Unknown   | Primary key for fact table metadata               |
| FactTableName         | Unknown   | Name of the physical fact table                   |
| FactFieldName         | Unknown   | Name of the main fact field in the table          |
| FactReportTableName   | Unknown   | Name of the report table associated with the fact |
| FactReportTableIdName | Unknown   | Name of the ID field in the report table          |
| FactReportDtoIdName   | Unknown   | Name of the DTO ID field                          |

#### app.GenerateReports

**Business Purpose:** Stores report definitions

**Columns:**

| Name                 | Data Type | Business Purpose                           |
| -------------------- | --------- | ------------------------------------------ |
| GenerateReportId     | Unknown   | Primary key for report definition          |
| ReportCode           | Unknown   | Code identifying the report                |
| FactTableId          | Unknown   | Links to the fact table used by the report |
| GenerateReportTypeId | Unknown   | Links to the report type                   |

#### app.Dimensions

**Business Purpose:** Stores dimension definitions

**Columns:**

| Name               | Data Type | Business Purpose                     |
| ------------------ | --------- | ------------------------------------ |
| DimensionId        | Unknown   | Primary key for dimension definition |
| DimensionFieldName | Unknown   | Name of the dimension field          |
| DimensionTableId   | Unknown   | Links to the dimension table         |

#### app.CategorySets

**Business Purpose:** Stores category set definitions

**Columns:**

| Name                | Data Type | Business Purpose                  |
| ------------------- | --------- | --------------------------------- |
| CategorySetId       | Unknown   | Primary key for category set      |
| CategorySetCode     | Unknown   | Code identifying the category set |
| CategorySetName     | Unknown   | Name of the category set          |
| GenerateReportId    | Unknown   | Links to the report definition    |
| OrganizationLevelId | Unknown   | Links to the organization level   |
| SubmissionYear      | Unknown   | Year the category set applies to  |
| TableTypeId         | Unknown   | Links to the table type           |
| CategorySetSequence | Unknown   | Order of the category set         |

### Temporary Tables

#### @reportData

**Purpose:** Stores the processed report data before final output

**Columns:**

| Name                                                    | Data Type | Purpose/Calculation                |
| ------------------------------------------------------- | --------- | ---------------------------------- |
| Various including StateANSICode, OrganizationName, etc. | Various   | Direct assignment from source data |

#### @ReportFieldsInFactTable

**Purpose:** Stores the report fields available in the fact table

**Columns:**

| Name        | Data Type     | Purpose/Calculation                   |
| ----------- | ------------- | ------------------------------------- |
| ReportField | nvarchar(100) | Direct assignment from app.Dimensions |

#### @ReportFieldsInCategorySet

**Purpose:** Stores the report fields used in the selected category set

**Columns:**

| Name        | Data Type    | Purpose/Calculation                   |
| ----------- | ------------ | ------------------------------------- |
| ReportField | varchar(100) | Direct assignment from app.Dimensions |

#### #CAT\_PerformanceLevel

**Purpose:** Stores performance level category options for performance reports

**Columns:**

| Name | Data Type   | Purpose/Calculation                        |
| ---- | ----------- | ------------------------------------------ |
| Code | varchar(50) | Direct assignment from app.CategoryOptions |

#### #performanceData\_\*

**Purpose:** Stores performance data for each category set in performance reports

**Columns:**

| Name                                                    | Data Type | Purpose/Calculation            |
| ------------------------------------------------------- | --------- | ------------------------------ |
| Various including StateANSICode, OrganizationName, etc. | Various   | Generated by RDS.Get\_CountSQL |

### Potential Improvements

#### Error Handling

**Description:** Add explicit error handling for invalid parameters and SQL execution failures

**Benefits:** Improved reliability and easier troubleshooting

**Priority:** High

#### Performance

**Description:** Optimize dynamic SQL generation to reduce string concatenation

**Benefits:** Improved execution time for complex reports

**Priority:** Medium

#### Code Maintainability

**Description:** Refactor into smaller, more focused stored procedures

**Benefits:** Improved maintainability and easier debugging

**Priority:** Medium

#### Security

**Description:** Add parameter validation to prevent SQL injection

**Benefits:** Improved security and data protection

**Priority:** High

#### Documentation

**Description:** Add comprehensive inline documentation

**Benefits:** Improved maintainability and knowledge transfer

**Priority:** Medium

### Execution Steps

#### Step 1: Initialize variables and determine fact/report tables

**Input Data:** Input parameters

**Transformations:** None

select @factTable = ft.FactTableName, @factField = ft.FactFieldName, @factReportTable = ft.FactReportTableName, @factReportId = ft.FactReportTableIdName, @factReportDtoId = ft.FactReportDtoIdName from app.FactTables ft inner join app.GenerateReports r on ft.FactTableId = r.FactTableId where r.ReportCode = @reportCode

#### Step 2: Handle custom counts if applicable

**Input Data:** Fact table information

**Transformations:** None

if @factTable = 'FactCustomCounts' begin select FactCustomCountId, ReportCode, ... from rds.FactCustomCounts where ReportCode = @reportCode and ReportLevel = @reportLevel and ReportYear = @reportYear and CategorySetCode = isnull(@categorySetCode, CategorySetCode) return end

#### Step 3: Identify report fields in fact table and category set

**Input Data:** Fact table information

**Transformations:** None

insert into @ReportFieldsInFactTable (ReportField) select distinct upper(d.DimensionFieldName) as ReportField from App.Dimensions d inner join App.FactTable\_DimensionTables fd on d.DimensionTableId = fd.DimensionTableId inner join App.FactTables ft on fd.FactTableId = ft.FactTableId where ft.FactTableName = @factTable and upper(d.DimensionFieldName) <> 'YEAR'

#### Step 4: Build dynamic SQL for report data retrieval

**Input Data:** Report fields and parameters

**Transformations:** Complex SQL string building

set @sql = @sql + 'declare @reportData as table (...)'

#### Step 5: Handle performance reports if applicable

**Input Data:** Report code, level, and year

**Transformations:** Complex SQL string building

if(@isPerformanceSql = 1) begin ... end

#### Step 6: Handle zero counts if applicable

**Input Data:** includeZeroCounts parameter

**Transformations:** Complex SQL string building

if @includeZeroCounts = 1 begin ... end

#### Step 7: Handle missing category obscuration if applicable

**Input Data:** obscureMissingCategoryCounts parameter

**Transformations:** Complex SQL string building

if @obscureMissingCategoryCounts = 1 begin ... end

#### Step 8: Finalize and execute dynamic SQL

**Input Data:** Constructed SQL string

**Transformations:** None

EXECUTE sp\_executesql @sql, @ParmDefinition, @reportCode = @reportCode, @reportYear = @reportYear, @reportLevel = @reportLevel, @categorySetCode = @categorySetCode, @isOnlineReport=@isOnlineReport;
