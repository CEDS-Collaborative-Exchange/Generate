CREATE PROCEDURE [App].[Migrate_Metadata]
	@isTransferAppToMetadata bit = 1,
	@submissionYear int
AS
BEGIN


	IF @isTransferAppToMetadata = 1
	BEGIN

		insert into Metadata.CategorySets
		select * from app.CategorySets where SubmissionYear = @submissionYear

		insert into Metadata.CategorySet_Categories
		select * from app.CategorySet_Categories
		where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear)

		insert into Metadata.CategoryOptions
		select * from app.CategoryOptions
		where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear)

		insert into Metadata.FileSubmissions
		select * from app.FileSubmissions where SubmissionYear = @submissionYear

		insert into Metadata.FileSubmission_FileColumns
		select * from app.FileSubmission_FileColumns 
		where FileSubmissionId in (select distinct FileSubmissionId from app.FileSubmissions where SubmissionYear = @submissionYear)

	END
	ELSE
	BEGIN
		
		delete from app.CategoryOptions
		where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear)

		delete from app.CategorySet_Categories
		where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear)

		delete from app.CategorySets where SubmissionYear = @submissionYear

		delete from app.FileSubmission_FileColumns 
		where FileSubmissionId in (select distinct FileSubmissionId from app.FileSubmissions where SubmissionYear = @submissionYear)

		delete from app.FileSubmissions where SubmissionYear = @submissionYear

		insert into app.CategorySets
		select * from Metadata.CategorySets where SubmissionYear = @submissionYear

		insert into app.CategorySet_Categories
		select * from Metadata.CategorySet_Categories
		where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear)

		insert into app.CategoryOptions
		select * from Metadata.CategoryOptions
		where CategorySetId in (select distinct CategorySetId from app.CategorySets where SubmissionYear = @submissionYear)

		insert into app.FileSubmissions
		select * from Metadata.FileSubmissions where SubmissionYear = @submissionYear

		insert into app.FileSubmission_FileColumns
		select * from Metadata.FileSubmission_FileColumns 
		where FileSubmissionId in (select distinct FileSubmissionId from app.FileSubmissions where SubmissionYear = @submissionYear)

		drop table Metadata.CategoryOptions
		drop table Metadata.CategorySet_Categories
		drop table Metadata.CategorySets
		drop table Metadata.FileSubmission_FileColumns
		drop table Metadata.FileSubmissions

	END
	
END