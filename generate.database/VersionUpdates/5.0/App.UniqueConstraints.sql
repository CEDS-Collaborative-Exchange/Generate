

set nocount on
begin try
begin transaction

	  UPDATE App.FileSubmissions
	  SET submissionyear = '20' + right(submissionyear, 2)
	
/*The PK on App.FileSubmission_FileColumns is too restrictive to allow us to consolidate App.FileColumns.  The new PK additionally includes the StartPosition, to allow the same FileColumnId to occur more than once in a FileSubmission, but require that column to occupy a different position*/
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[App].[FileSubmission_FileColumns]') AND type in (N'U'))
	ALTER TABLE [App].[FileSubmission_FileColumns] DROP CONSTRAINT [PK_FileSubmission_FileColumns] WITH ( ONLINE = OFF )

/*Drop existing UX (to allow re-run*/
	/**Categories**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'Categories' AND i.name = 'UX_Categories' ) ALTER TABLE App.Categories DROP CONSTRAINT UX_Categories;
	/**CedsConnections**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'CedsConnections' AND i.name = 'UX_CedsConnections' ) ALTER TABLE App.CedsConnections DROP CONSTRAINT UX_CedsConnections;
	/**CedsElements**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'CedsElements' AND i.name = 'UX_CedsElements' ) ALTER TABLE App.CedsElements DROP CONSTRAINT UX_CedsElements;
	/**DataMigrationStatuses**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'DataMigrationStatuses' AND i.name = 'UX_DataMigrationStatuses' ) ALTER TABLE App.DataMigrationStatuses DROP CONSTRAINT UX_DataMigrationStatuses;
	/**DataMigrationTypes**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'DataMigrationTypes' AND i.name = 'UX_DataMigrationTypes' ) ALTER TABLE App.DataMigrationTypes DROP CONSTRAINT UX_DataMigrationTypes;
	/**DimensionTables**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'DimensionTables' AND i.name = 'UX_DimensionTables' ) ALTER TABLE App.DimensionTables DROP CONSTRAINT UX_DimensionTables;
	/**FactTables**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'FactTables' AND i.name = 'UX_FactTables' ) ALTER TABLE App.FactTables DROP CONSTRAINT UX_FactTables;
	/**GenerateConfigurations**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'GenerateConfigurations' AND i.name = 'UX_GenerateConfigurations' ) ALTER TABLE App.GenerateConfigurations DROP CONSTRAINT UX_GenerateConfigurations;
	/**GenerateReportControlType**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'GenerateReportControlType' AND i.name = 'UX_GenerateReportControlType' ) ALTER TABLE App.GenerateReportControlType DROP CONSTRAINT UX_GenerateReportControlType;
	/**GenerateReportDisplayTypes**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'GenerateReportDisplayTypes' AND i.name = 'UX_GenerateReportDisplayTypes' ) ALTER TABLE App.GenerateReportDisplayTypes DROP CONSTRAINT UX_GenerateReportDisplayTypes;
	/**GenerateReportTopics**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'GenerateReportTopics' AND i.name = 'UX_GenerateReportTopics' ) ALTER TABLE App.GenerateReportTopics DROP CONSTRAINT UX_GenerateReportTopics;
	/**GenerateReportTypes**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'GenerateReportTypes' AND i.name = 'UX_GenerateReportTypes' ) ALTER TABLE App.GenerateReportTypes DROP CONSTRAINT UX_GenerateReportTypes;
	/**OrganizationLevels**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'OrganizationLevels' AND i.name = 'UX_OrganizationLevels' ) ALTER TABLE App.OrganizationLevels DROP CONSTRAINT UX_OrganizationLevels;
	/**SqlUnitTest**/
		/*NONE*/
	/**TableTypes**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'TableTypes' AND i.name = 'UX_TableTypes' ) ALTER TABLE App.TableTypes DROP CONSTRAINT UX_TableTypes;
	/**CedsConnection_CedsElements**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'CedsConnection_CedsElements' AND i.name = 'UX_CedsConnection_CedsElements' ) ALTER TABLE App.CedsConnection_CedsElements DROP CONSTRAINT UX_CedsConnection_CedsElements ;
	/**DataMigrationHistories**/
		/*NONE*/
	/**DataMigrations**/
		/*NONE*/
	/**DataMigrationTasks**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'DataMigrationTasks' AND i.name = 'UX_DataMigrationTasks' ) ALTER TABLE App.DataMigrationTasks DROP CONSTRAINT UX_DataMigrationTasks ;
	/**Dimensions**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'Dimensions' AND i.name = 'UX_Dimensions' ) ALTER TABLE App.Dimensions DROP CONSTRAINT UX_Dimensions ;
	/**FactTable_DimensionTables**/
		/*Already constrained by PK*/
	/**GenerateReports**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'GenerateReports' AND i.name = 'UX_GenerateReports' ) ALTER TABLE App.GenerateReports DROP CONSTRAINT UX_GenerateReports ;
	/**ODSElements**/
		/*NONE*/
	/**SqlUnitTestCaseResult**/
		/*NONE*/
	/**Category_Dimensions**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'Category_Dimensions' AND i.name = 'UX_Category_Dimensions' ) ALTER TABLE App.Category_Dimensions DROP CONSTRAINT UX_Category_Dimensions ;
	/**CategorySets**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'CategorySets' AND i.name = 'UX_CategorySets' ) ALTER TABLE App.CategorySets DROP CONSTRAINT UX_CategorySets ;
	/**FileColumns**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'FileColumns' AND i.name = 'UX_FileColumns' ) ALTER TABLE App.FileColumns DROP CONSTRAINT UX_FileColumns ;
	/**FileSubmissions**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'FileSubmissions' AND i.name = 'UX_FileSubmissions' ) ALTER TABLE App.FileSubmissions DROP CONSTRAINT UX_FileSubmissions ;
	/**GenerateReport_OrganizationLevels**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'GenerateReport_OrganizationLevels' AND i.name = 'UX_GenerateReport_OrganizationLevels' ) ALTER TABLE App.GenerateReport_OrganizationLevels DROP CONSTRAINT UX_GenerateReport_OrganizationLevels ;
	/**GenerateReport_TableType**/
		/*UX already enforced by PK*/
	/**GenerateReportFilterOptions**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'GenerateReportFilterOptions' AND i.name = 'UX_GenerateReportFilterOptions' ) ALTER TABLE App.GenerateReportFilterOptions DROP CONSTRAINT UX_GenerateReportFilterOptions ;
	/**GenerateReportTopic_GenerateReports**/
		/*UX already enforced by PK*/
	/**CategoryOptions**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'CategoryOptions' AND i.name = 'UX_CategoryOptions' ) ALTER TABLE App.CategoryOptions DROP CONSTRAINT UX_CategoryOptions ;
	/**CategorySet_Categories**/
		/*UX already enforced by PK*/
	/**FileSubmission_FileColumns**/
		/*PK dropped above*/
	/**ToggleAssessments**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'ToggleAssessments' AND i.name = 'UX_ToggleAssessments' ) ALTER TABLE App.ToggleAssessments DROP CONSTRAINT UX_ToggleAssessments ;
	/**ToggleQuestionTypes**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'ToggleQuestionTypes' AND i.name = 'UX_ToggleQuestionTypes' ) ALTER TABLE App.ToggleQuestionTypes DROP CONSTRAINT UX_ToggleQuestionTypes ;
	/**ToggleSectionTypes**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'ToggleSectionTypes' AND i.name = 'UX_ToggleSectionTypes' ) ALTER TABLE App.ToggleSectionTypes DROP CONSTRAINT UX_ToggleSectionTypes ;
	/**ToggleSections**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'ToggleSections' AND i.name = 'UX_ToggleSections' ) ALTER TABLE App.ToggleSections DROP CONSTRAINT UX_ToggleSections ;
	/**ToggleQuestions**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'ToggleQuestions' AND i.name = 'UX_ToggleQuestions' ) ALTER TABLE App.ToggleQuestions DROP CONSTRAINT UX_ToggleQuestions ;
	/**ToggleResponses**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'ToggleResponses' AND i.name = 'UX_ToggleResponses' ) ALTER TABLE App.ToggleResponses DROP CONSTRAINT UX_ToggleResponses ;
	/**ToggleQuestionOptions**/
		IF EXISTS ( SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id WHERE t.name = 'ToggleQuestionOptions' AND i.name = 'UX_ToggleQuestionOptions' ) ALTER TABLE App.ToggleQuestionOptions DROP CONSTRAINT UX_ToggleQuestionOptions ;


