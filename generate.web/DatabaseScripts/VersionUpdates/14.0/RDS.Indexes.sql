IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_DimSchoolPerformanceIndicatorCategories_SchoolPerformanceIndicatorCategoryCode'
      AND object_id = OBJECT_ID(N'[RDS].[DimSchoolPerformanceIndicatorCategories]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_DimSchoolPerformanceIndicatorCategories_SchoolPerformanceIndicatorCategoryCode]
        ON [RDS].[DimSchoolPerformanceIndicatorCategories]([SchoolPerformanceIndicatorCategoryCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_DimSchoolPerformanceIndicatorCategories_SchoolPerformanceIndicatorCategoryEdFactsCode'
      AND object_id = OBJECT_ID(N'[RDS].[DimSchoolPerformanceIndicatorCategories]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_DimSchoolPerformanceIndicatorCategories_SchoolPerformanceIndicatorCategoryEdFactsCode]
        ON [RDS].[DimSchoolPerformanceIndicatorCategories]([SchoolPerformanceIndicatorCategoryEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_DimSchoolPerformanceIndicators_SchoolPerformanceIndicatorTypeCode'
      AND object_id = OBJECT_ID(N'[RDS].[DimSchoolPerformanceIndicators]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_DimSchoolPerformanceIndicators_SchoolPerformanceIndicatorTypeCode]
        ON [RDS].[DimSchoolPerformanceIndicators]([SchoolPerformanceIndicatorTypeCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_DimSchoolPerformanceIndicators_SchoolPerformanceIndicatorTypeEdFactsCode'
      AND object_id = OBJECT_ID(N'[RDS].[DimSchoolPerformanceIndicators]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_DimSchoolPerformanceIndicators_SchoolPerformanceIndicatorTypeEdFactsCode]
        ON [RDS].[DimSchoolPerformanceIndicators]([SchoolPerformanceIndicatorTypeEdFactsCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_DimSchoolPerformanceIndicatorStateDefinedStatuses_SchoolPerformanceIndicatorStateDefinedStatusCode'
      AND object_id = OBJECT_ID(N'[RDS].[DimSchoolPerformanceIndicatorStateDefinedStatuses]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_DimSchoolPerformanceIndicatorStateDefinedStatuses_SchoolPerformanceIndicatorStateDefinedStatusCode]
        ON [RDS].[DimSchoolPerformanceIndicatorStateDefinedStatuses]([SchoolPerformanceIndicatorStateDefinedStatusCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_DimSchoolQualityOrStudentSuccessIndicators_SchoolQualityOrStudentSuccessIndicatorTypeCode'
      AND object_id = OBJECT_ID(N'[RDS].[DimSchoolQualityOrStudentSuccessIndicators]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_DimSchoolQualityOrStudentSuccessIndicators_SchoolQualityOrStudentSuccessIndicatorTypeCode]
        ON [RDS].[DimSchoolQualityOrStudentSuccessIndicators]([SchoolQualityOrStudentSuccessIndicatorTypeCode] ASC) WITH (FILLFACTOR = 80, DATA_COMPRESSION = PAGE);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_DimStateDefinedCustomIndicators_StateDefinedCustomIndicatorCode'
      AND object_id = OBJECT_ID(N'[RDS].[DimStateDefinedCustomIndicators]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_DimStateDefinedCustomIndicators_StateDefinedCustomIndicatorCode]
        ON [RDS].[DimStateDefinedCustomIndicators]([StateDefinedCustomIndicatorCode] ASC) WITH (DATA_COMPRESSION = PAGE);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_DimStateDefinedStatuses_StateDefinedStatusCode'
      AND object_id = OBJECT_ID(N'[RDS].[DimStateDefinedStatuses]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IX_DimStateDefinedStatuses_StateDefinedStatusCode]
        ON [RDS].[DimStateDefinedStatuses]([StateDefinedStatusCode] ASC) WITH (DATA_COMPRESSION = PAGE);
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IXFK_FactDirectory_DimComprehensiveAndTargetedSupports'
      AND object_id = OBJECT_ID(N'[RDS].[FactDirectory]')
)
BEGIN
    CREATE NONCLUSTERED INDEX [IXFK_FactDirectory_DimComprehensiveAndTargetedSupports]
        ON [RDS].[FactDirectory]([ComprehensiveAndTargetedSupportId] ASC);
END;