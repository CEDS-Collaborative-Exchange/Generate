--Update DataMigrationTasks for the NorD Fact Type
update app.DataMigrationTasks
set facttypeid = 15
where StoredProcedureName like '%neglec%';

------------------------------------------------------
--Changes for the School Performance Indicators
------------------------------------------------------
--Add the dimension tables 
	insert into App.DimensionTables
	values ('DimIndicatorStatuses', 1),
			('DimSchoolPerformanceIndicatorCategories', 1),
			('DimSchoolPerformanceIndicators', 1),
			('DimSchoolPerformanceIndicatorStateDefinedStatuses', 1),
			('DimSchoolQualityOrStudentSuccessIndicators', 1);

--Add the dimensions
	insert into app.Dimensions
		select 'IndicatorStatus', (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimIndicatorStatuses'), 0, 1;
	insert into app.Dimensions
		select 'SchoolPerformanceIndicatorCategory', (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchoolPerformanceIndicatorCategories'), 0, 1;
	insert into app.Dimensions
		select 'SchoolPerformanceIndicator', (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchoolPerformanceIndicators'), 0, 1;
	insert into app.Dimensions
		select 'SchoolPerformanceIndicatorStateDefinedStatus', (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchoolPerformanceIndicatorStateDefinedStatuses'), 0, 1;
	insert into app.Dimensions
		select 'SchoolQualityOrStudentSuccessIndicator', (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchoolQualityOrStudentSuccessIndicators'), 0, 1;

--Add the new columns to app.GenerateStagingColumns
    insert into app.GenerateStagingColumns
    values 
    ((select StagingTableId
        from app.GenerateStagingTables
        where StagingTableName = 'SchoolPerformanceIndicators'), 'LeaIdentifierSea', 'nvarchar', 50, NULL, NULL),
    ((select StagingTableId
        from app.GenerateStagingTables
        where StagingTableName = 'SchoolPerformanceIndicators'), 'IdeaIndicator', 'bit', NULL, NULL, NULL),
    ((select StagingTableId
        from app.GenerateStagingTables
        where StagingTableName = 'SchoolPerformanceIndicators'), 'EconomicDisadvantageStatus', 'bit', NULL, NULL, NULL),
    ((select StagingTableId
        from app.GenerateStagingTables
        where StagingTableName = 'SchoolPerformanceIndicators'), 'Race', 'varchar', 100, NULL, NULL),
    ((select StagingTableId
        from app.GenerateStagingTables
        where StagingTableName = 'SchoolPerformanceIndicators'), 'SchoolPerformanceIndicatorStatus', 'varchar', 100, NULL, NULL),
    ((select StagingTableId
        from app.GenerateStagingTables
        where StagingTableName = 'SchoolPerformanceIndicators'), 'SchoolPerformanceIndicatorStateDefinedStatusDescription', 'varchar', 200, NULL, NULL);

--Delete the deprecated columns from app.GenerateStagingColumns
    delete gsc
    from app.GenerateStagingColumns gsc
        inner join app.GenerateStagingTables gst
            on gsc.StagingTableId = gst.StagingTableId
    where gst.StagingTableName = 'SchoolPerformanceIndicators'
    and gsc.StagingColumnName = 'SubgroupElementName';

--Add the new Fact Type
    insert into app.FactTables
    values ('SchoolPerformanceIndicatorStateDefinedStatusId',NULL, NULL, 'ReportEDFactsSchoolPerformanceIndicatorId', 'ReportEDFactsSchoolPerformanceIndicators', 'FactSchoolPerformanceIndicatorId', 'FactSchoolPerformanceIndicators');

--Add Fact table to Dimension table mappings
    insert into app.FactTable_DimensionTables values
        ((select FactTableId from app.FactTables where FactTableName = 'FactSchoolPerformanceIndicators')
        , (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimFactTypes'));
    insert into app.FactTable_DimensionTables values
        ((select FactTableId from app.FactTables where FactTableName = 'FactSchoolPerformanceIndicators')
        , (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimK12Schools'));
    insert into app.FactTable_DimensionTables values
        ((select FactTableId from app.FactTables where FactTableName = 'FactSchoolPerformanceIndicators')
        , (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimRaces'));    
    insert into app.FactTable_DimensionTables values
        ((select FactTableId from app.FactTables where FactTableName = 'FactSchoolPerformanceIndicators')
        , (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimIdeaStatuses')); 
    insert into app.FactTable_DimensionTables values
        ((select FactTableId from app.FactTables where FactTableName = 'FactSchoolPerformanceIndicators')
        , (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimK12Demographics'));
    insert into app.FactTable_DimensionTables values
        ((select FactTableId from app.FactTables where FactTableName = 'FactSchoolPerformanceIndicators')
        , (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimEconomicallyDisadvantagedStatuses'));    
    insert into app.FactTable_DimensionTables values
        ((select FactTableId from app.FactTables where FactTableName = 'FactSchoolPerformanceIndicators')
        , (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchoolPerformanceIndicatorCategories'));
    insert into app.FactTable_DimensionTables values
        ((select FactTableId from app.FactTables where FactTableName = 'FactSchoolPerformanceIndicators')
        , (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchoolPerformanceIndicators'));  
    insert into app.FactTable_DimensionTables values
        ((select FactTableId from app.FactTables where FactTableName = 'FactSchoolPerformanceIndicators')
        , (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchoolPerformanceIndicatorStateDefinedStatuses'));
    insert into app.FactTable_DimensionTables values
        ((select FactTableId from app.FactTables where FactTableName = 'FactSchoolPerformanceIndicators')
        , (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimSchoolQualityOrStudentSuccessIndicators'));  
    insert into app.FactTable_DimensionTables values
        ((select FactTableId from app.FactTables where FactTableName = 'FactSchoolPerformanceIndicators')
        , (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimIndicatorStatuses'));    
    insert into app.FactTable_DimensionTables values
        ((select FactTableId from app.FactTables where FactTableName = 'FactSchoolPerformanceIndicators')
        , (select DimensionTableId from app.DimensionTables where DimensionTableName = 'DimSubgroups'));

--connect the reports to the staging table(s)
	insert into app.GenerateReport_GenerateStagingXREF
	select '102', (select StagingTableId from app.GenerateStagingTables where StagingTableName = 'SchoolPerformanceIndicators'), NULL;

	insert into app.GenerateReport_GenerateStagingXREF
	select '103', (select StagingTableId from app.GenerateStagingTables where StagingTableName = 'SchoolPerformanceIndicators'), NULL;

	insert into app.GenerateReport_GenerateStagingXREF
	select '104', (select StagingTableId from app.GenerateStagingTables where StagingTableName = 'SchoolPerformanceIndicators'), NULL;

	insert into app.GenerateReport_GenerateStagingXREF
	select '105', (select StagingTableId from app.GenerateStagingTables where StagingTableName = 'SchoolPerformanceIndicators'), NULL;

	insert into app.GenerateReport_GenerateStagingXREF
	select '108', (select StagingTableId from app.GenerateStagingTables where StagingTableName = 'SchoolPerformanceIndicators'), NULL;

--Update SSRD to Fact type relationship
    update app.SourceSystemReferenceMapping_DomainFile_XREF
    set GenerateReportGroup = 'ChildCount,Discipline,Exiting,Assessments,Membership,Homeless,SchoolPerformanceIndicators'
        , GenerateReportId = '19,12,18,17,16,14,9,8,15,7,6,81,5,4,84,41,46,65,100,102,103,104,105'
    where CEDSReferenceTable = 'RefRace'