/****Layer1****/
	/***Map duplicates to earliest PK ID***/
		/**Categories**/
			SELECT CategoryId
				,CategoryCode
				,EdFactsCategoryId
				,[drank] = DENSE_RANK() OVER (PARTITION BY CategoryCode,EdFactsCategoryId ORDER BY CategoryId)
			INTO #allCategories
			FROM [App].[Categories] 

			SELECT CategoryId
				,CategoryCode
				,EdFactsCategoryId
			INTO #uniqueCategories
			FROM #allCategories
			WHERE drank = 1

			SELECT CategoryId
				,CategoryCode
				,EdFactsCategoryId
			INTO #duplicateCategories
			FROM #allCategories
			WHERE drank > 1

			SELECT [newCategoryId] = u.CategoryId
				,[oldCategoryId] = d.CategoryId
			INTO #mapCategories
			FROM #uniqueCategories u
			INNER JOIN #duplicateCategories d
				ON u.CategoryCode = d.CategoryCode
					AND u.EdFactsCategoryId = d.EdFactsCategoryId

			/*Drop tables*/
			DROP TABLE #uniqueCategories
			DROP TABLE #allCategories

		/**CedsConnections**/
			SELECT CedsConnectionId
				,CedsConnectionName
				,CedsUseCaseId
				,[drank] = DENSE_RANK() OVER (PARTITION BY CedsConnectionName,CedsUseCaseId ORDER BY CedsConnectionId)
			INTO #allCedsConnections
			FROM [App].[CedsConnections]

			SELECT CedsConnectionId
				,CedsConnectionName
				,CedsUseCaseId
			INTO #uniqueCedsConnections
			FROM #allCedsConnections
			WHERE drank = 1

			SELECT CedsConnectionId
				,CedsConnectionName
				,CedsUseCaseId
			INTO #duplicateCedsConnections
			FROM #allCedsConnections
			WHERE drank > 1

			SELECT [newCedsConnectionId] = u.CedsConnectionId
				,[oldCedsConnectionId] = d.CedsConnectionId
			INTO #mapCedsConnections
			FROM #uniqueCedsConnections u
			INNER JOIN #duplicateCedsConnections d
				ON u.CedsConnectionName = d.CedsConnectionName
					AND u.CedsUseCaseId = d.CedsUseCaseId

			/*Drop tables*/
			DROP TABLE #uniqueCedsConnections
			DROP TABLE #allCedsConnections
			
		/**CedsElements**/
			SELECT CedsElementId
				,CedsTermId
				,[drank] = DENSE_RANK() OVER (PARTITION BY CedsTermId ORDER BY CedsElementId)
			INTO #allCedsElements
			FROM App.CedsElements

			SELECT CedsElementId
				,CedsTermId
			INTO #uniqueCedsElements
			FROM #allCedsElements
			WHERE drank = 1

			SELECT CedsElementId
				,CedsTermId
			INTO #duplicateCedsElements
			FROM #allCedsElements
			WHERE drank > 1

			SELECT [newCedsElementId] = u.CedsElementId
				,[oldCedsElementId] = d.CedsElementId
			INTO #mapCedsElements 
			FROM #uniqueCedsElements u
				INNER JOIN #duplicateCedsElements d
				ON u.CedsTermId = d.CedsTermId

			/*Drop tables*/
			DROP TABLE #uniqueCedsElements
			DROP TABLE #allCedsElements
			
		/**DataMigrationStatuses**/
		/*Throws an error if there are dups in the table*/
		IF EXISTS (
			SELECT DataMigrationStatusCode
			FROM App.DataMigrationStatuses
				GROUP BY DataMigrationStatusCode
				HAVING COUNT(*) > 1
		)
		THROW 51000,'Duplicate records in App.DataMigrationStatuses. This must be manually resolved',1;
		
		/**DataMigrationTypes**/
		/*Throws an error if there are dups in the table*/
		IF EXISTS (
			SELECT DataMigrationTypeCode
			FROM App.DataMigrationTypes
				GROUP BY DataMigrationTypeCode
				HAVING COUNT(*) > 1
		)
		THROW 51001,'Duplicate records in App.DataMigrationTypes. This must be manually resolved',1;
		
		/**DimensionTables**/
			SELECT DimensionTableId
				,DimensionTableName
				,[drank] = DENSE_RANK() OVER (PARTITION BY DimensionTableName ORDER BY DimensionTableId)
			INTO #allDimensionTables
			FROM App.DimensionTables

			SELECT DimensionTableId
				,DimensionTableName
			INTO #uniqueDimensionTables
			FROM #allDimensionTables
			WHERE drank = 1

			SELECT DimensionTableId
				,DimensionTableName
			INTO #duplicateDimensionTables
			FROM #allDimensionTables
			WHERE drank > 1

			SELECT [newDimensionTableId] = u.DimensionTableId
				,[oldDimensionTableId] = d.DimensionTableId
			INTO #mapDimensionTables
			FROM #uniqueDimensionTables u
				INNER JOIN #duplicateDimensionTables d
					ON u.DimensionTableName = d.DimensionTableName

			/*Drop tables*/
			DROP TABLE #uniqueDimensionTables
			DROP TABLE #allDimensionTables
			
		/**FactTables**/
		/*Throws an error if there are dups in the table*/
		IF EXISTS (
			SELECT FactTableName
			FROM App.FactTables
				GROUP BY FactTableName
				HAVING COUNT(*) > 1
		)
		THROW 51002,'Duplicate records in App.FactTables. This must be manually resolved',1;
		
		/**GenerateConfigurations**/
		/*Throws an error if there are dups in the table*/
		IF EXISTS (
			SELECT GenerateConfigurationKey
			FROM App.GenerateConfigurations
				GROUP BY GenerateConfigurationKey
				HAVING COUNT(*) > 1
		)
		THROW 51003,'Duplicate records in App.GenerateConfigurations. This must be manually resolved',1;

		/**GenerateReportControlType**/			
			SELECT GenerateReportControlTypeId
				,ControlTypeName
				,[drank] = DENSE_RANK() OVER (PARTITION BY ControlTypeName ORDER BY GenerateReportControlTypeId)
			INTO #allGenerateReportControlType
			FROM App.GenerateReportControlType

			SELECT GenerateReportControlTypeId
				,ControlTypeName
			INTO #uniqueGenerateReportControlType
			FROM #allGenerateReportControlType
			WHERE drank = 1

			SELECT GenerateReportControlTypeId
				,ControlTypeName
			INTO #duplicateGenerateReportControlType
			FROM #allGenerateReportControlType
			WHERE drank > 1

			SELECT [newGenerateReportControlTypeId] = u.GenerateReportControlTypeId
				,[oldGenerateReportControlTypeId] = d.GenerateReportControlTypeId
			INTO #mapGenerateReportControlType
			FROM #uniqueGenerateReportControlType u
				INNER JOIN #duplicateGenerateReportControlType d
					ON u.ControlTypeName = d.ControlTypeName

			/*Drop tables*/
			DROP TABLE #uniqueGenerateReportControlType
			DROP TABLE #allGenerateReportControlType
			
		/**GenerateReportDisplayTypes**/
			SELECT GenerateReportDisplayTypeId
				,GenerateReportDisplayTypeName
				,[drank] = DENSE_RANK() OVER (PARTITION BY GenerateReportDisplayTypeName ORDER BY GenerateReportDisplayTypeId)
			INTO #allGenerateReportDisplayTypes
			FROM App.GenerateReportDisplayTypes

			SELECT GenerateReportDisplayTypeId
				,GenerateReportDisplayTypeName
			INTO #uniqueGenerateReportDisplayTypes
			FROM #allGenerateReportDisplayTypes
			WHERE drank = 1

			SELECT GenerateReportDisplayTypeId
				,GenerateReportDisplayTypeName
			INTO #duplicateGenerateReportDisplayTypes
			FROM #allGenerateReportDisplayTypes
			WHERE drank > 1

			SELECT [newGenerateReportDisplayTypeId] = u.GenerateReportDisplayTypeId
				,[oldGenerateReportDisplayTypeId] = d.GenerateReportDisplayTypeId
			INTO #mapGenerateReportDisplayTypes
			FROM #uniqueGenerateReportDisplayTypes u
				INNER JOIN #duplicateGenerateReportDisplayTypes d
					ON u.GenerateReportDisplayTypeName = d.GenerateReportDisplayTypeName

			/*Drop tables*/
			DROP TABLE #uniqueGenerateReportDisplayTypes
			DROP TABLE #allGenerateReportDisplayTypes
			
		/**GenerateReportTopics**/
			SELECT GenerateReportTopicId
				,GenerateReportTopicName
				,UserName
				,[drank] = DENSE_RANK() OVER (PARTITION BY GenerateReportTopicName,UserName ORDER BY GenerateReportTopicId)
			INTO #allGenerateReportTopics
			FROM [App].[GenerateReportTopics]

			SELECT GenerateReportTopicId
				,GenerateReportTopicName
				,UserName
			INTO #uniqueGenerateReportTopics
			FROM #allGenerateReportTopics
			WHERE drank = 1

			SELECT GenerateReportTopicId
				,GenerateReportTopicName
				,UserName
			INTO #duplicateGenerateReportTopics
			FROM #allGenerateReportTopics
			WHERE drank > 1

			SELECT [newGenerateReportTopicId] = u.GenerateReportTopicId
				,[oldGenerateReportTopicId] = d.GenerateReportTopicId
			INTO #mapGenerateReportTopics
			FROM #uniqueGenerateReportTopics u
			INNER JOIN #duplicateGenerateReportTopics d
				ON u.GenerateReportTopicName = d.GenerateReportTopicName
					AND u.UserName = d.UserName

			/*Drop tables*/
			DROP TABLE #uniqueGenerateReportTopics
			DROP TABLE #allGenerateReportTopics
		
		/**GenerateReportTypes**/
			SELECT GenerateReportTypeId
				,ReportTypeCode
				,[drank] = DENSE_RANK() OVER (PARTITION BY ReportTypeCode ORDER BY GenerateReportTypeId)
			INTO #allGenerateReportTypes
			FROM App.GenerateReportTypes

			SELECT GenerateReportTypeId
				,ReportTypeCode
			INTO #uniqueGenerateReportTypes
			FROM #allGenerateReportTypes
			WHERE drank = 1

			SELECT GenerateReportTypeId
				,ReportTypeCode
			INTO #duplicateGenerateReportTypes
			FROM #allGenerateReportTypes
			WHERE drank > 1

			SELECT [newGenerateReportTypeId] = u.GenerateReportTypeId
				,[oldGenerateReportTypeId] = d.GenerateReportTypeId
			INTO #mapGenerateReportTypes
			FROM #uniqueGenerateReportTypes u
				INNER JOIN #duplicateGenerateReportTypes d
					ON u.ReportTypeCode = d.ReportTypeCode

			/*Drop tables*/
			DROP TABLE #uniqueGenerateReportTypes
			DROP TABLE #allGenerateReportTypes
			
		/**OrganizationLevels**/
			SELECT OrganizationLevelId
				,LevelCode
				,[drank] = DENSE_RANK() OVER (PARTITION BY LevelCode ORDER BY OrganizationLevelId)
			INTO #allOrganizationLevels
			FROM App.OrganizationLevels

			SELECT OrganizationLevelId
				,LevelCode
			INTO #uniqueOrganizationLevels
			FROM #allOrganizationLevels
			WHERE drank = 1

			SELECT OrganizationLevelId
				,LevelCode
			INTO #duplicateOrganizationLevels
			FROM #allOrganizationLevels
			WHERE drank > 1

			SELECT [newOrganizationLevelId] = u.OrganizationLevelId
				,[oldOrganizationLevelId] = d.OrganizationLevelId
			INTO #mapOrganizationLevels
			FROM #uniqueOrganizationLevels u
				INNER JOIN #duplicateOrganizationLevels d
					ON u.LevelCode = d.LevelCode

			/*Drop tables*/
			DROP TABLE #uniqueOrganizationLevels
			DROP TABLE #allOrganizationLevels
			
		/**SqlUnitTest**/
		/*Not appying unique constraint to this table*/
		
		/**TableTypes**/
			SELECT TableTypeId
				,EdFactsTableTypeId
				,[drank] = DENSE_RANK() OVER (PARTITION BY EdFactsTableTypeId ORDER BY TableTypeId)
			INTO #allTableTypes
			FROM App.TableTypes

			SELECT TableTypeId
				,EdFactsTableTypeId
			INTO #uniqueTableTypes
			FROM #allTableTypes
			WHERE drank = 1

			SELECT TableTypeId
				,EdFactsTableTypeId
			INTO #duplicateTableTypes
			FROM #allTableTypes
			WHERE drank > 1

			SELECT [newTableTypeId] = u.TableTypeId
				,[oldTableTypeId] = d.TableTypeId
			INTO #mapTableTypes
			FROM #uniqueTableTypes u
				INNER JOIN #duplicateTableTypes d
					ON u.EdFactsTableTypeId = d.EdFactsTableTypeId

			/*Drop tables*/
			DROP TABLE #uniqueTableTypes
			DROP TABLE #allTableTypes

