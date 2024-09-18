CREATE PROCEDURE [RDS].[Migrate_DimDates_Students]
@factTypeCode as varchar(50),
@migrationType as varchar(50)=null,
@selectedDate as int,
@isPriorYear as bit = 0
AS
BEGIN

	-- Get Reference Period Start

	declare @referencePeriodStartMonth as varchar(2)
	declare @referencePeriodStartDay as varchar(2)
	declare @referencePeriodEndMonth as varchar(2)
	declare @referencePeriodEndDay as varchar(2)
	declare @customReferencePeriod as varchar(10)
	declare @customReferencePeriodStartDate as varchar(10)
	declare @customReferencePeriodEndDate as varchar(10)
	declare @priorYearCustomReferencePeriodStartDate as varchar(10)
	declare @priorYearCustomReferencePeriodEndDate as varchar(10)
	declare @cutOffMonth as varchar(2)
	declare @cutOffDay as varchar(2)

	declare @priorYearReferencePeriodStartMonth as varchar(2)
	declare @priorYearReferencePeriodStartDay as varchar(2)
	declare @priorYearReferencePeriodEndMonth as varchar(2)
	declare @priorYearReferencePeriodEndDay as varchar(2)

	set @customReferencePeriodStartDate = null
	set @customReferencePeriodEndDate = null

	set @cutOffMonth = 11
	set @cutOffDay = 1

	set @referencePeriodStartMonth = 7
	set @referencePeriodStartDay = 1
	set @referencePeriodEndMonth = 6
	set @referencePeriodEndDay = 30

	
	if @factTypeCode in ('dropout','grad','titleIIIELSY','titleI','chronic','gradrate')
	begin
	
		set @referencePeriodStartMonth = '10'
		set @referencePeriodStartDay = '01'
		set @referencePeriodStartDay = '09'
		set @referencePeriodEndDay = '30'

	end
	else if @factTypeCode in ('mep')
	begin
		set @referencePeriodStartMonth = '09'
		set @referencePeriodStartDay = '01'
		set @referencePeriodEndMonth = '08'
		set @referencePeriodEndDay = '31'
	end
	else if @factTypeCode in ('datapopulation','sppapr','nord','submission','other','directory','organizationstatus')
	BEGIN

		set @referencePeriodStartMonth = 7
		set @referencePeriodStartDay = 1
		set @referencePeriodEndMonth = 6
		set @referencePeriodEndDay = 30

		-- Get Custom Reference Period (if available)
			
		set @customReferencePeriod = 'true'

		select @customReferencePeriod = lower(r.ResponseValue)
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'DEFEXREFPER'

		if @customReferencePeriod = 'false'
		begin

			-- Get Custom Reference Period Start (if available)

			select @customReferencePeriodStartDate = r.ResponseValue
			from app.ToggleResponses r
			inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
			where q.EmapsQuestionAbbrv = 'DEFEXREFDTESTART'

			-- Get Custom Reference Period End (if available)

			select @customReferencePeriodEndDate = r.ResponseValue
			from app.ToggleResponses r
			inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
			where q.EmapsQuestionAbbrv = 'DEFEXREFDTEEND'
			
		end
				
	END
	else if @factTypeCode = 'cte'
	begin
	
		-- Get Custom Reference Period Start (if available)

		select @customReferencePeriodStartDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'CTEPERKPROGYRSTART'

		-- Get Custom Reference Period End (if available)

		select @customReferencePeriodEndDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'CTEPERKPROGYREND'

	end
	else if @factTypeCode = 'homeless'
	begin
	
		-- Get Custom Reference Period Start (if available)

		select @customReferencePeriodStartDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'STATESYSTARTDTE'

		-- Get Custom Reference Period End (if available)

		select @customReferencePeriodEndDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'STATESYENDDTE'

	end
	else if @factTypeCode in ('titleI','immigrant')
	begin
		select @customReferencePeriodStartDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'INSTSTARTDTE'

		select @customReferencePeriodEndDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'INSTENDDTE'

		
	end
	else if @factTypeCode in ('hsgradenroll')
	begin
		select @customReferencePeriodStartDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'IHETIMEPRDSTARTDTE'

		select @customReferencePeriodEndDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'IHETIMEPRDENDDTE'

		select @priorYearCustomReferencePeriodStartDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'PYINCTIMEPRDSTARTDTE'

		select @priorYearCustomReferencePeriodEndDate = r.ResponseValue
		from app.ToggleResponses r
		inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
		where q.EmapsQuestionAbbrv = 'PYINCTIMEPRDENDDTE'


		if not @priorYearCustomReferencePeriodStartDate is null
		begin
			if CHARINDEX('/', @priorYearCustomReferencePeriodStartDate) > 0
			begin
				select @priorYearReferencePeriodStartMonth = SUBSTRING(@priorYearCustomReferencePeriodStartDate, 0, CHARINDEX('/', @priorYearCustomReferencePeriodStartDate))
				select @priorYearReferencePeriodStartDay = SUBSTRING(@priorYearCustomReferencePeriodStartDate, CHARINDEX('/', @priorYearCustomReferencePeriodStartDate) + 1, 
				len(@priorYearCustomReferencePeriodStartDate))
			end			
		end

		if not @priorYearCustomReferencePeriodEndDate is null
		begin
			if CHARINDEX('/', @priorYearCustomReferencePeriodEndDate) > 0
			begin
				select @priorYearReferencePeriodEndMonth = SUBSTRING(@priorYearCustomReferencePeriodEndDate, 0, CHARINDEX('/', @priorYearCustomReferencePeriodEndDate))
				select @priorYearReferencePeriodEndDay = SUBSTRING(@priorYearCustomReferencePeriodEndDate, CHARINDEX('/', @priorYearCustomReferencePeriodEndDate) + 1, 
				len(@priorYearCustomReferencePeriodEndDate))
			end			
		end


		
	end
	else if @factTypeCode in ('childcount','membership','titleIIIELOct')
	begin
	

		declare @customFactTypeDate as varchar(10)
		set @customFactTypeDate = null
		
		if @factTypeCode = 'childcount'
		begin

			-- Get Child Count Date
			
			set @cutOffMonth = 11
			set @cutOffDay = 1

			-- Get Custom Child Count Date (if available)
			select @customFactTypeDate = r.ResponseValue
			from app.ToggleResponses r
			inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
			where q.EmapsQuestionAbbrv = 'CHDCTDTE'
		end
		else if @factTypeCode = 'membership'
		begin
			select @customFactTypeDate = r.ResponseValue
			from app.ToggleResponses r
			inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
			where q.EmapsQuestionAbbrv = 'MEMBERDTE'
		end
		else if @factTypeCode = 'titleIIIELOct'
		begin

			set @cutOffMonth = 10
			set @cutOffDay = 1

			select @customFactTypeDate = r.ResponseValue
			from app.ToggleResponses r
			inner join app.ToggleQuestions q on r.ToggleQuestionId = q.ToggleQuestionId
			where q.EmapsQuestionAbbrv = 'ELDTE'
		end

		if not @customFactTypeDate is null
		begin
			if CHARINDEX('/', @customFactTypeDate) > 0
			begin
				select @cutOffMonth = SUBSTRING(@customFactTypeDate, 0, CHARINDEX('/', @customFactTypeDate))
				select @cutOffDay = SUBSTRING(@customFactTypeDate, CHARINDEX('/', @customFactTypeDate) + 1, len(@customFactTypeDate))
			end			
		end
		

	end
		
	
	if not @customReferencePeriodStartDate is null
	begin
		if CHARINDEX('/', @customReferencePeriodStartDate) > 0
		begin
			select @referencePeriodStartMonth = SUBSTRING(@customReferencePeriodStartDate, 0, CHARINDEX('/', @customReferencePeriodStartDate))
			select @referencePeriodStartDay = SUBSTRING(@customReferencePeriodStartDate, CHARINDEX('/', @customReferencePeriodStartDate) + 1, len(@customReferencePeriodStartDate))
		end			
	end

	if not @customReferencePeriodEndDate is null
	begin
		if CHARINDEX('/', @customReferencePeriodEndDate) > 0
		begin
			select @referencePeriodEndMonth = SUBSTRING(@customReferencePeriodEndDate, 0, CHARINDEX('/', @customReferencePeriodEndDate))
			select @referencePeriodEndDay = SUBSTRING(@customReferencePeriodEndDate, CHARINDEX('/', @customReferencePeriodEndDate) + 1, len(@customReferencePeriodEndDate))
		end			
	end
		

	select 
		s.DimStudentId,
		s.StudentPersonId as PersonId,
		d.DimDateId,
		DATEFROMPARTS(d.[Year], @cutOffMonth, @cutOffDay) as DateValue,
		d.[Year],
		case when @isPriorYear = 0 then DATEFROMPARTS(d.[Year], @referencePeriodStartMonth, @referencePeriodStartDay)
		else DATEFROMPARTS(d.[Year] - 1, @priorYearReferencePeriodStartMonth, @priorYearReferencePeriodStartDay) end as StartDate,
		case when @isPriorYear = 0 then DATEFROMPARTS(d.[Year] + 1, @referencePeriodEndMonth, @referencePeriodEndDay)
		else DATEFROMPARTS(d.[Year], @priorYearReferencePeriodEndMonth, @priorYearReferencePeriodEndDay) end as EndDate
	from rds.DimStudents s
	cross join rds.DimDates d
	inner join rds.DimDateDataMigrationTypes dd on dd.DimDateId=d.DimDateId 
	inner join rds.DimDataMigrationTypes b on b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
	where d.DimDateId <> -1 
	and s.DimStudentId <> -1
	and dd.IsSelected=1 and DataMigrationTypeCode=@migrationType and d.DimDateId = @selectedDate


END

