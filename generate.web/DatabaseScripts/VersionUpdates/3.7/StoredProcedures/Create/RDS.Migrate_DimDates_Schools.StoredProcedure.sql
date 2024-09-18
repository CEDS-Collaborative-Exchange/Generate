CREATE PROCEDURE [RDS].[Migrate_DimDates_Schools]
	@dimSchoolId as int,
	@dimDateId as int
AS
BEGIN


	-- Get Child Count Date

	declare @childCountMonth as varchar(2)
	set @childCountMonth = 11
	declare @childCountDay as varchar(2)
	set @childCountDay = 1

	-- Get Custom Child Count Date (if available)

	declare @customChildCountDate as varchar(10)
	set @customChildCountDate = null
		
	select @customChildCountDate = r.ResponseValue
	from app.ToggleResponses r
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'CHDCTDTE'

	if not @customChildCountDate is null
	begin
		if CHARINDEX('/', @customChildCountDate) > 0
		begin
			select @childCountMonth = SUBSTRING(@customChildCountDate, 0, CHARINDEX('/', @customChildCountDate))
			select @childCountDay = SUBSTRING(@customChildCountDate, CHARINDEX('/', @customChildCountDate) + 1, len(@customChildCountDate))
		end			
	end

	-- Get Reference Period Start

	declare @referencePeriodStartMonth as varchar(2)
	set @referencePeriodStartMonth = 7
	declare @referencePeriodStartDay as varchar(2)
	set @referencePeriodStartDay = 1
	
	-- Get Reference Period End

	declare @referencePeriodEndMonth as varchar(2)
	set @referencePeriodEndMonth = 6
	declare @referencePeriodEndDay as varchar(2)
	set @referencePeriodEndDay = 30


	-- Get Custom Reference Period (if available)

	declare @customReferencePeriod as varchar(10)
	set @customReferencePeriod = 'true'

	select @customReferencePeriod = lower(r.ResponseValue)
	from app.ToggleResponses r
	inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
	where q.EmapsQuestionAbbrv = 'DEFEXREFPER'

	if @customReferencePeriod = 'false'
	begin

		-- Get Custom Reference Period Start (if available)
		
		declare @customReferencePeriodStartDate as varchar(10)
		set @customReferencePeriodStartDate = null

		select @customReferencePeriodStartDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'DEFEXREFDTESTART'
		
		if not @customReferencePeriodStartDate is null
		begin
			if CHARINDEX('/', @customReferencePeriodStartDate) > 0
			begin
				select @referencePeriodStartMonth = SUBSTRING(@customReferencePeriodStartDate, 0, CHARINDEX('/', @customReferencePeriodStartDate))
				select @referencePeriodStartDay = SUBSTRING(@customReferencePeriodStartDate, CHARINDEX('/', @customReferencePeriodStartDate) + 1, len(@customReferencePeriodStartDate))
			end			
		end

		-- Get Custom Reference Period End (if available)
			
		declare @customReferencePeriodEndDate as varchar(10)
		set @customReferencePeriodEndDate = null

		select @customReferencePeriodEndDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'DEFEXREFDTEEND'

		if not @customReferencePeriodEndDate is null
		begin
			if CHARINDEX('/', @customReferencePeriodEndDate) > 0
			begin
				select @referencePeriodEndMonth = SUBSTRING(@customReferencePeriodEndDate, 0, CHARINDEX('/', @customReferencePeriodEndDate))
				select @referencePeriodEndDay = SUBSTRING(@customReferencePeriodEndDate, CHARINDEX('/', @customReferencePeriodEndDate) + 1, len(@customReferencePeriodEndDate))
			end			
		end

	end

	select distinct
		@dimSchoolId,
		d.DimDateId,
		DATEFROMPARTS(d.[Year], @childCountMonth, @childCountDay) as DateValue,
		d.[Year],
		DATEFROMPARTS(d.[Year], @referencePeriodStartMonth, @referencePeriodStartDay) as StartDate,
		DATEFROMPARTS(d.[Year] + 1, @referencePeriodEndMonth, @referencePeriodEndDay) as EndDate
	from rds.DimDates d
	inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId 
	inner join rds.DimDataMigrationTypes b on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
	where d.DimDateId <> -1 and dd.IsSelected=1 and DataMigrationTypeCode= 'rds' and d.DimDateId = @dimDateId
	   	 
END