/****Layer2****/
	/***Update FK references to Layer1 tables with Layer1 maps***/
		/**CedsConnection_CedsElements**/
			UPDATE cc
			SET CedsElementId = tce.newCedsElementId
			FROM App.CedsConnection_CedsElements cc
				INNER JOIN #mapCedsElements tce ON cc.CedsElementId = tce.oldCedsElementId

			UPDATE cc
			SET CedsConnectionId = tcc.newCedsConnectionId
			FROM App.CedsConnection_CedsElements cc
				INNER JOIN #mapCedsConnections tcc ON cc.CedsConnectionId = tcc.oldCedsConnectionId
		
		/**DataMigrationHistories**/
		/*Nothing to update here*/
		
		/**DataMigrations**/
		/*Nothing to update here*/
		
		/**DataMigrationTasks**/
		/*Nothing to update here*/
		
		/**Dimensions**/
			UPDATE d
			SET DimensionTableId = tdt.newDimensionTableId
			FROM App.Dimensions d
				INNER JOIN #mapDimensionTables tdt ON d.DimensionTableId = tdt.oldDimensionTableId

		/**FactTable_DimensionTables**/
			SELECT DimensionTableId
					,FactTableId
			INTO #tmpFactTable_DimensionTables
			FROM App.FactTable_DimensionTables
			
			UPDATE fd
			SET DimensionTableId = tdt.newDimensionTableId
			FROM #tmpFactTable_DimensionTables fd
				INNER JOIN #mapDimensionTables tdt on fd.DimensionTableId = tdt.oldDimensionTableId
		
		/**GenerateReports**/
			UPDATE gr
			SET GenerateReportControlTypeId = tgrct.newGenerateReportControlTypeId
			FROM App.GenerateReports gr
				INNER JOIN #mapGenerateReportControlType tgrct ON gr.GenerateReportControlTypeId = tgrct.oldGenerateReportControlTypeId

			UPDATE gr
			SET CedsConnectionId = tcc.newCedsConnectionId
			FROM App.GenerateReports gr
				INNER JOIN #mapCedsConnections tcc ON gr.GenerateReportControlTypeId = tcc.oldCedsConnectionId

			UPDATE gr
			SET GenerateReportTypeId = tgrt.newGenerateReportTypeId
			FROM App.GenerateReports gr
				INNER JOIN #mapGenerateReportTypes tgrt ON gr.GenerateReportControlTypeId = tgrt.oldGenerateReportTypeId

		/**ODSElements**/
		/*it doesn't look like this table is used*/
		
	/***
	Map duplicates to earliest PK ID
	For link tables with no surrogate key, record distinct FK pairs and replace the entire table contents
	***/
		/**CedsConnection_CedsElements**/
			IF EXISTS (
				SELECT CedsConnectionId
						,CedsElementId
				FROM App.CedsConnection_CedsElements
					GROUP BY CedsConnectionId
							,CedsElementId
					HAVING COUNT(*) > 1
			)
			THROW 51005,'Duplicate records in App.CedsConnection_CedsElements. This must be manually resolved',1;

		/**DataMigrationHistories**/
		/*Not appying unique constraint to this table*/

		/**DataMigrations**/
		/*Not appying unique constraint to this table*/
		
		/**DataMigrationTasks**/
			SELECT DataMigrationTaskId
				,DataMigrationTypeId
				,StoredProcedureName
				,[drank] = DENSE_RANK() OVER (PARTITION BY DataMigrationTypeId,StoredProcedureName ORDER BY DataMigrationTaskId)
			INTO #allDataMigrationTasks
			FROM [App].[DataMigrationTasks]

			SELECT DataMigrationTaskId
				,DataMigrationTypeId
				,StoredProcedureName
			INTO #uniqueDataMigrationTasks
			FROM #allDataMigrationTasks
			WHERE drank = 1

			SELECT DataMigrationTaskId
				,DataMigrationTypeId
				,StoredProcedureName
			INTO #duplicateDataMigrationTasks
			FROM #allDataMigrationTasks
			WHERE drank > 1

			SELECT [newDataMigrationTaskId] = u.DataMigrationTaskId
				,[oldDataMigrationTaskId] = d.DataMigrationTaskId
			INTO #mapDataMigrationTasks
			FROM #uniqueDataMigrationTasks u
			INNER JOIN #duplicateDataMigrationTasks d
				ON u.DataMigrationTypeId = d.DataMigrationTypeId
					AND u.StoredProcedureName = d.StoredProcedureName

			/*Drop tables*/
			DROP TABLE #uniqueDataMigrationTasks
			DROP TABLE #allDataMigrationTasks
		
		/**Dimensions**/
			SELECT DimensionId
				,DimensionFieldName
				,DimensionTableId
				,[drank] = DENSE_RANK() OVER (PARTITION BY DimensionFieldName,DimensionTableId ORDER BY DimensionId)
			INTO #allDimensions
			FROM App.Dimensions

			SELECT DimensionId
				,DimensionFieldName
				,DimensionTableId
			INTO #uniqueDimensions
			FROM #allDimensions
			WHERE drank = 1

			SELECT DimensionId
				,DimensionFieldName
				,DimensionTableId
			INTO #duplicateDimensions
			FROM #allDimensions
			WHERE drank > 1

			SELECT [newDimensionId] = u.DimensionId
				,[oldDimensionId] = d.DimensionId
			INTO #mapDimensions
			FROM #uniqueDimensions u
				INNER JOIN #duplicateDimensions d
					ON u.DimensionFieldName = d.DimensionFieldName
					AND u.DimensionTableId = d.DimensionTableId

			/*Drop tables*/
			DROP TABLE #uniqueDimensions
			DROP TABLE #allDimensions
			
		/**FactTable_DimensionTables**/
			IF EXISTS (
				SELECT FactTableId
						,DimensionTableId
				FROM #tmpFactTable_DimensionTables
				GROUP BY FactTableId
						,DimensionTableId
				HAVING COUNT(*) > 1
			)
			BEGIN

				--SELECT DISTINCT FactTableId
				--		,DimensionTableId
				--INTO #tmpFactTable_DimensionTables
				--FROM App.FactTable_DimensionTables

				TRUNCATE TABLE App.FactTable_DimensionTables

				INSERT App.FactTable_DimensionTables (
					FactTableId
					,DimensionTableId
				)
				SELECT DISTINCT FactTableId
					,DimensionTableId
				FROM #tmpFactTable_DimensionTables
				
				DROP TABLE #tmpFactTable_DimensionTables
			END

		/**GenerateReports**/
		IF EXISTS (
			SELECT ReportCode
			FROM App.GenerateReports
				GROUP BY ReportCode
				HAVING COUNT(*) > 1
		)
		THROW 51006,'Duplicate records in App.GenerateReports. This must be manually resolved',1;
		
		/**ODSElements**/
		/*it doesn't look like this table is used*/
		
		/**SqlUnitTestCaseResult**/
		/*Not appying unique constraint to this table*/

/****Layer1****/
	/***Delete duplicate records***/
		/**Categories**/
		DELETE App.Categories
		WHERE CategoryId IN (
			SELECT CategoryId FROM #duplicateCategories
		)
		
		DROP TABLE #duplicateCategories
		
		/**CedsConnections**/
		DELETE App.CedsConnections
		WHERE CedsConnectionId IN (
			SELECT CedsConnectionId FROM #duplicateCedsConnections
		)
		
		DROP TABLE #duplicateCedsConnections
		
		/**CedsElements**/
		DELETE App.CedsElements
		WHERE CedsElementId IN (
			SELECT CedsElementId FROM #duplicateCedsElements
		)
		
		DROP TABLE #duplicateCedsElements
		
		/**DataMigrationStatuses**/
		/*NA*/
		
		/**DataMigrationTypes**/
		/*NA*/
		
		/**DimensionTables**/
		DELETE App.DimensionTables
		WHERE DimensionTableId IN (
			SELECT DimensionTableId FROM #duplicateDimensionTables
		)
		
		DROP TABLE #duplicateDimensionTables
		
		/**FactTables**/
		/*NA*/
		
		/**GenerateConfigurations**/
		/*NA*/
		
		/**GenerateReportControlType**/
		DELETE App.GenerateReportControlType
		WHERE GenerateReportControlTypeId IN (
			SELECT GenerateReportControlTypeId FROM #duplicateGenerateReportControlType
		)
		
		DROP TABLE #duplicateGenerateReportControlType
		
		/**GenerateReportDisplayTypes**/
		DELETE App.GenerateReportDisplayTypes
		WHERE GenerateReportDisplayTypeId IN (
			SELECT GenerateReportDisplayTypeId FROM #duplicateGenerateReportDisplayTypes
		)
		
		DROP TABLE #duplicateGenerateReportDisplayTypes

		/**GenerateReportTypes**/
		DELETE App.GenerateReportTypes
		WHERE GenerateReportTypeId IN (
			SELECT GenerateReportTypeId FROM #duplicateGenerateReportTypes
		)
		
		DROP TABLE #duplicateGenerateReportTypes
		
		/**OrganizationLevels**/
		DELETE App.OrganizationLevels
		WHERE OrganizationLevelId IN (
			SELECT OrganizationLevelId FROM #duplicateOrganizationLevels
		)
		
		DROP TABLE #duplicateOrganizationLevels
		
		/**SqlUnitTest**/
		/*NA*/
		
		/**TableTypes**/
		DELETE App.TableTypes
		WHERE TableTypeId IN (
			SELECT TableTypeId FROM #duplicateTableTypes
		)
		
		DROP TABLE #duplicateTableTypes

