# System Architecture Overview

## Purpose

This page provides a high-level view of the reporting architecture used to support Generate reporting activities.

Detailed architecture diagrams should be maintained separately and linked from this page.

## Standard Reporting Architecture

```
Source Systems
       ↓
Source Extracts
       ↓
Generate Staging Tables
       ↓
CEDS Warehouse
(Fact and Dimension Tables)
       ↓
Report Tables
       ↓
EDFacts Submission Files
```

## Architecture Components

| Component               | Purpose                 |
| ----------------------- | ----------------------- |
| Source Systems          | Original data source    |
| Source Extracts         | Reporting extracts      |
| Generate Staging Tables | Initial migration layer |
| CEDS Warehouse          | Reporting warehouse     |
| Report Tables           | Reporting outputs       |
| EDFacts Files           | Final submission files  |

## Architecture Documentation

| Resource                     | Purpose                         | Link |
| ---------------------------- | ------------------------------- | ---- |
| Enterprise Data Flow Diagram | High-level architecture         |      |
| Fact Type Diagrams           | Fact type specific architecture |      |
| Source System Diagrams       | Source dependencies             |      |
| Generate Documentation       | Product architecture            |      |

## Annual Architecture Review

Review architecture documentation annually.

Verify:

* Source systems remain accurate
* Data flows remain current
* Architecture diagrams are updated
* Technical documentation remains aligned
