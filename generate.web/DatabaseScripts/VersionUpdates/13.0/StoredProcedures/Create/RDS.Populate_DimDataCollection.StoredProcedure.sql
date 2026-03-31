CREATE PROCEDURE [RDS].[Populate_DimDataCollections]
	@SchoolYear SMALLINT = NULL
AS

	WITH dc AS (
		SELECT DISTINCT
			  [SourceSystemDataCollectionIdentifier]
			, [SourceSystemName]                
			, [DataCollectionName]              
			, [DataCollectionDescription]       
			, [DataCollectionOpenDate]          
			, [DataCollectionCloseDate]         
			, [DataCollectionAcademicSchoolYear]
			, [DataCollectionSchoolYear]        
		FROM dbo.DataCollection
	)
	MERGE RDS.DimDataCollections AS trgt
	USING dc AS src
		ON trgt.[DataCollectionName] = src.[DataCollectionName]              
	WHEN MATCHED THEN
		UPDATE SET 
			  [SourceSystemDataCollectionIdentifier] = src.[SourceSystemDataCollectionIdentifier]    
			, [SourceSystemName]                	 = src.[SourceSystemName]                
			, [DataCollectionName]              	 = src.[DataCollectionName]              
			, [DataCollectionDescription]       	 = src.[DataCollectionDescription]       
			, [DataCollectionOpenDate]          	 = src.[DataCollectionOpenDate]          
			, [DataCollectionCloseDate]         	 = src.[DataCollectionCloseDate]         
			, [DataCollectionAcademicSchoolYear]	 = src.[DataCollectionAcademicSchoolYear]
			, [DataCollectionSchoolYear]         	 = src.[DataCollectionSchoolYear]        
	WHEN NOT MATCHED THEN
		INSERT (
			  [SourceSystemDataCollectionIdentifier]    
			, [SourceSystemName]                
			, [DataCollectionName]              
			, [DataCollectionDescription]       
			, [DataCollectionOpenDate]          
			, [DataCollectionCloseDate]         
			, [DataCollectionAcademicSchoolYear]
			, [DataCollectionSchoolYear]         
			)
		VALUES (
			  src.[SourceSystemDataCollectionIdentifier]    
			, src.[SourceSystemName]                
			, src.[DataCollectionName]              
			, src.[DataCollectionDescription]       
			, src.[DataCollectionOpenDate]          
			, src.[DataCollectionCloseDate]         
			, src.[DataCollectionAcademicSchoolYear]
			, src.[DataCollectionSchoolYear]        
			);