/****Layer3****/
	/***Update FK references to Layer2 tables with Layer2 maps***/
		/**Category_Dimensions**/
			SELECT CategoryId
					,DimensionId
			INTO #tmpCategory_Dimensions
			FROM App.Category_Dimensions

			UPDATE cd
			SET CategoryId = tc.newCategoryId
			FROM #tmpCategory_Dimensions cd
				INNER JOIN #mapCategories tc ON cd.CategoryId = tc.oldCategoryId

			UPDATE cd
			SET CategoryId = td.newDimensionId
			FROM #tmpCategory_Dimensions cd
				INNER JOIN #mapDimensions td ON cd.DimensionId = td.oldDimensionId
				
		/**CategorySets**/
			UPDATE cs
			SET OrganizationLevelId = tol.newOrganizationLevelId
			FROM App.CategorySets cs
				INNER JOIN #mapOrganizationLevels tol ON cs.OrganizationLevelId = tol.oldOrganizationLevelId
				
			UPDATE cs
			SET TableTypeId = ttt.newTableTypeId
			FROM App.CategorySets cs
				INNER JOIN #mapTableTypes ttt ON cs.TableTypeId = ttt.oldTableTypeId
				
		/**FileColumns**/
			UPDATE fc
			SET DimensionId = td.newDimensionId
			FROM App.FileColumns fc
				INNER JOIN #mapDimensions td ON fc.DimensionId = td.oldDimensionId
				
		/**FileSubmissions**/
			UPDATE fs
			SET OrganizationLevelId = tol.newOrganizationLevelId
			FROM App.FileSubmissions fs
				INNER JOIN #mapOrganizationLevels tol ON fs.OrganizationLevelId = tol.oldOrganizationLevelId
	
		/**GenerateReport_OrganizationLevels**/
			UPDATE grol
			SET OrganizationLevelId = tol.newOrganizationLevelId
			FROM App.GenerateReport_OrganizationLevels grol
				INNER JOIN #mapOrganizationLevels tol ON grol.OrganizationLevelId = tol.oldOrganizationLevelId

		/**GenerateReport_TableType**/
			SELECT GenerateReportId
					,TableTypeId
			INTO #tmpGenerateReport_TableType
			FROM App.GenerateReport_TableType

			UPDATE grtt
			SET TableTypeId = ttt.newTableTypeId
			FROM #tmpGenerateReport_TableType grtt
				INNER JOIN #mapTableTypes ttt ON grtt.TableTypeId = ttt.oldTableTypeId

		/**GenerateReportFilterOptions**/
		/*Nothing to update*/
		
		/**GenerateReportTopic_GenerateReports**/
			SELECT GenerateReportTopicId
					,GenerateReportId
			INTO #tmpGenerateReportTopic_GenerateReports
			FROM App.GenerateReportTopic_GenerateReports
			
			UPDATE grtgr
			SET GenerateReportTopicId = tgrt.newGenerateReportTopicId
			FROM #tmpGenerateReportTopic_GenerateReports grtgr
				INNER JOIN #mapGenerateReportTopics tgrt ON grtgr.GenerateReportTopicId = tgrt.oldGenerateReportTopicId

	/***
	Map duplicates to earliest PK ID
	For link tables with no surrogate key, record distinct FK pairs and replace the entire table contents
	***/
		/**Category_Dimensions**/
			IF EXISTS (
				SELECT CategoryId
						,DimensionId
				FROM #tmpCategory_Dimensions
				GROUP BY CategoryId
						,DimensionId
				HAVING COUNT(*) > 1
			)
			BEGIN
			
				TRUNCATE TABLE App.Category_Dimensions

				INSERT App.Category_Dimensions (
					CategoryId
					,DimensionId
				)
				SELECT DISTINCT CategoryId
					,DimensionId
				FROM #tmpCategory_Dimensions
				
				DROP TABLE #tmpCategory_Dimensions

			END

		/**CategorySets**/
			SELECT CategorySetId
				,GenerateReportId
				,OrganizationLevelId
				,SubmissionYear
				,TableTypeID
				,CategorySetCode,
				[drank] = DENSE_RANK() OVER (
											PARTITION BY GenerateReportId
														,OrganizationLevelId
														,SubmissionYear
														,TableTypeID
														,CategorySetCode 
											ORDER BY CategorySetId
											)
			INTO #allCategorySets
			FROM App.CategorySets

			SELECT CategorySetId
				,GenerateReportId
				,OrganizationLevelId
				,SubmissionYear
				,TableTypeID
				,CategorySetCode
			INTO #uniqueCategorySets
			FROM #allCategorySets
			WHERE drank = 1


			SELECT CategorySetId
				,GenerateReportId
				,OrganizationLevelId
				,SubmissionYear
				,TableTypeID
				,CategorySetCode
			INTO #duplicateCategorySets
			FROM #allCategorySets
			WHERE drank > 1

			SELECT [newCategorySetId] = u.CategorySetId
					,[oldCategorySetId] = d.CategorySetID
			INTO #mapCategorySets
			FROM #uniqueCategorySets u
			INNER JOIN #duplicateCategorySets d
				ON u.GenerateReportId = d.GenerateReportId
				AND u.OrganizationLevelId = d.OrganizationLevelId
				AND u.SubmissionYear = d.SubmissionYear
				AND ISNULL(u.TableTypeId,0) = ISNULL(d.TableTypeId,0)
				AND u.CategorySetCode = d.CategorySetCode

			/*Drop unneeded tables*/
			DROP TABLE #uniqueCategorySets
			DROP TABLE #allCategorySets
			
		/**FileColumns**/
			SELECT FileColumnId
				,ColumnLength
				,ColumnName
				,DataType
				,DimensionId
				,DisplayName
				,XMLElementName
				,[drank] = DENSE_RANK() OVER (PARTITION BY ColumnLength
												,ColumnName
												,DataType
												,DimensionId
												,DisplayName
												,XMLElementName 
												ORDER BY FileColumnId)
			INTO #allFileColumns
			FROM [App].[FileColumns]

			SELECT FileColumnId
				,ColumnLength
				,ColumnName
				,DataType
				,DimensionId
				,DisplayName
				,XMLElementName
			INTO #uniqueFileColumns
			FROM #allFileColumns
			WHERE drank = 1

			SELECT FileColumnId
				,ColumnLength
				,ColumnName
				,DataType
				,DimensionId
				,DisplayName
				,XMLElementName
			INTO #duplicateFileColumns
			FROM #allFileColumns
			WHERE drank > 1

			SELECT [newFileColumnId] = u.FileColumnId
				,[oldFileColumnId] = d.FileColumnId
			INTO #mapFileColumns
			FROM #uniqueFileColumns u
			INNER JOIN #duplicateFileColumns d
				ON u.ColumnLength = d.ColumnLength
					AND u.ColumnName = d.ColumnName
					AND u.DataType = d.DataType
					AND u.DimensionId = d.DimensionId
					AND u.DisplayName = d.DisplayName
					AND u.XMLElementName = d.XMLElementName

			/*Drop tables*/
			DROP TABLE #uniqueFileColumns
			DROP TABLE #allFileColumns
		
		/**FileSubmissions**/
			SELECT FileSubmissionId
				,GenerateReportId
				,OrganizationLevelId
				,SubmissionYear
				,
				[drank] = DENSE_RANK() OVER (
											PARTITION BY GenerateReportId
														,OrganizationLevelId
														,SubmissionYear
														
											ORDER BY FileSubmissionId
											)
			INTO #allFileSubmissions
			FROM App.FileSubmissions

			SELECT FileSubmissionId
				,GenerateReportId
				,OrganizationLevelId
				,SubmissionYear
			INTO #uniqueFileSubmissions
			FROM #allFileSubmissions
			WHERE drank = 1


			SELECT FileSubmissionId
				,GenerateReportId
				,OrganizationLevelId
				,SubmissionYear
			INTO #duplicateFileSubmissions
			FROM #allFileSubmissions
			WHERE drank > 1

			SELECT [newFileSubmissionId] = u.FileSubmissionId
					,[oldFileSubmissionId] = d.FileSubmissionID
			INTO #mapFileSubmissions
			FROM #uniqueFileSubmissions u
			INNER JOIN #duplicateFileSubmissions d
				ON ISNULL(u.GenerateReportId,0) = ISNULL(d.GenerateReportId,0)
				AND ISNULL(u.OrganizationLevelId,0) = ISNULL(d.OrganizationLevelId,0)
				AND ISNULL(u.SubmissionYear,'') = ISNULL(d.SubmissionYear,'')


			/*Drop unneeded tables*/
			DROP TABLE #uniqueFileSubmissions
			DROP TABLE #allFileSubmissions
		
		/**GenerateReport_OrganizationLevels**/
			IF EXISTS (
				SELECT GenerateReportId
						,OrganizationLevelId
				FROM App.GenerateReport_OrganizationLevels
				GROUP BY GenerateReportId
						,OrganizationLevelId
				HAVING COUNT(*) > 1
			)
			BEGIN

				SELECT DISTINCT GenerateReportId
						,OrganizationLevelId
				INTO #tmpGenerateReport_OrganizationLevels
				FROM App.GenerateReport_OrganizationLevels

				TRUNCATE TABLE App.GenerateReport_OrganizationLevels

				INSERT App.GenerateReport_OrganizationLevels (
					GenerateReportId
					,OrganizationLevelId
				)
				SELECT GenerateReportId
					,OrganizationLevelId
				FROM #tmpGenerateReport_OrganizationLevels
				
				DROP TABLE #tmpGenerateReport_OrganizationLevels

			END
			
		/**GenerateReport_TableType**/
			IF EXISTS (
				SELECT GenerateReportId
						,TableTypeId
				FROM #tmpGenerateReport_TableType
				GROUP BY GenerateReportId
						,TableTypeId
				HAVING COUNT(*) > 1
			)
			BEGIN

				--SELECT DISTINCT GenerateReportId
				--		,TableTypeId
				--INTO #tmpGenerateReport_TableType
				--FROM App.GenerateReport_TableType

				TRUNCATE TABLE App.GenerateReport_TableType

				INSERT App.GenerateReport_TableType (
					GenerateReportId
					,TableTypeId
				)
				SELECT DISTINCT GenerateReportId
						,TableTypeId
				FROM #tmpGenerateReport_TableType
				
				DROP TABLE #tmpGenerateReport_TableType

			END
		/**GenerateReportFilterOptions**/
			SELECT GenerateReportFilterOptionId
				,GenerateReportId
				,FilterCode
				,
				[drank] = DENSE_RANK() OVER (
											PARTITION BY GenerateReportId
														,FilterCode
														
											ORDER BY GenerateReportFilterOptionId
											)
			INTO #allGenerateReportFilterOptions
			FROM App.GenerateReportFilterOptions

			SELECT GenerateReportFilterOptionId
				,GenerateReportId
				,FilterCode
			INTO #uniqueGenerateReportFilterOptions
			FROM #allGenerateReportFilterOptions
			WHERE drank = 1


			SELECT GenerateReportFilterOptionId
				,GenerateReportId
				,FilterCode
			INTO #duplicateGenerateReportFilterOptions
			FROM #allGenerateReportFilterOptions
			WHERE drank > 1

			SELECT [newGenerateReportFilterOptionId] = u.GenerateReportFilterOptionId
					,[oldGenerateReportFilterOptionId] = d.GenerateReportFilterOptionId
			INTO #mapGenerateReportFilterOptions
			FROM #uniqueGenerateReportFilterOptions u
			INNER JOIN #duplicateGenerateReportFilterOptions d
				ON u.GenerateReportId = d.GenerateReportId
				AND ISNULL(u.FilterCode,'') = ISNULL(d.FilterCode,'')


			/*Drop unneeded tables*/
			DROP TABLE #uniqueGenerateReportFilterOptions
			DROP TABLE #allGenerateReportFilterOptions

		/**GenerateReportTopic_GenerateReports**/
			IF EXISTS (
				SELECT GenerateReportId
						,GenerateReportTopicId
				FROM #tmpGenerateReportTopic_GenerateReports
				GROUP BY GenerateReportId
						,GenerateReportTopicId
				HAVING COUNT(*) > 1
			)
			BEGIN

				--SELECT DISTINCT GenerateReportId
				--		,GenerateReportTopicId
				--INTO #tmpGenerateReportTopic_GenerateReports
				--FROM App.GenerateReportTopic_GenerateReports

				TRUNCATE TABLE App.GenerateReportTopic_GenerateReports

				INSERT App.GenerateReportTopic_GenerateReports (
					GenerateReportId
					,GenerateReportTopicId
				)
				SELECT DISTINCT GenerateReportId
					,GenerateReportTopicId
				FROM #tmpGenerateReportTopic_GenerateReports
				
				DROP TABLE #tmpGenerateReportTopic_GenerateReports

			END

		
