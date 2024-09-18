CREATE PROCEDURE [Staging].[Rollover_SourceSystemReferenceData]
	@FromYear int = NULL,
	@ToYear int = NULL
AS
BEGIN

	/******************************************************************************************
	@FromYear and @ToYear can be provided when running this procedure manually to do a rollover
	If @FromYear is NULL and @ToYear is NULL (default when called from Wrappers), then
	use SchoolYear from Staging.StateDetail to determine if rollover is needed
	********************************************************************************************/

	if @FromYear is not null and @ToYear is not null
		begin
			-- Validations -----------------------------
			-- 1 Verify SSRD has data for @FromYear
			if (select count(*) from Staging.SourceSystemReferenceData where SchoolYear = @FromYear) = 0
				begin
					insert into app.DataMigrationHistories (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
					values (getutcdate(), 4, 'ERROR: Manual rollover of SourceSystemReferenceData failed because no records exist in Staging.SourceSystemReferenceData for ' + convert(varchar, @FromYear) + '.') 
					return
				end

			-- 2 Verify SSRD does not already have data for @ToYear
			if (select count(*) from Staging.SourceSystemReferenceData where SchoolYear = @ToYear) <> 0
				begin
					insert into app.DataMigrationHistories (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
					values (getutcdate(), 4, 'ERROR: Manual rollover of SourceSystemReferenceData failed because records already exist in Staging.SourceSystemReferenceData for ' + convert(varchar, @ToYear) + '.') 
					return
				end

				INSERT INTO staging.SourceSystemReferenceData (
					SchoolYear
					,TableName
					,TableFilter
					,InputCode
					,OutputCode
				)
				SELECT DISTINCT
					@ToYear
					,TableName
					,TableFilter
					,InputCode
					,OutputCode
				FROM staging.SourceSystemReferenceData
				WHERE SchoolYear = @FromYear

				insert into app.DataMigrationHistories (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
				values (getutcdate(), 4, 'SourceSystemReferenceData manually rolled over for ' + convert(varchar, @ToYear) + ' from ' + convert(varchar, @FromYear)) 
			return
		end
	
	declare @StagingSchoolYear int

	-- Validations -----------------------------
	-- 1 Verify SSRD has data
	if (select count(*) from Staging.SourceSystemReferenceData) = 0
		begin
			insert into app.DataMigrationHistories (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values (getutcdate(), 4, 'ERROR: Rollover of SourceSystemReferenceData failed because no records exist in Staging.SourceSystemReferenceData.') 
			return
		end

	-- 2 Verify StateDetail has at least one record
	if (select count(*) from Staging.StateDetail) = 0
		begin
			insert into app.DataMigrationHistories (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
			values (getutcdate(), 4, 'ERROR: Rollover of SourceSystemReferenceData failed because no records exist in Staging.StateDetail') 
			return
		end
	else
		begin
			-- Build a temp table of all School Years that exist in Staging.StateDetail (typically there will only be one year)
			-- This assures that SourceSystemReferenceData has records that correspond to the staging school year.
			IF OBJECT_ID(N'tempdb..#SchoolYearsInStaging') IS NOT NULL DROP TABLE #SchoolYearsInStaging
			select distinct SchoolYear into #SchoolYearsInStaging from Staging.StateDetail where SchoolYear is not null
		end

	while exists(select top 1 * from #SchoolYearsInStaging)
		begin
			select @StagingSchoolYear = (select top 1 SchoolYear from #SchoolYearsInStaging order by SchoolYear) -- get oldest school year first to sequentially loop through years and rollover SSRD as needed

				-- Roll the staging.SourceSystemReferenceData OptionSets into the next school year
				-- if there are no records in SourceSystemReferenceData for the Staging School Year
				IF (SELECT COUNT(*) FROM staging.SourceSystemReferenceData WHERE SchoolYear = @StagingSchoolYear) = 0
					BEGIN
		
						-- Verify there are records from the previous year to roll forward
						if (select count(*) from Staging.SourceSystemReferenceData where SchoolYear = @StagingSchoolYear-1) = 0
							begin
								insert into app.DataMigrationHistories (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
								values (getutcdate(), 4, 'ERROR: Rollover of SourceSystemReferenceData failed for ' + convert(varchar, @StagingSchoolYear) + ' because no records exist in Staging.SourceSystemReferenceData for ' + convert(varchar, @StagingSchoolYear-1) + '.') 
								return
							end

						INSERT INTO staging.SourceSystemReferenceData (
							SchoolYear
							,TableName
							,TableFilter
							,InputCode
							,OutputCode
						)
						SELECT DISTINCT
							@StagingSchoolYear
							,TableName
							,TableFilter
							,InputCode
							,OutputCode
						FROM staging.SourceSystemReferenceData
						WHERE SchoolYear = @StagingSchoolYear-1
		

						insert into app.DataMigrationHistories (DataMigrationHistoryDate, DataMigrationTypeId, DataMigrationHistoryMessage) 
						values (getutcdate(), 4, 'SourceSystemReferenceData rolled over for ' + convert(varchar, @StagingSchoolYear) + ' from ' + convert(varchar, @StagingSchoolYear-1)) 
					END

			delete from #SchoolYearsInStaging where SchoolYear = @StagingSchoolYear

		end -- end of loop

END