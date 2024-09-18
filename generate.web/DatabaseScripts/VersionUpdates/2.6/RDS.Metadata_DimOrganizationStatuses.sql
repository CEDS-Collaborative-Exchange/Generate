-- Release-Specific metadata for the RDS schema
-- e.g. dimension seed data
----------------------------------

set nocount on
begin try
 
	begin transaction		



			declare @REAPAlternativeFundingStatusId as int
			declare @REAPAlternativeFundingStatusCode as varchar(50)
			declare @REAPAlternativeFundingStatusDescription as varchar(200)
			declare @REAPAlternativeFundingStatusEdFactsCode as varchar(50)

			declare @REAPAlternativeFundingStatusTable table(
				REAPAlternativeFundingStatusId int,
				REAPAlternativeFundingStatusCode varchar(50),
				REAPAlternativeFundingStatusDescription varchar(200),
				REAPAlternativeFundingStatusEdFactsCode varchar(50)
			); 

			insert into @REAPAlternativeFundingStatusTable (REAPAlternativeFundingStatusId, REAPAlternativeFundingStatusCode, REAPAlternativeFundingStatusDescription, REAPAlternativeFundingStatusEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @REAPAlternativeFundingStatusTable (REAPAlternativeFundingStatusId, REAPAlternativeFundingStatusCode, REAPAlternativeFundingStatusDescription, REAPAlternativeFundingStatusEdFactsCode) 
			values 
			(1, 'YES', 'The LEA is exercising the alternative uses of funds authority.', 'YES')

			insert into @REAPAlternativeFundingStatusTable (REAPAlternativeFundingStatusId, REAPAlternativeFundingStatusCode, REAPAlternativeFundingStatusDescription, REAPAlternativeFundingStatusEdFactsCode) 
			values 
			(2, 'NO', 'The LEA is eligible but is not exercising the alternative uses of funds authority.', 'NO')

			insert into @REAPAlternativeFundingStatusTable (REAPAlternativeFundingStatusId, REAPAlternativeFundingStatusCode, REAPAlternativeFundingStatusDescription, REAPAlternativeFundingStatusEdFactsCode) 
			values 
			(3, 'NA', 'The LEA is not eligible to use alternative uses of funds authority.', 'NA')

			declare @GunFreeStatusId as int
			declare @GunFreeStatusCode as varchar(50)
			declare @GunFreeStatusDescription as varchar(200)
			declare @GunFreeStatusEdFactsCode as varchar(50)

			declare @GunFreeStatusTable table(
				GunFreeStatusId int,
				GunFreeStatusCode varchar(50),
				GunFreeStatusDescription varchar(200),
				GunFreeStatusEdFactsCode varchar(50)
			); 

			insert into @GunFreeStatusTable (GunFreeStatusId, GunFreeStatusCode, GunFreeStatusDescription, GunFreeStatusEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @GunFreeStatusTable (GunFreeStatusId, GunFreeStatusCode, GunFreeStatusDescription, GunFreeStatusEdFactsCode) values 
			(1, 'YESWITHREP', 'The LEA/school submitted a report that indicated one or more students had an offense.', 'YESWITHREP')

			insert into @GunFreeStatusTable (GunFreeStatusId, GunFreeStatusCode, GunFreeStatusDescription, GunFreeStatusEdFactsCode) values 
			(2, 'YESWOREP', 'The LEA/school submitted a report that indicated no students had offenses.', 'YESWOREP')

			insert into @GunFreeStatusTable (GunFreeStatusId, GunFreeStatusCode, GunFreeStatusDescription, GunFreeStatusEdFactsCode) values 
			(3, 'NO', 'The LEA/school did not submit a report.', 'NO')

			insert into @GunFreeStatusTable (GunFreeStatusId, GunFreeStatusCode, GunFreeStatusDescription, GunFreeStatusEdFactsCode) values 
			(4, 'NA', 'The LEA/school is not required to submit a report.', 'NA')


			declare @GraduationRateId as int
			declare @GraduationRateCode as varchar(50)
			declare @GraduationRateDescription as varchar(200)
			declare @GraduationRateEdFactsCode as varchar(50)

			declare @GraduationRateTable table(
				GraduationRateId int,
				GraduationRateCode varchar(50),
				GraduationRateDescription varchar(200),
				GraduationRateEdFactsCode varchar(50)
			); 

			insert into @GraduationRateTable (GraduationRateId, GraduationRateCode, GraduationRateDescription, GraduationRateEdFactsCode) 
			values 
			(-1, 'MISSING', 'Missing', 'MISSING')

			insert into @GraduationRateTable (GraduationRateId, GraduationRateCode, GraduationRateDescription, GraduationRateEdFactsCode) 
			values 
			(1, 'STTDEF', 'A status defined by the state.', 'STTDEF')

			insert into @GraduationRateTable (GraduationRateId, GraduationRateCode, GraduationRateDescription, GraduationRateEdFactsCode) 
			values 
			(2, 'TOOFEW', 'The number of students in the school or for a student subgroup was less than the minimum group size.', 'TOOFEW')

			insert into @GraduationRateTable (GraduationRateId, GraduationRateCode, GraduationRateDescription, GraduationRateEdFactsCode) 
			values 
			(3, 'NOSTUDENTS', 'There are no students in a student subgroup.', 'NOSTUDENTS')

		

										DECLARE REAPAlternativeFundingStatus_cursor CURSOR FOR 
										SELECT REAPAlternativeFundingStatusId, REAPAlternativeFundingStatusCode, REAPAlternativeFundingStatusDescription, REAPAlternativeFundingStatusEdFactsCode
										FROM @REAPAlternativeFundingStatusTable
										OPEN REAPAlternativeFundingStatus_cursor
										FETCH NEXT FROM REAPAlternativeFundingStatus_cursor INTO @REAPAlternativeFundingStatusId, @REAPAlternativeFundingStatusCode, @REAPAlternativeFundingStatusDescription, @REAPAlternativeFundingStatusEdFactsCode
										WHILE @@FETCH_STATUS = 0
										BEGIN

											DECLARE GunFreeSchoolStatus_cursor CURSOR FOR 
											SELECT GunFreeStatusId, GunFreeStatusCode, GunFreeStatusDescription, GunFreeStatusEdFactsCode
											FROM @GunFreeStatusTable
											OPEN GunFreeSchoolStatus_cursor
											FETCH NEXT FROM GunFreeSchoolStatus_cursor INTO @GunFreeStatusId, @GunFreeStatusCode, @GunFreeStatusDescription, @GunFreeStatusEdFactsCode
											WHILE @@FETCH_STATUS = 0
											BEGIN
													DECLARE GraduationRate_cursor CURSOR FOR 
													SELECT GraduationRateId, GraduationRateCode, GraduationRateDescription, GraduationRateEdFactsCode
													FROM @GraduationRateTable

													OPEN GraduationRate_cursor
													FETCH NEXT FROM GraduationRate_cursor INTO @GraduationRateId, @GraduationRateCode, @GraduationRateDescription, @GraduationRateEdFactsCode
													WHILE @@FETCH_STATUS = 0
													BEGIN


								if   @GunFreeStatusCode='MISSING' AND @REAPAlternativeFundingStatusCode='MISSING' and @GraduationRateCode='MISSING'
								BEGIN
								
									if not exists (select 1 from rds.DimOrganizationStatus where  GunFreeStatusCode=@GunFreeStatusCode AND REAPAlternativeFundingStatusCode=@REAPAlternativeFundingStatusCode )
									BEGIN

									set identity_insert rds.DimOrganizationStatus on

									insert into rds.DimOrganizationStatus (
																		DimOrganizationStatusId, REAPAlternativeFundingStatusId, REAPAlternativeFundingStatusCode, REAPAlternativeFundingStatusDescription, REAPAlternativeFundingStatusEdFactsCode,.
																		GunFreeStatusId, GunFreeStatusCode, GunFreeStatusDescription, GunFreeStatusEdFactsCode,
																		GraduationRateId, GraduationRateCode, GraduationRateDescription, GraduationRateEdFactsCode
																		)
																		VALUES (
																		-1,@REAPAlternativeFundingStatusId, @REAPAlternativeFundingStatusCode, @REAPAlternativeFundingStatusDescription, @REAPAlternativeFundingStatusEdFactsCode,
																		@GunFreeStatusId, @GunFreeStatusCode, @GunFreeStatusDescription, @GunFreeStatusEdFactsCode,
																		@GraduationrateId, @GraduationRateCode, @GraduationRateDescription, @GraduationRateEdFactsCode	
																		)

									set identity_insert rds.DimOrganizationStatus off

									END
								END
								ELSE
								BEGIN

									IF NOT EXISTS(select 1 from RDS.DimOrganizationStatus where REAPAlternativeFundingStatusCode = @REAPAlternativeFundingStatusCode and GunFreeStatusCode = @GunFreeStatusCode and GraduationRateCode=@GraduationRateCode )
											begin


										insert into rds.DimOrganizationStatus (
																		REAPAlternativeFundingStatusId, REAPAlternativeFundingStatusCode, REAPAlternativeFundingStatusDescription, REAPAlternativeFundingStatusEdFactsCode,.
																		GunFreeStatusId, GunFreeStatusCode, GunFreeStatusDescription, GunFreeStatusEdFactsCode,
																		GraduationRateId, GraduationRateCode, GraduationRateDescription, GraduationRateEdFactsCode
																		)
																		VALUES (
																			@REAPAlternativeFundingStatusId, @REAPAlternativeFundingStatusCode, @REAPAlternativeFundingStatusDescription, @REAPAlternativeFundingStatusEdFactsCode,
																		@GunFreeStatusId, @GunFreeStatusCode, @GunFreeStatusDescription, @GunFreeStatusEdFactsCode,
																		@GraduationrateId, @GraduationRateCode, @GraduationRateDescription, @GraduationRateEdFactsCode	
																		)
									END
								END

											FETCH NEXT FROM GraduationRate_cursor INTO @GraduationRateId, @GraduationRateCode, @GraduationRateDescription, @GraduationRateEdFactsCode
											END
											CLOSE GraduationRate_cursor
											DEALLOCATE GraduationRate_cursor

										FETCH NEXT FROM GunFreeSchoolStatus_cursor INTO @GunFreeStatusId, @GunFreeStatusCode, @GunFreeStatusDescription, @GunFreeStatusEdFactsCode
										END
										CLOSE GunFreeSchoolStatus_cursor
										DEALLOCATE GunFreeSchoolStatus_cursor

									FETCH NEXT FROM REAPAlternativeFundingStatus_cursor INTO @REAPAlternativeFundingStatusId, @REAPAlternativeFundingStatusCode, @REAPAlternativeFundingStatusDescription, @REAPAlternativeFundingStatusEdFactsCode
									END
									CLOSE REAPAlternativeFundingStatus_cursor
									DEALLOCATE REAPAlternativeFundingStatus_cursor
								
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