/****Layer2****/
	/***Delete duplicate records***/
		/**CedsConnection_CedsElements**/
		/*NA*/
		
		/**DataMigrationHistories**/
		/*NA*/
		
		/**DataMigrations**/
		/*NA*/
		
		/**DataMigrationTasks**/
			DELETE App.DataMigrationTasks
			WHERE DataMigrationTaskId IN (
				SELECT DataMigrationTaskId FROM #duplicateDataMigrationTasks
			)

			DROP TABLE #duplicateDataMigrationTasks
		
		/**Dimensions**/
			DELETE App.Dimensions
			WHERE DimensionId IN (
				SELECT DimensionId FROM #duplicateDimensions
			)
			
			DROP TABLE #duplicateDimensions
		
		/**FactTable_DimensionTables**/
		/*NA*/
		
		/**GenerateReports**/
		/*NA*/
		
		/**GenerateReportTopics**/
		DELETE App.GenerateReportTopics
		WHERE GenerateReportTopicId IN (
			SELECT GenerateReportTopicId  FROM #duplicateGenerateReportTopics
		)
		
		DROP TABLE #duplicateGenerateReportTopics
		
		/**ODSElements**/
		/*NA*/
		
		/**SqlUnitTestCaseResult**/
		/*NA*/
		

/****Layer4****/
	/***Update FK references to Layer3 tables with Layer3 maps***/
		/**CategoryOptions**/
			UPDATE co
			SET CategoryId = tc.newCategoryId
			FROM App.CategoryOptions co
				INNER JOIN #mapCategories tc ON co.CategoryId = tc.oldCategoryId
				
			UPDATE co
			SET CategorySetId = tcs.newCategorySetId
			FROM App.CategoryOptions co
				INNER JOIN #mapCategorySets tcs ON co.CategorySetId = tcs.oldCategorySetId
				
		/**CategorySet_Categories**/
			print 'Updating App.CategorySet_Categories'
			
			SELECT CategorySetId
					,CategoryId
			INTO #tmpCategorySet_Categories
			FROM App.CategorySet_Categories

			UPDATE csc
			SET CategoryId = tc.newCategoryId
			FROM #tmpCategorySet_Categories csc
				INNER JOIN #mapCategories tc ON csc.CategoryId = tc.oldCategoryId
				
			UPDATE csc
			SET CategorySetId = tcs.newCategorySetId
			FROM #tmpCategorySet_Categories csc
				INNER JOIN #mapCategorySets tcs ON csc.CategorySetId = tcs.oldCategorySetId
		
		/**FileSubmission_FileColumns**/
				SELECT FileSubmissionId
					,FileColumnId
					,StartPosition
					,[EndPosition] 
					,[SequenceNumber] 
					,[IsOptional] 
				INTO #tmpFileSubmission_FileColumns
				FROM App.FileSubmission_FileColumns

			UPDATE fsfc
			SET FileSubmissionId = tfs.newFileSubmissionId
			FROM #tmpFileSubmission_FileColumns fsfc
				INNER JOIN #mapFileSubmissions tfs ON fsfc.FileSubmissionId = tfs.oldFileSubmissionId

			UPDATE fsfc
			SET FileColumnId = tfc.newFileColumnId
			FROM #tmpFileSubmission_FileColumns fsfc
				INNER JOIN #mapFileColumns tfc ON fsfc.FileColumnId = tfc.oldFileColumnId

	/***
	Map duplicates to earliest PK ID
	For link tables with no surrogate key, record distinct FK pairs and replace the entire table contents
	***/
		/**CategoryOptions**/
			SELECT CategoryOptionId
				,CategoryId
				,CategoryOptionCode
				,CategorySetId
				,[drank] = DENSE_RANK() OVER (
											PARTITION BY CategoryId
														,CategoryOptionCode
														,CategorySetId
											ORDER BY CategoryOptionId
											)
			INTO #allCategoryOptions
			FROM App.CategoryOptions

			SELECT CategoryOptionId
				,CategoryId
				,CategoryOptionCode
				,CategorySetId
			INTO #uniqueCategoryOptions
			FROM #allCategoryOptions
			WHERE drank = 1


			SELECT CategoryOptionId
				,CategoryId
				,CategoryOptionCode
				,CategorySetId
			INTO #duplicateCategoryOptions
			FROM #allCategoryOptions
			WHERE drank > 1

			SELECT [newCategoryOptionId] = u.CategoryOptionId
					,[oldCategoryOptionId] = d.CategoryOptionId
			INTO #mapCategoryOptions
			FROM #uniqueCategoryOptions u
			INNER JOIN #duplicateCategoryOptions d
				ON u.CategoryId = d.CategoryId
				AND u.CategoryOptionCode = d.CategoryOptionCode
				AND ISNULL(u.CategorySetId,0) = ISNULL(d.CategorySetId,0)


			/*Drop unneeded tables*/
			DROP TABLE #uniqueCategoryOptions
			DROP TABLE #allCategoryOptions
			
		/**CategorySet_Categories**/
			print 'Consolidating App.CategorySet_Categories'

			IF EXISTS (
				SELECT CategoryId
						,CategorySetId
				FROM #tmpCategorySet_Categories
				GROUP BY CategoryId
						,CategorySetId
				HAVING COUNT(*) > 1
			)
			BEGIN

				--SELECT DISTINCT CategoryId
				--		,CategorySetId
				--INTO #tmpCategorySet_Categories
				--FROM App.CategorySet_Categories

				TRUNCATE TABLE App.CategorySet_Categories

				INSERT App.CategorySet_Categories (
					CategoryId
					,CategorySetId
				)
				SELECT DISTINCT CategoryId
					,CategorySetId
				FROM #tmpCategorySet_Categories
				
				DROP TABLE #tmpCategorySet_Categories

			END
		
		/**FileSubmission_FileColumns**/
			IF EXISTS (
				SELECT FileSubmissionId
						,FileColumnId
						,StartPosition
				FROM #tmpFileSubmission_FileColumns
				GROUP BY FileSubmissionId
						,FileColumnId
						,StartPosition
				HAVING COUNT(*) > 1
			)
			BEGIN

				TRUNCATE TABLE App.FileSubmission_FileColumns

				INSERT INTO App.FileSubmission_FileColumns (
					FileSubmissionId
					,FileColumnId
					,StartPosition
					,[EndPosition]
					,[SequenceNumber]
					,[IsOptional]
				)
				SELECT FileSubmissionId
					,FileColumnId
					,StartPosition
					,[EndPosition] = MIN(EndPosition)
					,[SequenceNumber] = MIN(SequenceNumber)
					,[IsOptional] = MIN(CASE IsOptional WHEN 0 THEN 0 ELSE 1 END)
				FROM #tmpFileSubmission_FileColumns
				GROUP BY FileSubmissionId
					,FileColumnId
					,StartPosition

				DROP TABLE #tmpFileSubmission_FileColumns

			END

