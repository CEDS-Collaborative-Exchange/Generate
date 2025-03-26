---
icon: rectangle-terminal
---

# Getting Started

### Purpose <a href="#toc108711235" id="toc108711235"></a>

The Generate tool is made up of two main technical components:

{% hint style="success" %}
**SQL Database**

The SQL database component of Generate includes the most current [**Common Education Data Standards (CEDS)** **data warehouse**](generate-architecture.md).
{% endhint %}

{% hint style="success" %}
**Web Application**

The Generate web application is specifically designed to support E&#x44;_&#x46;acts_ and related reports.
{% endhint %}

This guide contains material relevant to the installation and implementation of the Generate SQL Server database and is specifically intended to provide:

1. Instructions for installing and configuring the Generate application.
2. An overview of the data migrations that take place within the Generate database and the troubleshooting tools available.
3. Context on the CEDS Integrated Data Store (IDS) and how it is leveraged in the Generate SQL Server database.
4. Design information and details on how education data is stored and managed longitudinally within the CEDS IDS.

### Intended Audience <a href="#toc113451489" id="toc113451489"></a>

This guide is intended for technical staff, including system administrators, database administrators, and application administrators, who are involved in supporting the installation, configuration, and implementation of the Generate system.

This guide will likely be most useful to technical staff that are overseeing data migration and/or writing extract, transform, and load (ETL) code. It is recommended to use this document in conjunction with any [ETL Documentation Templates](https://ciidta.communities.ed.gov/#communities/pdc/documents/17074)[.](https://ciidta.communities.ed.gov/#communities/pdc/documents/17074) _ETL Documentation Templates_ show how data are transformed through each stage of data migration, and this guide describes the database design, organization, and migrations in more detail.

<table data-view="cards"><thead><tr><th></th><th></th><th data-hidden data-card-target data-type="content-ref"></th></tr></thead><tbody><tr><td><mark style="color:green;"><strong>Installation</strong></mark></td><td>Install SQL Server, IIS, configure OAuth, metadata updates, subfolder setup, and optional tools like AD LDS and ADSI Editor.</td><td><a href="installation/">installation</a></td></tr><tr><td><a href="migration/"><mark style="color:green;"><strong>Migration</strong></mark></a></td><td>Migrate Data to Reporting Tables</td><td><a href="migration/data-migration.md">data-migration.md</a></td></tr><tr><td><a href="generate-utilities/"><mark style="color:green;"><strong>Generate Utilities</strong></mark></a></td><td>A collection of tools for data validation, cleanup, table snapshots, reference data mapping, and more. </td><td></td></tr></tbody></table>

Once you have installed Generate, the next thing you will need to do is get data from your source system into the staging tables in the Generate SQL Server database so that the data can be processed through the standardized Generate migration stages. The _Installation_ section of this guide contains instructions for both the Generate Database and the Generate IIS Web Server.

This guide will help you understand what data you need. You will need to determine what source data elements should be mapped and loaded into the Generate Staging tables.&#x20;

{% hint style="success" %}
**For systems using CEDS**: If your source system uses CEDS, rather than a custom build, then the data element names will match those in this Implementation Guide and in the [ETL Documentation Templates](https://ciidta.communities.ed.gov/#communities/pdc/documents/17074).
{% endhint %}

{% hint style="warning" %}
**For non-CEDS systems**: If your source system does not use CEDS, then the data element names will need to be mapped to CEDS.
{% endhint %}
