-- Metadata changes for the RDS schema
----------------------------------
set nocount on
begin try
	begin transaction

	declare @factTypeId as int, @dimensionTableId as int
	
	---Populate Title III Statuses

	declare @formerEnglishLearnerYearStatusId as int
		declare @formerEnglishLearnerYearStatusCode as varchar(50)
		declare @formerEnglishLearnerYearStatusDescription as varchar(200)
		declare @formerEnglishLearnerYearStatusEdFactsCode as varchar(50)

		declare @formerEnglishLearnerYearStatusTable table(
			formerEnglishLearnerYearStatusId int,
			formerEnglishLearnerYearStatusCode varchar(50),
			formerEnglishLearnerYearStatusDescription varchar(200),
			formerEnglishLearnerYearStatusEdFactsCode varchar(50)
		); 


		insert into @formerEnglishLearnerYearStatusTable (formerEnglishLearnerYearStatusId, formerEnglishLearnerYearStatusCode, formerEnglishLearnerYearStatusDescription, formerEnglishLearnerYearStatusEdFactsCode) 
		values 
		(1, '5YEAR', 'Fifth Year', '5YEAR')


		declare @titleiiiAccountabilityProgressStatusId as int
		declare @titleiiiAccountabilityProgressStatusCode as varchar(50)
		declare @titleiiiAccountabilityProgressStatusDescription as varchar(200)
		declare @titleiiiAccountabilityProgressStatusEdFactsCode as varchar(50)

		declare @titleiiiAccountabilityProgressStatusTable table(	
			titleiiiAccountabilityProgressStatusId int,
			titleiiiAccountabilityProgressStatusCode varchar(50),
			titleiiiAccountabilityProgressStatusDescription varchar(200),
			titleiiiAccountabilityProgressStatusEdFactsCode varchar(50)
		); 

		insert into @titleiiiAccountabilityProgressStatusTable (titleiiiAccountabilityProgressStatusId, titleiiiAccountabilityProgressStatusCode, titleiiiAccountabilityProgressStatusDescription, titleiiiAccountabilityProgressStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @titleiiiAccountabilityProgressStatusTable (titleiiiAccountabilityProgressStatusId, titleiiiAccountabilityProgressStatusCode, titleiiiAccountabilityProgressStatusDescription, titleiiiAccountabilityProgressStatusEdFactsCode) 
		values 
		(1, 'PROGRESS', 'Making progress', 'PROGRESS')

		insert into @titleiiiAccountabilityProgressStatusTable (titleiiiAccountabilityProgressStatusId, titleiiiAccountabilityProgressStatusCode, titleiiiAccountabilityProgressStatusDescription, titleiiiAccountabilityProgressStatusEdFactsCode) 
		values 
		(2, 'NOPROGRESS', 'Did not make progress', 'NOPROGRESS')

		insert into @titleiiiAccountabilityProgressStatusTable (titleiiiAccountabilityProgressStatusId, titleiiiAccountabilityProgressStatusCode, titleiiiAccountabilityProgressStatusDescription, titleiiiAccountabilityProgressStatusEdFactsCode) 
		values 
		(3, 'PROFICIENT', 'Attained proficiency', 'PROFICIENT')


		declare @titleiiiLanguageInstructionId as int
		declare @titleiiiLanguageInstructionCode as varchar(50)
		declare @titleiiiLanguageInstructionDescription as varchar(200)
		declare @titleiiiLanguageInstructionEdFactsCode as varchar(50)

		declare @titleiiiLanguageInstructionTable table(	
			titleiiiLanguageInstructionId int,
			titleiiiLanguageInstructionCode varchar(50),
			titleiiiLanguageInstructionDescription varchar(200),
			titleiiiLanguageInstructionEdFactsCode varchar(50)
		); 

			insert into @titleiiiLanguageInstructionTable (titleiiiLanguageInstructionId, titleiiiLanguageInstructionCode, titleiiiLanguageInstructionDescription, titleiiiLanguageInstructionEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @titleiiiLanguageInstructionTable (titleiiiLanguageInstructionId, titleiiiLanguageInstructionCode, titleiiiLanguageInstructionDescription, titleiiiLanguageInstructionEdFactsCode) 
		values 
		(1, 'DualLanguage', 'Dual Language', 'LNGINSTPRGDU')

		insert into @titleiiiLanguageInstructionTable (titleiiiLanguageInstructionId, titleiiiLanguageInstructionCode, titleiiiLanguageInstructionDescription, titleiiiLanguageInstructionEdFactsCode) 
		values 
		(2, 'TwoWayImmersion', 'Two-way Immersion', 'LNGINSTPRGDU')

		
		insert into @titleiiiLanguageInstructionTable (titleiiiLanguageInstructionId, titleiiiLanguageInstructionCode, titleiiiLanguageInstructionDescription, titleiiiLanguageInstructionEdFactsCode) 
		values 
		(3, 'TransitionalBilingual', 'Transitional bilingual', 'LNGINSTPRGBI')

		
		insert into @titleiiiLanguageInstructionTable (titleiiiLanguageInstructionId, titleiiiLanguageInstructionCode, titleiiiLanguageInstructionDescription, titleiiiLanguageInstructionEdFactsCode) 
		values 
		(9, 'ContentBasedESL', 'Content-based ESL', 'LNGINSTPRGESLSUPP')


		insert into @titleiiiLanguageInstructionTable (titleiiiLanguageInstructionId, titleiiiLanguageInstructionCode, titleiiiLanguageInstructionDescription, titleiiiLanguageInstructionEdFactsCode) 
		values 
		(10, 'PullOutESL', 'Pull-out ESL', 'LNGINSTPRGESLELD')

		insert into @titleiiiLanguageInstructionTable (titleiiiLanguageInstructionId, titleiiiLanguageInstructionCode, titleiiiLanguageInstructionDescription, titleiiiLanguageInstructionEdFactsCode) 
		values 
		(11, 'Other', 'Other', 'LNGINSTPRGOTH')



				 

		declare @proficiencyStatusId as int
		declare @proficiencyStatusCode as varchar(100)
		declare @proficiencyStatusDescription as varchar(500)
		declare @proficiencyStatusEdFactsCode as varchar(100)

		declare @proficiencyStatusTable table(
			proficiencyStatusId int,
			proficiencyStatusCode varchar(50),
			proficiencyStatusDescription varchar(200),
			proficiencyStatusEdFactsCode varchar(50)
		); 

		insert into @proficiencyStatusTable (proficiencyStatusId, proficiencyStatusCode, proficiencyStatusDescription, proficiencyStatusEdFactsCode) 
		values 
		(-1, 'MISSING', 'Missing', 'MISSING')

		insert into @proficiencyStatusTable (proficiencyStatusId, proficiencyStatusCode, proficiencyStatusDescription, proficiencyStatusEdFactsCode) 
		values (1, 'Proficient', 'The student''s scores were proficient', 'PROFICIENT')

		insert into @proficiencyStatusTable (proficiencyStatusId, proficiencyStatusCode, proficiencyStatusDescription, proficiencyStatusEdFactsCode) 
		values (2, 'NotProficient', 'The student''s scores were NOT proficient.', 'NOTPROFICIENT')



		-- Loop through cursors

		DECLARE formerEnglishLearnerYearStatus_cursor CURSOR FOR 
		SELECT formerEnglishLearnerYearStatusId, formerEnglishLearnerYearStatusCode, formerEnglishLearnerYearStatusDescription, formerEnglishLearnerYearStatusEdFactsCode
		FROM @formerEnglishLearnerYearStatusTable

		OPEN formerEnglishLearnerYearStatus_cursor
		FETCH NEXT FROM formerEnglishLearnerYearStatus_cursor INTO @formerEnglishLearnerYearStatusId, @formerEnglishLearnerYearStatusCode, @formerEnglishLearnerYearStatusDescription, @formerEnglishLearnerYearStatusEdFactsCode

		WHILE @@FETCH_STATUS = 0
		BEGIN


			DECLARE titleiiiAccountabilityProgressStatus_cursor CURSOR FOR 
			SELECT titleiiiAccountabilityProgressStatusId, titleiiiAccountabilityProgressStatusCode, titleiiiAccountabilityProgressStatusDescription, titleiiiAccountabilityProgressStatusEdFactsCode
			FROM @titleiiiAccountabilityProgressStatusTable

			OPEN titleiiiAccountabilityProgressStatus_cursor
			FETCH NEXT FROM titleiiiAccountabilityProgressStatus_cursor INTO @titleiiiAccountabilityProgressStatusId, @titleiiiAccountabilityProgressStatusCode, @titleiiiAccountabilityProgressStatusDescription, @titleiiiAccountabilityProgressStatusEdFactsCode

			WHILE @@FETCH_STATUS = 0
			BEGIN


				DECLARE titleiiiLanguageInstruction_cursor CURSOR FOR 
				SELECT titleiiiLanguageInstructionId, titleiiiLanguageInstructionCode, titleiiiLanguageInstructionDescription, titleiiiLanguageInstructionEdFactsCode
				FROM @titleiiiLanguageInstructionTable

				OPEN titleiiiLanguageInstruction_cursor
				FETCH NEXT FROM titleiiiLanguageInstruction_cursor INTO @titleiiiLanguageInstructionId, @titleiiiLanguageInstructionCode, @titleiiiLanguageInstructionDescription, @titleiiiLanguageInstructionEdFactsCode

				
					WHILE @@FETCH_STATUS = 0
					BEGIN
							
						DECLARE proficiencyStatus_cursor CURSOR FOR 
						SELECT proficiencyStatusId, proficiencyStatusCode, proficiencyStatusDescription, proficiencyStatusEdFactsCode
						FROM @proficiencyStatusTable

						OPEN proficiencyStatus_cursor
						FETCH NEXT FROM proficiencyStatus_cursor INTO @proficiencyStatusId, @proficiencyStatusCode, @proficiencyStatusDescription, @proficiencyStatusEdFactsCode

						WHILE @@FETCH_STATUS = 0
						BEGIN

										if  @formerEnglishLearnerYearStatusCode = 'MISSING'
											and @titleiiiAccountabilityProgressStatusCode = 'MISSING'
											and @titleiiiLanguageInstructionCode = 'MISSING'											
											and @proficiencyStatusCode = 'MISSING'
											begin

												if not exists(select 1 from rds.DimTitleiiiStatuses where 
															FormerEnglishLearnerYearStatusCode = @formerEnglishLearnerYearStatusCode 
															and ProficiencyStatusCode =  @proficiencyStatusCode
															and TitleiiiAccountabilityProgressStatusCode = @titleiiiAccountabilityProgressStatusCode 
															and TitleiiiLanguageInstructionCode = @titleiiiLanguageInstructionCode)
												begin

													set identity_insert rds.DimTitleiiiStatuses on

													insert into rds.DimTitleiiiStatuses
													(
													DimTitleiiiStatusId,
													FormerEnglishLearnerYearStatusId, FormerEnglishLearnerYearStatusCode, 
													FormerEnglishLearnerYearStatusDescription, FormerEnglishLearnerYearStatusEdFactsCode,
													TitleiiiAccountabilityProgressStatusId, TitleiiiAccountabilityProgressStatusCode,                  
													TitleiiiAccountabilityProgressStatusDescription, TitleiiiAccountabilityProgressStatusEdFactsCode,
													TitleiiiLanguageInstructionId, TitleiiiLanguageInstructionCode, 
													TitleiiiLanguageInstructionDescription, TitleiiiLanguageInstructionEdFactsCode,
											
													proficiencyStatusId, proficiencyStatusCode, proficiencyStatusDescription, proficiencyStatusEdFactsCode
													)
													values
													(
													-1,
													@formerEnglishLearnerYearStatusId, @formerEnglishLearnerYearStatusCode,
													 @formerEnglishLearnerYearStatusDescription, @formerEnglishLearnerYearStatusEdFactsCode,
													@titleiiiAccountabilityProgressStatusId, @titleiiiAccountabilityProgressStatusCode, 
													@titleiiiAccountabilityProgressStatusDescription, 
													@titleiiiAccountabilityProgressStatusEdFactsCode,
													@titleiiiLanguageInstructionId, @titleiiiLanguageInstructionCode, 
													@titleiiiLanguageInstructionDescription, @titleiiiLanguageInstructionEdFactsCode,
													@proficiencyStatusId, @proficiencyStatusCode, @proficiencyStatusDescription, @proficiencyStatusEdFactsCode
													)

													set identity_insert rds.DimTitleiiiStatuses off

												end
											end
											else
											begin

												if not exists(select 1 from rds.DimTitleiiiStatuses where 
															FormerEnglishLearnerYearStatusCode = @formerEnglishLearnerYearStatusCode 
															and ProficiencyStatusCode =  @proficiencyStatusCode
															and TitleiiiAccountabilityProgressStatusCode = @titleiiiAccountabilityProgressStatusCode 
															and TitleiiiLanguageInstructionCode = @titleiiiLanguageInstructionCode)
												begin

														insert into rds.DimTitleiiiStatuses(
														FormerEnglishLearnerYearStatusId, FormerEnglishLearnerYearStatusCode, 
														FormerEnglishLearnerYearStatusDescription,FormerEnglishLearnerYearStatusEdFactsCode,
														TitleiiiAccountabilityProgressStatusId, TitleiiiAccountabilityProgressStatusCode, 
														TitleiiiAccountabilityProgressStatusDescription, TitleiiiAccountabilityProgressStatusEdFactsCode,
														TitleiiiLanguageInstructionId, TitleiiiLanguageInstructionCode, 
														TitleiiiLanguageInstructionDescription, TitleiiiLanguageInstructionEdFactsCode,
														proficiencyStatusId, proficiencyStatusCode, proficiencyStatusDescription, proficiencyStatusEdFactsCode
														)
														values(
														@formerEnglishLearnerYearStatusId, @formerEnglishLearnerYearStatusCode, 
														@formerEnglishLearnerYearStatusDescription, @formerEnglishLearnerYearStatusEdFactsCode,
														@titleiiiAccountabilityProgressStatusId, @titleiiiAccountabilityProgressStatusCode, 
														@titleiiiAccountabilityProgressStatusDescription, @titleiiiAccountabilityProgressStatusEdFactsCode,
														@titleiiiLanguageInstructionId, @titleiiiLanguageInstructionCode, 
														@titleiiiLanguageInstructionDescription, @titleiiiLanguageInstructionEdFactsCode,
														@proficiencyStatusId, @proficiencyStatusCode, @proficiencyStatusDescription, @proficiencyStatusEdFactsCode
														)

												end
											end

						FETCH NEXT FROM proficiencyStatus_cursor INTO @proficiencyStatusId, @proficiencyStatusCode, @proficiencyStatusDescription, @proficiencyStatusEdFactsCode
						END

						CLOSE proficiencyStatus_cursor
						DEALLOCATE proficiencyStatus_cursor



				FETCH NEXT FROM titleiiiLanguageInstruction_cursor INTO @titleiiiLanguageInstructionId, @titleiiiLanguageInstructionCode, @titleiiiLanguageInstructionDescription, @titleiiiLanguageInstructionEdFactsCode
				END

				CLOSE titleiiiLanguageInstruction_cursor
				DEALLOCATE titleiiiLanguageInstruction_cursor


			FETCH NEXT FROM titleiiiAccountabilityProgressStatus_cursor INTO @titleiiiAccountabilityProgressStatusId, @titleiiiAccountabilityProgressStatusCode, @titleiiiAccountabilityProgressStatusDescription, @titleiiiAccountabilityProgressStatusEdFactsCode
			END

			CLOSE titleiiiAccountabilityProgressStatus_cursor
			DEALLOCATE titleiiiAccountabilityProgressStatus_cursor
	

		FETCH NEXT FROM formerEnglishLearnerYearStatus_cursor INTO @formerEnglishLearnerYearStatusId, @formerEnglishLearnerYearStatusCode, @formerEnglishLearnerYearStatusDescription, @formerEnglishLearnerYearStatusEdFactsCode
		END

		CLOSE formerEnglishLearnerYearStatus_cursor
		DEALLOCATE formerEnglishLearnerYearStatus_cursor

		Update rds.FactStudentCounts set DimProgramStatusId = -1, DimStudentStatusId = -1, DimNorDProgramStatusId = -1, DimEnrollmentId = -1
		Update rds.FactStudentAssessments set DimProgramStatusId = -1, DimStudentStatusId = -1, DimNorDProgramStatusId = -1
		Update rds.FactStudentDisciplines set DimProgramStatusId = -1

		delete from rds.DimProgramStatuses
		where DimProgramStatusId in (
		select st.DimProgramStatusId from
		(select FoodServiceEligibilityCode, FosterCareProgramCode, ImmigrantTitleIIIProgramCode, Section504ProgramCode, 
		TitleiiiProgramParticipationCode, HomelessServicedIndicatorCode, min(DimProgramStatusId) as DimProgramStatusId from rds.DimProgramStatuses
		group by FoodServiceEligibilityCode, FosterCareProgramCode, ImmigrantTitleIIIProgramCode, Section504ProgramCode, 
		TitleiiiProgramParticipationCode, HomelessServicedIndicatorCode) statuses
		right outer join (select * from rds.DimProgramStatuses) st on statuses.DimProgramStatusId = st.DimProgramStatusId
		where statuses.DimProgramStatusId IS NULL)

		delete from rds.DimStudentStatuses
		where DimStudentStatusId in (
		select st.DimStudentStatusId from
		(select DiplomaCredentialTypeCode,MobilityStatus12moCode,MobilityStatusSYCode,ReferralStatusCode,MobilityStatus36moCode,PlacementStatusCode,PlacementTypeCode,
		 min(DimStudentStatusId) as DimStudentStatusId from rds.DimStudentStatuses
		group by DiplomaCredentialTypeCode,MobilityStatus12moCode,MobilityStatusSYCode,ReferralStatusCode,MobilityStatus36moCode,PlacementStatusCode,PlacementTypeCode) statuses
		right outer join (select * from rds.DimStudentStatuses) st on statuses.DimStudentStatusId = st.DimStudentStatusId
		where statuses.DimStudentStatusId IS NULL)

		delete from rds.DimEnrollment
		where DimEnrollmentId in (
		select st.DimEnrollmentId from
		(select PostSecondaryEnrollmentStatusCode, min(DimEnrollmentId) as DimEnrollmentId from rds.DimEnrollment
		group by PostSecondaryEnrollmentStatusCode) statuses
		right outer join (select * from rds.DimEnrollment) st on statuses.DimEnrollmentId = st.DimEnrollmentId
		where statuses.DimEnrollmentId IS NULL)

		delete from rds.DimNorDProgramStatuses where DimNorDProgramStatusId > 0
				

		if not exists(select 1 from rds.DimEnrollmentStatuses)
		BEGIN
			set identity_insert rds.DimEnrollmentStatuses on
				insert into rds.DimEnrollmentStatuses(DimEnrollmentStatusId,ExitOrWithdrawalCode,ExitOrWithdrawalDescription,ExitOrWithdrawalEdFactsCode,ExitOrWithdrawalId)
				values(-1,'MISSING','Missing','MISSING',-1)
			set identity_insert rds.DimEnrollmentStatuses off

			insert into rds.DimEnrollmentStatuses(ExitOrWithdrawalCode,ExitOrWithdrawalDescription,ExitOrWithdrawalEdFactsCode,ExitOrWithdrawalId)
			select Code, [Description], Code, RefExitOrWithdrawalTypeId
			from ods.RefExitOrWithdrawalType
		END
		
		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'datapopulation'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'submission'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimCteStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END
				
		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'cte'
		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimCteStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'specedexit'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimCteStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'membership'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimCteStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'grad'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimCteStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'gradrate'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimCteStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'other'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimCteStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'childcount'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'chronic'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'dropout'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'homeless'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimProgramStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'hsgradenroll'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END
		
		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'immigrant'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'mep'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'nord'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'titleI'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'titleIIIELOct'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		select @factTypeId = dimfacttypeid from rds.DimFactTypes where FactTypeCode = 'titleIIIELSY'

		select @dimensionTableId = dimensionTableId from app.DimensionTables where DimensionTableName = 'DimEnrollmentStatuses'

		if not exists(select 1 from rds.DimFactType_DimensionTables where DimFactTypeId = @factTypeId and DimensionTableId = @dimensionTableId)
		BEGIN
			INSERT INTO [RDS].[DimFactType_DimensionTables](DimFactTypeId,DimensionTableId) values(@factTypeId, @dimensionTableId)
		END

		Update rds.DimSchoolStatuses set VirtualSchoolStatusCode = 'SupplementalVirtual'
		Where VirtualSchoolStatusCode = 'SUPPVIRTUAL'

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