/****Layer3****/
	/***Delete duplicate records***/
		/**Category_Dimensions**/
		/*NA*/
		
		/**CategorySets**/
			DELETE App.CategorySets
			WHERE CategorySetId IN (
				SELECT CategorySetId FROM #duplicateCategorySets
			)
			
			DROP TABLE #duplicateCategorySets
			
		/**FileColumns**/
			DELETE App.FileColumns
			WHERE FileColumnId IN (
				SELECT FileColumnId FROM #duplicateFileColumns
			)

			DROP TABLE #duplicateFileColumns
		
		/**FileSubmissions**/
			DELETE App.FileSubmissions
			WHERE FileSubmissionId IN (
				SELECT FileSubmissionId FROM #duplicateFileSubmissions
			)
			
			DROP TABLE #duplicateFileSubmissions
		
		/**GenerateReport_OrganizationLevels**/
		/*NA*/
		
		/**GenerateReport_TableType**/
		/*NA*/
		
		/**GenerateReportFilterOptions**/
			DELETE App.GenerateReportFilterOptions
			WHERE GenerateReportFilterOptionId IN (
				SELECT GenerateReportFilterOptionId FROM #duplicateGenerateReportFilterOptions
			)
			
			DROP TABLE #duplicateGenerateReportFilterOptions
		
		/**GenerateReportTopic_GenerateReports**/
		/*NA*/
		

/****Layer4****/
	/***Delete duplicate records***/
		/**CategoryOptions**/
			DELETE App.CategoryOptions
			WHERE CategoryOptionId IN (
				SELECT CategoryOptionId FROM #duplicateCategoryOptions
			)
			
			DROP TABLE #duplicateCategoryOptions
			
		/**CategorySet_Categories**/
		/*NA*/
		
		/**FileSubmission_FileColumns**/
		/*NA*/


-------------------------------------------------------------------
/****ToggleLayer1****/
	/***Map duplicates to earliest PK ID***/
		/**ToggleAssessments**/
			SELECT ToggleAssessmentId
				,AssessmentTypeCode
				,Grade
				,[Subject]
				,[drank] = DENSE_RANK() OVER (PARTITION BY AssessmentTypeCode,Grade,[Subject] ORDER BY ToggleAssessmentId)
			INTO #allToggleAssessments
			FROM [App].[ToggleAssessments] 

			SELECT ToggleAssessmentId
				,AssessmentTypeCode
				,Grade
				,[Subject]
			INTO #uniqueToggleAssessments
			FROM #allToggleAssessments
			WHERE drank = 1

			SELECT ToggleAssessmentId
				,AssessmentTypeCode
				,Grade
				,[Subject]
			INTO #duplicateToggleAssessments
			FROM #allToggleAssessments
			WHERE drank > 1

			SELECT [newToggleAssessmentId] = u.ToggleAssessmentId
				,[oldToggleAssessmentId] = d.ToggleAssessmentId
			INTO #mapToggleAssessments
			FROM #uniqueToggleAssessments u
			INNER JOIN #duplicateToggleAssessments d
				ON u.AssessmentTypeCode = d.AssessmentTypeCode
					AND u.Grade = d.Grade
					AND u.[Subject] = d.[Subject] 

			/*Drop tables*/
			DROP TABLE #uniqueToggleAssessments
			DROP TABLE #allToggleAssessments

		/**ToggleQuestionTypes**/
			SELECT ToggleQuestionTypeId
				,ToggleQuestionTypeCode
				,[drank] = DENSE_RANK() OVER (PARTITION BY ToggleQuestionTypeCode ORDER BY ToggleQuestionTypeId)
			INTO #allToggleQuestionTypes
			FROM [App].[ToggleQuestionTypes] 

			SELECT ToggleQuestionTypeId
				,ToggleQuestionTypeCode
			INTO #uniqueToggleQuestionTypes
			FROM #allToggleQuestionTypes
			WHERE drank = 1

			SELECT ToggleQuestionTypeId
				,ToggleQuestionTypeCode
			INTO #duplicateToggleQuestionTypes
			FROM #allToggleQuestionTypes
			WHERE drank > 1

			SELECT [newToggleQuestionTypeId] = u.ToggleQuestionTypeId
				,[oldToggleQuestionTypeId] = d.ToggleQuestionTypeId
			INTO #mapToggleQuestionTypes
			FROM #uniqueToggleQuestionTypes u
			INNER JOIN #duplicateToggleQuestionTypes d
				ON u.ToggleQuestionTypeCode = d.ToggleQuestionTypeCode

			/*Drop tables*/
			DROP TABLE #uniqueToggleQuestionTypes
			DROP TABLE #allToggleQuestionTypes
		/**ToggleSectionTypes**/
			SELECT ToggleSectionTypeId
				,EmapsSurveyTypeAbbrv
				,[drank] = DENSE_RANK() OVER (PARTITION BY EmapsSurveyTypeAbbrv ORDER BY ToggleSectionTypeId)
			INTO #allToggleSectionTypes
			FROM [App].[ToggleSectionTypes] 

			SELECT ToggleSectionTypeId
				,EmapsSurveyTypeAbbrv
			INTO #uniqueToggleSectionTypes
			FROM #allToggleSectionTypes
			WHERE drank = 1

			SELECT ToggleSectionTypeId
				,EmapsSurveyTypeAbbrv
			INTO #duplicateToggleSectionTypes
			FROM #allToggleSectionTypes
			WHERE drank > 1

			SELECT [newToggleSectionTypeId] = u.ToggleSectionTypeId
				,[oldToggleSectionTypeId] = d.ToggleSectionTypeId
			INTO #mapToggleSectionTypes
			FROM #uniqueToggleSectionTypes u
			INNER JOIN #duplicateToggleSectionTypes d
				ON u.EmapsSurveyTypeAbbrv = d.EmapsSurveyTypeAbbrv

			/*Drop tables*/
			DROP TABLE #uniqueToggleSectionTypes
			DROP TABLE #allToggleSectionTypes

/****ToggleLayer2****/
	/***Update FK references to ToggleLayer1 tables with ToggleLayer1 maps***/
		/**ToggleSections**/
			UPDATE ts
			SET ToggleSectionTypeId = ttst.newToggleSectionTypeId
			FROM App.ToggleSections ts
				INNER JOIN #mapToggleSectionTypes ttst ON ts.ToggleSectionTypeId = ttst.oldToggleSectionTypeId


	/***
	Map duplicates to earliest PK ID
	For link tables with no surrogate key, record distinct FK pairs and replace the entire table contents
	***/
		/**ToggleSections**/
			SELECT ToggleSectionId
				,EmapsSurveySectionAbbrv
				,[drank] = DENSE_RANK() OVER (PARTITION BY EmapsSurveySectionAbbrv ORDER BY ToggleSectionId)
			INTO #allToggleSections
			FROM [App].[ToggleSections] 

			SELECT ToggleSectionId
				,EmapsSurveySectionAbbrv
			INTO #uniqueToggleSections
			FROM #allToggleSections
			WHERE drank = 1

			SELECT ToggleSectionId
				,EmapsSurveySectionAbbrv
			INTO #duplicateToggleSections
			FROM #allToggleSections
			WHERE drank > 1

			SELECT [newToggleSectionId] = u.ToggleSectionId
				,[oldToggleSectionId] = d.ToggleSectionId
			INTO #mapToggleSections
			FROM #uniqueToggleSections u
			INNER JOIN #duplicateToggleSections d
				ON u.EmapsSurveySectionAbbrv = d.EmapsSurveySectionAbbrv

			/*Drop tables*/
			DROP TABLE #uniqueToggleSections
			DROP TABLE #allToggleSections

