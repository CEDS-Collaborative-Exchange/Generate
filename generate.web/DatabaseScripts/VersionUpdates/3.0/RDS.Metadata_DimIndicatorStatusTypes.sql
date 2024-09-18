-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------
set nocount on
begin try
	begin transaction
		declare @IndicatorStatusTypeId as int
		declare @IndicatorStatusTypeCode as varchar(50)
		declare @IndicatorStatusTypeDescription as varchar(200)
		declare @IndicatorStatusTypeEdFactsCode as varchar(200)

		declare @IndicatorStatusTypeTable table(
				IndicatorStatusTypeId int,
				IndicatorStatusTypeCode varchar(50),
				IndicatorStatusTypeDescription varchar(200),
				IndicatorStatusTypeEdFactsCode varchar(50)
			); 

		insert into @IndicatorStatusTypeTable (IndicatorStatusTypeId, IndicatorStatusTypeCode, IndicatorStatusTypeDescription, IndicatorStatusTypeEdFactsCode) 
		values 
		(-1, 'Missing', 'State Defined Status not set', 'Missing')
		insert into @IndicatorStatusTypeTable (IndicatorStatusTypeId, IndicatorStatusTypeCode, IndicatorStatusTypeDescription, IndicatorStatusTypeEdFactsCode)
		values 
		(1, 'GraduationRateIndicatorStatus', 'Graduation Rate Indicator Status', 'GRADRSTAT')
		insert into @IndicatorStatusTypeTable (IndicatorStatusTypeId, IndicatorStatusTypeCode, IndicatorStatusTypeDescription, IndicatorStatusTypeEdFactsCode)
		values 
		(2, 'AcademicAchievementIndicatorStatus', 'Academic Achievement Indicator Status', 'ACHIVSTAT')
		insert into @IndicatorStatusTypeTable (IndicatorStatusTypeId, IndicatorStatusTypeCode, IndicatorStatusTypeDescription, IndicatorStatusTypeEdFactsCode)
		values 
		(3, 'OtherAcademicIndicatorStatus', 'Other Academic Indicator Status', 'OTHESTAT')
		insert into @IndicatorStatusTypeTable (IndicatorStatusTypeId, IndicatorStatusTypeCode, IndicatorStatusTypeDescription, IndicatorStatusTypeEdFactsCode)
		values 
		(4, 'SchoolQualityOrStudentSuccessIndicatorStatus', 'School Quality or Student Success Indicator Status', 'QUALSTAT')

		DECLARE IndicatorStatusType_cursor CURSOR FOR 
		SELECT IndicatorStatusTypeId, IndicatorStatusTypeCode, IndicatorStatusTypeDescription, IndicatorStatusTypeEdFactsCode
		FROM @IndicatorStatusTypeTable

		OPEN IndicatorStatusType_cursor

		FETCH NEXT FROM IndicatorStatusType_cursor INTO @IndicatorStatusTypeId, @IndicatorStatusTypeCode, @IndicatorStatusTypeDescription, @IndicatorStatusTypeEdFactsCode
		WHILE @@FETCH_STATUS = 0
		BEGIN
			if  @IndicatorStatusTypeCode = 'MISSING'
			begin
				if not exists(select 1 from RDS.DimIndicatorStatusTypes where IndicatorStatusTypeCode = @IndicatorStatusTypeCode)
				begin
					set identity_insert RDS.DimIndicatorStatusTypes on
						INSERT INTO RDS.DimIndicatorStatusTypes
						(
							DimIndicatorStatusTypeId,
							IndicatorStatusTypeId, 
							IndicatorStatusTypeCode, 
							IndicatorStatusTypeDescription,
							IndicatorStatusTypeEdFactsCode
						)
						VALUES 
						(
							-1,
							@IndicatorStatusTypeId,
							@IndicatorStatusTypeCode, 
							@IndicatorStatusTypeDescription,
							@IndicatorStatusTypeEdFactsCode
						)						

					set identity_insert RDS.DimIndicatorStatusTypes off
				end
			end
			else
			begin
				if not exists(select 1 from RDS.DimIndicatorStatusTypes where IndicatorStatusTypeCode = @IndicatorStatusTypeCode)
				begin
					INSERT INTO RDS.DimIndicatorStatusTypes
					(
						IndicatorStatusTypeId, 
						IndicatorStatusTypeCode, 
						IndicatorStatusTypeDescription,
						IndicatorStatusTypeEdFactsCode
					)
					VALUES
					(
						@IndicatorStatusTypeId,
						@IndicatorStatusTypeCode, 
						@IndicatorStatusTypeDescription,
						@IndicatorStatusTypeEdFactsCode)
				end
			end
		FETCH NEXT FROM IndicatorStatusType_cursor INTO @IndicatorStatusTypeId, @IndicatorStatusTypeCode, @IndicatorStatusTypeDescription, @IndicatorStatusTypeEdFactsCode
		END
		CLOSE IndicatorStatusType_cursor
		DEALLOCATE IndicatorStatusType_cursor
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
