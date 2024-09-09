IF EXISTS(SELECT 1 FROM sys.indexes
WHERE object_id = OBJECT_ID('App.TableTypes') AND name = 'UX_TableTypes')
BEGIN
	ALTER TABLE [App].[TableTypes] DROP CONSTRAINT [UX_TableTypes]
END

IF NOT EXISTS(SELECT 1 FROM sys.indexes
WHERE object_id = OBJECT_ID('App.TableTypes') AND name = 'UX_TableTypes')
BEGIN
	ALTER TABLE [App].[TableTypes] ADD  CONSTRAINT [UX_TableTypes] UNIQUE NONCLUSTERED 
	(
		[TableTypeAbbrv], [EdFactsTableTypeId]  ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END

IF NOT EXISTS(SELECT 1 FROM sys.indexes
WHERE object_id = OBJECT_ID('App.GenerateReport_FactType') AND name = 'PK_GenerateReport_FactTypes')
BEGIN
	ALTER TABLE [App].[GenerateReport_FactType] ADD  CONSTRAINT [PK_GenerateReport_FactTypes] PRIMARY KEY CLUSTERED 
	(
		[GenerateReportId] ASC,
		[FactTypeId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END

IF COL_LENGTH('App.DataMigrations', 'UserName') IS NULL
BEGIN
	ALTER TABLE App.DataMigrations ADD UserName nvarchar(100);
END

IF COL_LENGTH('App.DataMigrations', 'DataMigrationTaskList') IS NULL
BEGIN
	ALTER TABLE App.DataMigrations ADD DataMigrationTaskList nvarchar(50);
END

IF COL_LENGTH('App.DataMigrationTasks', 'FactTypeId') IS NULL
BEGIN
	ALTER TABLE App.DataMigrationTasks ADD FactTypeId int NOT NULL default(-1);
END

ALTER TABLE [App].[DataMigrationTasks] DROP CONSTRAINT [UX_DataMigrationTasks]

SET ANSI_PADDING ON
GO

ALTER TABLE [App].[DataMigrationTasks] ADD  CONSTRAINT [UX_DataMigrationTasks] UNIQUE NONCLUSTERED 
(
	[DataMigrationTypeId] ASC,
	[StoredProcedureName] ASC,
	[FactTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

-- Remove Toggle Sections that have no questions
delete from app.ToggleSections where SectionSequence in (202, 400, 401, 600, 601, 800, 801, 900, 901)


--------------------------------------------------------------------------
--Remove the duplicate question from the ToggleQuestions table (CIID-5657)
--------------------------------------------------------------------------

--first, set the new questions with the same response as the original question

	declare @responseValue nvarchar(5)
	set @responseValue = (select ResponseValue from App.ToggleResponses where ToggleQuestionId = 23)
	if ISNULL(@responseValue, '') <> ''
	begin

		if (select count(*)
			from app.ToggleResponses
			where ToggleQuestionId = 61) = 1
		begin
			update App.ToggleResponses set ResponseValue = @responseValue where ToggleQuestionId = 61
		end
		else
		begin
			insert into App.ToggleResponses values (@responseValue, 61, NULL)
		end

		if (select count(*)
			from app.ToggleResponses
			where ToggleQuestionId = 62) = 1
		begin
			update App.ToggleResponses set ResponseValue = @responseValue where ToggleQuestionId = 62
		end
		else
		begin
			insert into App.ToggleResponses values (@responseValue, 62, NULL)
		end

	end

--second, remove the duplicate question

	--ToggleResponses
	delete from app.ToggleResponses
	where ToggleQuestionId = 23

	--ToggleQuestions
	delete from app.ToggleQuestions
	where ToggleQuestionId = 23

	--ToggleSections
	delete from app.ToggleSections
	where ToggleSectionId = 29

	