/****ToggleLayer3 - these last 3 tables refer internally to one another****/
	/***Update FK references to ToggleLayer2 tables with ToggleLayer2 maps***/
		/**ToggleQuestions**/
			UPDATE tq
			SET ToggleQuestionTypeId = ttqt.newToggleQuestionTypeId
			FROM App.ToggleQuestions tq
				INNER JOIN #mapToggleQuestionTypes ttqt ON tq.ToggleQuestionTypeId = ttqt.oldToggleQuestionTypeId

			UPDATE tq
			SET ToggleSectionId = tts.newToggleSectionId
			FROM App.ToggleQuestions tq
				INNER JOIN #mapToggleSections tts ON tq.ToggleSectionId = tts.oldToggleSectionId

		/**ToggleResponses**/
		/*NA*/

		/**ToggleQuestionOptions**/
		/*NA*/
	/***
	Map duplicates to earliest PK ID
	For link tables with no surrogate key, record distinct FK pairs and replace the entire table contents
	***/
		/**ToggleQuestions**/
			SELECT ToggleQuestionId
				,EmapsQuestionAbbrv
				,[drank] = DENSE_RANK() OVER (PARTITION BY EmapsQuestionAbbrv ORDER BY ToggleQuestionId)
			INTO #allToggleQuestions
			FROM [App].[ToggleQuestions] 

			SELECT ToggleQuestionId
				,EmapsQuestionAbbrv
			INTO #uniqueToggleQuestions
			FROM #allToggleQuestions
			WHERE drank = 1

			SELECT ToggleQuestionId
				,EmapsQuestionAbbrv
			INTO #duplicateToggleQuestions
			FROM #allToggleQuestions
			WHERE drank > 1

			SELECT [newToggleQuestionId] = u.ToggleQuestionId
				,[oldToggleQuestionId] = d.ToggleQuestionId
			INTO #mapToggleQuestions
			FROM #uniqueToggleQuestions u
			INNER JOIN #duplicateToggleQuestions d
				ON u.EmapsQuestionAbbrv = d.EmapsQuestionAbbrv

			UPDATE tq
			SET ParentToggleQuestionId = newToggleQuestionId
			FROM App.ToggleQuestions tq
				INNER JOIN #mapToggleQuestions mtq ON tq.ParentToggleQuestionId = mtq.oldToggleQuestionId

			/*Drop tables*/
			DROP TABLE #uniqueToggleQuestions
			DROP TABLE #allToggleQuestions
		
		/**ToggleResponses**/
		/*NA*/
		
		/**ToggleQuestionOptions**/
		/*NA*/

	/***Update FK references to ToggleLayer3 tables with ToggleLayer3 maps***/
		/**ToggleResponses**/
		/*NA*/

		/**ToggleQuestions**/
		/*NA*/

		/**ToggleQuestionOptions**/
			UPDATE tqo
			SET ToggleQuestionId = ttq.newToggleQuestionId
			FROM App.ToggleQuestionOptions tqo
				INNER JOIN #mapToggleQuestions ttq ON tqo.ToggleQuestionId = ttq.oldToggleQuestionId

	/***
	Map duplicates to earliest PK ID
	For link tables with no surrogate key, record distinct FK pairs and replace the entire table contents
	***/
		/**ToggleResponses**/
		/*NA*/

		/**ToggleQuestions**/
		/*NA*/

		/**ToggleQuestionOptions**/
			SELECT ToggleQuestionOptionId
				,OptionText
				,ToggleQuestionId
				,[drank] = DENSE_RANK() OVER (PARTITION BY OptionText,ToggleQuestionId ORDER BY ToggleQuestionOptionId)
			INTO #allToggleQuestionOptions
			FROM [App].[ToggleQuestionOptions] 

			SELECT ToggleQuestionOptionId
				,OptionText
				,ToggleQuestionId
			INTO #uniqueToggleQuestionOptions
			FROM #allToggleQuestionOptions
			WHERE drank = 1

			SELECT ToggleQuestionOptionId
				,OptionText
				,ToggleQuestionId
			INTO #duplicateToggleQuestionOptions
			FROM #allToggleQuestionOptions
			WHERE drank > 1

			SELECT [newToggleQuestionOptionId] = u.ToggleQuestionOptionId
				,[oldToggleQuestionOptionId] = d.ToggleQuestionOptionId
			INTO #mapToggleQuestionOptions
			FROM #uniqueToggleQuestionOptions u
			INNER JOIN #duplicateToggleQuestionOptions d
				ON u.OptionText = d.OptionText
				AND u.ToggleQuestionId = d.ToggleQuestionId

			/*Drop tables*/
			DROP TABLE #uniqueToggleQuestionOptions
			DROP TABLE #allToggleQuestionOptions

	/***Update FK references to ToggleLayer3 tables with ToggleLayer3 maps***/
		/**ToggleResponses**/
		UPDATE tr
		SET ToggleQuestionId = ttq.newToggleQuestionId
		FROM App.ToggleResponses tr
			INNER JOIN #mapToggleQuestions ttq ON tr.ToggleQuestionId = ttq.oldToggleQuestionId

		UPDATE tr
		SET ToggleQuestionOptionId = ttqo.newToggleQuestionOptionId
		FROM App.ToggleResponses tr
			INNER JOIN #mapToggleQuestionOptions ttqo ON tr.ToggleQuestionOptionId = ttqo.oldToggleQuestionOptionId

		/**ToggleQuestions**/
		/*NA*/

		/**ToggleQuestionOptions**/
		/*NA*/


	/***
	Map duplicates to earliest PK ID
	For link tables with no surrogate key, record distinct FK pairs and replace the entire table contents
	***/
		/**ToggleResponses**/
			SELECT ToggleResponseId
				,ToggleQuestionOptionId
				,ToggleQuestionId
				,[drank] = DENSE_RANK() OVER (PARTITION BY ToggleQuestionOptionId,ToggleQuestionId ORDER BY ToggleResponseId)
			INTO #allToggleResponses
			FROM [App].[ToggleResponses] 

			SELECT ToggleResponseId
				,ToggleQuestionOptionId
				,ToggleQuestionId
			INTO #uniqueToggleResponses
			FROM #allToggleResponses
			WHERE drank = 1

			SELECT ToggleResponseId
				,ToggleQuestionOptionId
				,ToggleQuestionId
			INTO #duplicateToggleResponses
			FROM #allToggleResponses
			WHERE drank > 1

			SELECT [newToggleResponseId] = u.ToggleResponseId
				,[oldToggleResponseId] = d.ToggleResponseId
			INTO #mapToggleResponses
			FROM #uniqueToggleResponses u
			INNER JOIN #duplicateToggleResponses d
				ON ISNULL(u.ToggleQuestionOptionId,0) = ISNULL(d.ToggleQuestionOptionId,0)
				AND u.ToggleQuestionId = d.ToggleQuestionId

			/*Drop tables*/
			DROP TABLE #uniqueToggleResponses
			DROP TABLE #allToggleResponses

		/**ToggleQuestions**/
		/*NA*/

		/**ToggleQuestionOptions**/
		/*NA*/
		
		/*Remove duplicate records*/
		DELETE App.ToggleAssessments
		WHERE ToggleAssessmentId IN (
			SELECT ToggleAssessmentId FROM #duplicateToggleAssessments
		)
		
		DROP TABLE #duplicateToggleAssessments

		DELETE App.ToggleQuestionTypes
		WHERE ToggleQuestionTypeId IN (
			SELECT ToggleQuestionTypeId FROM #duplicateToggleQuestionTypes
		)

		DROP TABLE #duplicateToggleQuestionTypes

		DELETE App.ToggleSectionTypes
		WHERE ToggleSectionTypeId IN (
			SELECT ToggleSectionTypeId FROM #duplicateToggleSectionTypes
		)

		DROP TABLE #duplicateToggleSectionTypes

		DELETE App.ToggleSections
		WHERE ToggleSectionId IN (
			SELECT ToggleSectionId FROM #duplicateToggleSections
		)

		DROP TABLE #duplicateToggleSections

		DELETE App.ToggleQuestions
		WHERE ToggleQuestionId IN (
			SELECT ToggleQuestionId FROM #duplicateToggleQuestions
		)

		DROP TABLE #duplicateToggleQuestions

		DELETE App.ToggleResponses
		WHERE ToggleResponseId IN (
			SELECT ToggleResponseId FROM #duplicateToggleResponses
		)

		DROP TABLE #duplicateToggleResponses

		DELETE App.ToggleQuestionOptions
		WHERE ToggleQuestionOptionId IN (
			SELECT ToggleQuestionOptionId FROM #duplicateToggleQuestionOptions
		)

		DROP TABLE #duplicateToggleQuestionOptions

		/*Drop map tables*/
		DROP TABLE #mapCategories
		DROP TABLE #mapCategoryOptions
		DROP TABLE #mapCategorySets
		DROP TABLE #mapCedsConnections
		DROP TABLE #mapCedsElements
		DROP TABLE #mapDataMigrationTasks
		DROP TABLE #mapDimensions
		DROP Table #mapDimensionTables
		DROP TABLE #mapFileColumns
		DROP TABLE #mapFileSubmissions
		DROP TABLE #mapGenerateReportControlType
		DROP TABLE #mapGenerateReportDisplayTypes
		DROP TABLE #mapGenerateReportFilterOptions
		DROP TABLE #mapGenerateReportTopics
		DROP TABLE #mapGenerateReportTypes
		DROP TABLE #mapOrganizationLevels
		DROP TABLE #mapTableTypes
		DROP TABLE #mapToggleAssessments
		DROP TABLE #mapToggleQuestionOptions
		DROP TABLE #mapToggleQuestions
		DROP TABLE #mapToggleQuestionTypes
		DROP TABLE #mapToggleResponses
		DROP Table #mapToggleSections
		DROP TABLE #mapToggleSectionTypes

