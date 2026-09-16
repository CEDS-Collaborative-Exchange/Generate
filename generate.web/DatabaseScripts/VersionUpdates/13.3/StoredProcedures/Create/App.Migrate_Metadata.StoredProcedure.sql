CREATE PROCEDURE [App].[Migrate_Metadata]
	@dataSetType varchar(50),
	@submissionYear int,
	@isTransferAppToMetadata bit = 1
AS
BEGIN

	DECLARE @charterReportIds VARCHAR(MAX);

	SELECT @charterReportIds = STRING_AGG(generateReportId, ',')
	FROM app.GenerateReports
	WHERE ReportCode IN ('190','196','197','198','207');

	IF @isTransferAppToMetadata = 1
	BEGIN
		
		DROP TABLE IF EXISTS Metadata.CategoryOptions
		DROP TABLE IF EXISTS Metadata.CategorySet_Categories
		DROP TABLE IF EXISTS Metadata.CategorySets
		--DROP TABLE IF EXISTS Metadata.FileColumns
		DROP TABLE IF EXISTS Metadata.FileSubmission_FileColumns
		DROP TABLE IF EXISTS Metadata.FileSubmissions

		--SELECT * INTO Metadata.FileColumns
		--FROM app.FileColumns

		IF @dataSetType = 'ESS'
		BEGIN

			--insert into Metadata.CategorySets
			SELECT * into Metadata.CategorySets FROM app.CategorySets WHERE SubmissionYear = @submissionYear
			  AND GenerateReportId NOT IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 );

			--insert into Metadata.CategorySet_Categories
			select * into Metadata.CategorySet_Categories from app.CategorySet_Categories
			where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear
				AND GenerateReportId NOT IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))

			select * into Metadata.CategoryOptions from app.CategoryOptions
			where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear
				AND GenerateReportId NOT IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))

			--insert into Metadata.FileSubmissions
			select * into Metadata.FileSubmissions from app.FileSubmissions where SubmissionYear = @submissionYear
			AND GenerateReportId NOT IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 );

			--insert into Metadata.FileSubmission_FileColumns
			select * into Metadata.FileSubmission_FileColumns from app.FileSubmission_FileColumns 
			where FileSubmissionId in (select distinct FileSubmissionId from app.FileSubmissions where SubmissionYear = @submissionYear
			AND GenerateReportId NOT IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))
		END
		ELSE IF @dataSetType = 'CHARTER'
		BEGIN
			--insert into Metadata.CategorySets
			SELECT * into Metadata.CategorySets FROM app.CategorySets WHERE SubmissionYear = @submissionYear
			  AND GenerateReportId IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 );

			--insert into Metadata.CategorySet_Categories
			select * into Metadata.CategorySet_Categories from app.CategorySet_Categories
			where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear
				AND GenerateReportId IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))

			--insert into Metadata.CategoryOptions
			select * into Metadata.CategoryOptions from app.CategoryOptions
			where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear
				AND GenerateReportId IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))

			--insert into Metadata.FileSubmissions
			select * into Metadata.FileSubmissions from app.FileSubmissions where SubmissionYear = @submissionYear
			AND GenerateReportId IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 );

			--insert into Metadata.FileSubmission_FileColumns
			select * into Metadata.FileSubmission_FileColumns from app.FileSubmission_FileColumns 
			where FileSubmissionId in (select distinct FileSubmissionId from app.FileSubmissions where SubmissionYear = @submissionYear
			AND GenerateReportId IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))

		END

	END
	ELSE
	BEGIN
			
		IF @dataSetType = 'ESS'
		BEGIN

			delete from app.CategoryOptions
			where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear
			AND GenerateReportId NOT IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))

			delete from app.CategorySet_Categories
			where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear 
			AND GenerateReportId NOT IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))

			delete from app.CategorySets where SubmissionYear = @submissionYear
			AND GenerateReportId NOT IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 )

			delete from app.FileSubmission_FileColumns 
			where FileSubmissionId in (select distinct FileSubmissionId from app.FileSubmissions where SubmissionYear = @submissionYear
			AND GenerateReportId NOT IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))

			delete from app.FileSubmissions where SubmissionYear = @submissionYear
			AND GenerateReportId NOT IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 )

			SET IDENTITY_INSERT App.CategorySets ON

				INSERT INTO [App].[CategorySets]
				   ([CategorySetId]
				   ,[CategorySetCode]
				   ,[CategorySetName]
				   ,[CategorySetSequence]
				   ,[EdFactsTableTypeGroupId]
				   ,[ExcludeOnFilter]
				   ,[GenerateReportId]
				   ,[IncludeOnFilter]
				   ,[OrganizationLevelId]
				   ,[SubmissionYear]
				   ,[TableTypeId]
				   ,[ViewDefinition]
				   ,[EdFactsTableTypeId])
				select  CategorySetId
					   ,[CategorySetCode]
					   ,[CategorySetName]
					   ,[CategorySetSequence]
					   ,[EdFactsTableTypeGroupId]
					   ,[ExcludeOnFilter]
					   ,[GenerateReportId]
					   ,[IncludeOnFilter]
					   ,[OrganizationLevelId]
					   ,[SubmissionYear]
					   ,[TableTypeId]
					   ,[ViewDefinition]
					   ,[EdFactsTableTypeId]
			   from Metadata.CategorySets where SubmissionYear = @submissionYear
				AND GenerateReportId NOT IN (
						SELECT value 
						FROM STRING_SPLIT(@charterReportIds, ',')
					 )

			SET IDENTITY_INSERT App.CategorySets OFF

			insert into app.CategorySet_Categories([CategorySetId], [CategoryId], [GenerateReportDisplayTypeID])
			select [CategorySetId], [CategoryId], [GenerateReportDisplayTypeID] 
			from Metadata.CategorySet_Categories
			where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear
			AND GenerateReportId NOT IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))


			insert into app.CategoryOptions([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategoryOptionSequence],[CategorySetId],[EdFactsCategoryCodeId])
			select [CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategoryOptionSequence],[CategorySetId],[EdFactsCategoryCodeId] 
			from Metadata.CategoryOptions
			where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear
			AND GenerateReportId NOT IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))

			SET IDENTITY_INSERT app.FileSubmissions ON

				INSERT INTO [App].[FileSubmissions]([FileSubmissionId],[FileSubmissionDescription],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
				select [FileSubmissionId],[FileSubmissionDescription],[GenerateReportId],[OrganizationLevelId],[SubmissionYear]
				from Metadata.FileSubmissions
				Where SubmissionYear = @submissionYear
				AND GenerateReportId NOT IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 )

			SET IDENTITY_INSERT app.FileSubmissions OFF

			
			INSERT INTO [App].[FileSubmission_FileColumns]
				 ([FileSubmissionId],[FileColumnId],[EndPosition],[IsOptional],[SequenceNumber],[StartPosition])
		    SELECT [FileSubmissionId],[FileColumnId],[EndPosition],[IsOptional],[SequenceNumber],[StartPosition]
			FROM Metadata.FileSubmission_FileColumns
			where FilesubmissionId IN (
				 select distinct [FileSubmissionId]
				 from app.FileSubmissions
				 Where SubmissionYear = @submissionYear
				 AND GenerateReportId NOT IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))
				AND FileColumnId IN (
					select distinct FileColumnId
					from app.FileColumns
				)

		END
		ELSE IF @dataSetType = 'CHARTER'
		BEGIN

			delete from app.CategoryOptions
			where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear
			AND GenerateReportId IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))

			delete from app.CategorySet_Categories
			where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear 
			AND GenerateReportId IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))

			delete from app.CategorySets where SubmissionYear = @submissionYear
			AND GenerateReportId IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 )

			delete from app.FileSubmission_FileColumns 
			where FileSubmissionId in (select distinct FileSubmissionId from app.FileSubmissions where SubmissionYear = @submissionYear
			AND GenerateReportId IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))

			delete from app.FileSubmissions where SubmissionYear = @submissionYear
			AND GenerateReportId IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 )

			SET IDENTITY_INSERT App.CategorySets ON

				INSERT INTO [App].[CategorySets]
				   ([CategorySetId]
				   ,[CategorySetCode]
				   ,[CategorySetName]
				   ,[CategorySetSequence]
				   ,[EdFactsTableTypeGroupId]
				   ,[ExcludeOnFilter]
				   ,[GenerateReportId]
				   ,[IncludeOnFilter]
				   ,[OrganizationLevelId]
				   ,[SubmissionYear]
				   ,[TableTypeId]
				   ,[ViewDefinition]
				   ,[EdFactsTableTypeId])
				select  CategorySetId
					   ,[CategorySetCode]
					   ,[CategorySetName]
					   ,[CategorySetSequence]
					   ,[EdFactsTableTypeGroupId]
					   ,[ExcludeOnFilter]
					   ,[GenerateReportId]
					   ,[IncludeOnFilter]
					   ,[OrganizationLevelId]
					   ,[SubmissionYear]
					   ,[TableTypeId]
					   ,[ViewDefinition]
					   ,[EdFactsTableTypeId]
			   from Metadata.CategorySets where SubmissionYear = @submissionYear
				AND GenerateReportId IN (
						SELECT value 
						FROM STRING_SPLIT(@charterReportIds, ',')
					 )

			SET IDENTITY_INSERT App.CategorySets OFF

			insert into app.CategorySet_Categories([CategorySetId], [CategoryId], [GenerateReportDisplayTypeID])
			select [CategorySetId], [CategoryId], [GenerateReportDisplayTypeID] 
			from Metadata.CategorySet_Categories
			where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear
			AND GenerateReportId IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))


			insert into app.CategoryOptions([CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategoryOptionSequence],[CategorySetId],[EdFactsCategoryCodeId])
			select [CategoryId],[CategoryOptionCode],[CategoryOptionName],[CategoryOptionSequence],[CategorySetId],[EdFactsCategoryCodeId] 
			from Metadata.CategoryOptions
			where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear
			AND GenerateReportId IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))

			SET IDENTITY_INSERT app.FileSubmissions ON

				INSERT INTO [App].[FileSubmissions]([FileSubmissionId],[FileSubmissionDescription],[GenerateReportId],[OrganizationLevelId],[SubmissionYear])
				select [FileSubmissionId],[FileSubmissionDescription],[GenerateReportId],[OrganizationLevelId],[SubmissionYear]
				from Metadata.FileSubmissions
				Where SubmissionYear = @submissionYear
				AND GenerateReportId IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 )

			SET IDENTITY_INSERT app.FileSubmissions OFF

			INSERT INTO [App].[FileSubmission_FileColumns]
				 ([FileSubmissionId],[FileColumnId],[EndPosition],[IsOptional],[SequenceNumber],[StartPosition])
		    SELECT [FileSubmissionId],[FileColumnId],[EndPosition],[IsOptional],[SequenceNumber],[StartPosition]
			FROM Metadata.FileSubmission_FileColumns
			where FilesubmissionId IN (
				  select distinct [FileSubmissionId]
				 from app.FileSubmissions
				 Where SubmissionYear = @submissionYear
				 AND GenerateReportId IN (
					SELECT value 
					FROM STRING_SPLIT(@charterReportIds, ',')
				 ))
				 AND FileColumnId IN (
					select distinct FileColumnId
					from app.FileColumns
				)

			DROP TABLE IF EXISTS Metadata.CategoryOptions
			DROP TABLE IF EXISTS Metadata.CategorySet_Categories
			DROP TABLE IF EXISTS Metadata.CategorySets
			DROP TABLE IF EXISTS Metadata.FileSubmission_FileColumns
			DROP TABLE IF EXISTS Metadata.FileSubmissions

		END

	END
	
END