/****Create unique constraints****/

		/**Categories**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'Categories'
				AND i.name = 'UX_Categories'
			)
			ALTER TABLE App.Categories
			ADD CONSTRAINT UX_Categories 
			UNIQUE (
				CategoryCode
				,EdFactsCategoryId
				);
		/**CedsConnections**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'CedsConnections'
				AND i.name = 'UX_CedsConnections'
			)
			ALTER TABLE App.CedsConnections
			ADD CONSTRAINT UX_CedsConnections 
			UNIQUE (
				CedsConnectionName
				,CedsUseCaseId
				);

		/**CedsElements**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'CedsElements'
				AND i.name = 'UX_CedsElements'
			)
			ALTER TABLE App.CedsElements
			ADD CONSTRAINT UX_CedsElements 
			UNIQUE (
				CedsTermId
				);

		/**DataMigrationStatuses**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'DataMigrationStatuses'
				AND i.name = 'UX_DataMigrationStatuses'
			)
			ALTER TABLE App.DataMigrationStatuses
			ADD CONSTRAINT UX_DataMigrationStatuses 
			UNIQUE (
				DataMigrationStatusCode
				);

		/**DataMigrationTypes**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'DataMigrationTypes'
				AND i.name = 'UX_DataMigrationTypes'
			)
			ALTER TABLE App.DataMigrationTypes
			ADD CONSTRAINT UX_DataMigrationTypes 
			UNIQUE (
				DataMigrationTypeCode
				);

		/**DimensionTables**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'DimensionTables'
				AND i.name = 'UX_DimensionTables'
			)
			ALTER TABLE App.DimensionTables
			ADD CONSTRAINT UX_DimensionTables 
			UNIQUE (
				DimensionTableName
				);

		/**FactTables**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'FactTables'
				AND i.name = 'UX_FactTables'
			)
			ALTER TABLE App.FactTables
			ADD CONSTRAINT UX_FactTables 
			UNIQUE (
				FactTableName
				);

		/**GenerateConfigurations**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'GenerateConfigurations'
				AND i.name = 'UX_GenerateConfigurations'
			)
			ALTER TABLE App.GenerateConfigurations
			ADD CONSTRAINT UX_GenerateConfigurations 
			UNIQUE (
				GenerateConfigurationKey
				);

		/**GenerateReportControlType**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'GenerateReportControlType'
				AND i.name = 'UX_GenerateReportControlType'
			)
			ALTER TABLE App.GenerateReportControlType
			ADD CONSTRAINT UX_GenerateReportControlType 
			UNIQUE (
				ControlTypeName
				);

		/**GenerateReportDisplayTypes**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'GenerateReportDisplayTypes'
				AND i.name = 'UX_GenerateReportDisplayTypes'
			)
			ALTER TABLE App.GenerateReportDisplayTypes
			ADD CONSTRAINT UX_GenerateReportDisplayTypes 
			UNIQUE (
				GenerateReportDisplayTypeName
				);

		/**GenerateReportTopics**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'GenerateReportTopics'
				AND i.name = 'UX_GenerateReportTopics'
			)
			ALTER TABLE App.GenerateReportTopics
			ADD CONSTRAINT UX_GenerateReportTopics 
			UNIQUE (
				GenerateReportTopicName
				,UserName
				);

		/**GenerateReportTypes**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'GenerateReportTypes'
				AND i.name = 'UX_GenerateReportTypes'
			)
			ALTER TABLE App.GenerateReportTypes
			ADD CONSTRAINT UX_GenerateReportTypes 
			UNIQUE (
				ReportTypeCode
				);

		/**OrganizationLevels**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'OrganizationLevels'
				AND i.name = 'UX_OrganizationLevels'
			)
			ALTER TABLE App.OrganizationLevels
			ADD CONSTRAINT UX_OrganizationLevels 
			UNIQUE (
				LevelCode
				);

		/**SqlUnitTest**/
		/*NONE*/

		/**TableTypes**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'TableTypes'
				AND i.name = 'UX_TableTypes'
			)
			ALTER TABLE App.TableTypes
			ADD CONSTRAINT UX_TableTypes 
			UNIQUE (
				EdFactsTableTypeId
				);

		/**CedsConnection_CedsElements**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'CedsConnection_CedsElements'
				AND i.name = 'UX_CedsConnection_CedsElements'
			)
			ALTER TABLE App.CedsConnection_CedsElements
			ADD CONSTRAINT UX_CedsConnection_CedsElements 
			UNIQUE (
				CedsConnectionId
				,CedsElementId
				);

		/**DataMigrationHistories**/
		/*NONE*/

		/**DataMigrations**/
		/*NONE*/

		/**DataMigrationTasks**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'DataMigrationTasks'
				AND i.name = 'UX_DataMigrationTasks'
			)
			ALTER TABLE App.DataMigrationTasks
			ADD CONSTRAINT UX_DataMigrationTasks 
			UNIQUE (
				DataMigrationTypeId
				,StoredProcedureName
				);

		/**Dimensions**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'Dimensions'
				AND i.name = 'UX_Dimensions'
			)
			ALTER TABLE App.Dimensions
			ADD CONSTRAINT UX_Dimensions 
			UNIQUE (
				DimensionFieldName
				,DimensionTableId
				);

		/**FactTable_DimensionTables**/
		/*Already constrained by PK*/

		/**GenerateReports**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'GenerateReports'
				AND i.name = 'UX_GenerateReports'
			)
			ALTER TABLE App.GenerateReports
			ADD CONSTRAINT UX_GenerateReports 
			UNIQUE (
				ReportCode
				);

		/**ODSElements**/
		/*NONE*/

		/**SqlUnitTestCaseResult**/
		/*NONE*/

		/**Category_Dimensions**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'Category_Dimensions'
				AND i.name = 'UX_Category_Dimensions'
			)
			ALTER TABLE App.Category_Dimensions
			ADD CONSTRAINT UX_Category_Dimensions 
			UNIQUE (
				CategoryId
				,DimensionId
				);

		/**CategorySets**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'CategorySets'
				AND i.name = 'UX_CategorySets'
			)
			ALTER TABLE App.CategorySets
			ADD CONSTRAINT UX_CategorySets 
			UNIQUE (
				GenerateReportId
				,OrganizationLevelId
				,SubmissionYear
				,TableTypeID
				,CategorySetCode
				);

		/**FileColumns**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'FileColumns'
				AND i.name = 'UX_FileColumns'
			)
			ALTER TABLE App.FileColumns
			ADD CONSTRAINT UX_FileColumns 
			UNIQUE (
				ColumnLength
				,ColumnName
				,DataType
				,DimensionId
				,DisplayName
				,XMLElementName
				);

		/**FileSubmissions**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'FileSubmissions'
				AND i.name = 'UX_FileSubmissions'
			)
			ALTER TABLE App.FileSubmissions
			ADD CONSTRAINT UX_FileSubmissions 
			UNIQUE (
				GenerateReportId
				,OrganizationLevelId
				,SubmissionYear
				);

		/**GenerateReport_OrganizationLevels**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'GenerateReport_OrganizationLevels'
				AND i.name = 'UX_GenerateReport_OrganizationLevels'
			)
			ALTER TABLE App.GenerateReport_OrganizationLevels
			ADD CONSTRAINT UX_GenerateReport_OrganizationLevels 
			UNIQUE (
				GenerateReportId
				,OrganizationLevelId
				);

		/**GenerateReport_TableType**/
			/*UX already enforced by PK*/

		/**GenerateReportFilterOptions**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'GenerateReportFilterOptions'
				AND i.name = 'UX_GenerateReportFilterOptions'
			)
			ALTER TABLE App.GenerateReportFilterOptions
			ADD CONSTRAINT UX_GenerateReportFilterOptions 
			UNIQUE (
				GenerateReportId
				,FilterCode
				);

		/**GenerateReportTopic_GenerateReports**/
			/*UX already enforced by PK*/

		/**CategoryOptions**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'CategoryOptions'
				AND i.name = 'UX_CategoryOptions'
			)
			ALTER TABLE App.CategoryOptions
			ADD CONSTRAINT UX_CategoryOptions 
			UNIQUE (
				CategoryId
				,CategoryOptionCode
				,CategorySetId
				);

		/**CategorySet_Categories**/
		/*UX already enforced by PK*/

		/**FileSubmission_FileColumns**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'FileSubmission_FileColumns'
				AND i.name = 'UX_FileSubmission_FileColumns'
			)
			ALTER TABLE App.FileSubmission_FileColumns
			ADD CONSTRAINT UX_FileSubmission_FileColumns 
			PRIMARY KEY (
				FileSubmissionId
				,FileColumnId
				,StartPosition
				);

		/**ToggleAssessments**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'ToggleAssessments'
				AND i.name = 'UX_ToggleAssessments'
			)
			ALTER TABLE App.ToggleAssessments
			ADD CONSTRAINT UX_ToggleAssessments 
			UNIQUE (
				AssessmentTypeCode
				,Grade
				,[Subject]
				);

		/**ToggleQuestionTypes**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'ToggleQuestionTypes'
				AND i.name = 'UX_ToggleQuestionTypes'
			)
			ALTER TABLE App.ToggleQuestionTypes
			ADD CONSTRAINT UX_ToggleQuestionTypes 
			UNIQUE (
				ToggleQuestionTypeCode
				);

		/**ToggleSectionTypes**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'ToggleSectionTypes'
				AND i.name = 'UX_ToggleSectionTypes'
			)
			ALTER TABLE App.ToggleSectionTypes
			ADD CONSTRAINT UX_ToggleSectionTypes 
			UNIQUE (
				EmapsSurveyTypeAbbrv
				);

		/**ToggleSections**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'ToggleSections'
				AND i.name = 'UX_ToggleSections'
			)
			ALTER TABLE App.ToggleSections
			ADD CONSTRAINT UX_ToggleSections 
			UNIQUE (
				EmapsSurveySectionAbbrv
				);

		/**ToggleQuestions**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'ToggleQuestions'
				AND i.name = 'UX_ToggleQuestions'
			)
			ALTER TABLE App.ToggleQuestions
			ADD CONSTRAINT UX_ToggleQuestions 
			UNIQUE (
				EmapsQuestionAbbrv
				);

		/**ToggleResponses**/
			IF NOT EXISTS (
				SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
				WHERE t.name = 'ToggleResponses'
				AND i.name = 'UX_ToggleResponses'
			)
			ALTER TABLE App.ToggleResponses
			ADD CONSTRAINT UX_ToggleResponses 
			UNIQUE (
				ToggleQuestionId
				,ToggleQuestionOptionId
				);

		/**ToggleQuestionOptions**/
		/*OptionText is nvarchar(max), so it isn't a candidate for UX*/
			--IF NOT EXISTS (
			--	SELECT 1 FROM sys.tables t inner join sys.indexes i on t.object_id = i.object_id
			--	WHERE t.name = 'ToggleQuestionOptions'
			--	AND i.name = 'UX_ToggleQuestionOptions'
			--)
			--ALTER TABLE App.ToggleQuestionOptions
			--ADD CONSTRAINT UX_ToggleQuestionOptions 
			--UNIQUE (
			--	OptionText
			--	,ToggleQuestionId
			--	);
commit transaction
end try
 
begin catch
	IF @@TRANCOUNT > 0
	begin
		rollback transaction
	end
	declare @msg as nvarchar(max)
	set @msg = ERROR_MESSAGE()
	declare @sev as int
	set @sev = ERROR_SEVERITY()
	RAISERROR(@msg, @sev, 1)
end catch
 
set nocount off