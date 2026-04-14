CREATE PROCEDURE [RDS].[Migrate_DimSchoolYears_K12Students]
	@factTypeCode AS VARCHAR(50),
	@migrationType AS VARCHAR(50),
	@selectedSchoolYear AS INT,
	@isPriorYear AS BIT = 0, 
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT = 0
AS
BEGIN

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

	declare @useCutOffDate as bit
	set @useCutOffDate = 0

	if @factTypeCode in ('childcount','membership','titleIIIELOct','specedexit')
	BEGIN
		set @useCutOffDate = 1
	END

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
		set @referencePeriodEndMonth = '09'
		set @referencePeriodEndDay = '30'

		if @factTypeCode in ('dropout')
		begin
			set @cutOffMonth = 10
			set @cutOffDay = 1
		end

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

		set @cutOffMonth = 7
		set @cutOffDay = 31
	
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
	else if @factTypeCode in ('childcount','membership','titleIIIELOct', 'specedexit')
	begin
	

		declare @customFactTypeDate as varchar(10)
		set @customFactTypeDate = null
		
		if @factTypeCode in ('childcount', 'specedexit')
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


	DECLARE 
		  @personIdSystemId INT
		, @PersonIdTypeId INT
		
	SELECT @PersonIdTypeId = RefPersonIdentifierTypeId 
	FROM dbo.RefPersonIdentifierType 
	WHERE Code = '001075'

	SELECT @personIdSystemId = RefPersonIdentificationSystemId 
	FROM dbo.RefPersonIdentificationSystem 
	WHERE Code = 'State'
		AND RefPersonIdentifierTypeId = @PersonIdTypeId

	SELECT DISTINCT 
		s.DimK12StudentId,
		pi.PersonId AS PersonId,
		sy.DimSchoolYearId,
		d.DimDateId,
		CASE @useCutOffDate
			WHEN 1 THEN DATEFROMPARTS(CASE WHEN @cutOffMonth >= 7 THEN sy.SchoolYear - 1 ELSE sy.SchoolYear END, @cutOffMonth, @cutOffDay)
			ELSE sy.SessionEndDate 
		END AS CountDate,
		sy.SchoolYear,
		sy.SessionBeginDate,
		sy.SessionEndDate,
		s.RecordStartDateTime,
		ISNULL(s.RecordEndDateTime, dc.DataCollectionCloseDate)
 	FROM rds.DimK12Students s
	LEFT JOIN dbo.DataCollection dc 
		ON dc.DataCollectionId = @dataCollectionId
	INNER LOOP JOIN dbo.PersonIdentifier pi 
		ON s.StateStudentIdentifier = pi.Identifier 
		AND (@dataCollectionId IS NULL 
			OR pi.DataCollectionId = @dataCollectionId)
		AND pi.RefPersonIdentificationSystemId = @personIdSystemId
	INNER LOOP JOIN dbo.PersonDetail pd 
		ON pi.PersonId = pd.PersonId
		AND ISNULL(s.FirstName, 'MISSING') = ISNULL(pd.FirstName, 'MISSING')
		AND ISNULL(s.MiddleName, 'MISSING') = ISNULL(pd.MiddleName, 'MISSING')
		AND ISNULL(s.LastName, 'MISSING') = ISNULL(pd.LastName, 'MISSING')
		AND ISNULL(s.BirthDate, '1900-01-01') = ISNULL(pd.Birthdate, '1900-01-01')
		AND (@dataCollectionId IS NULL 
			OR pi.DataCollectionId = pd.DataCollectionId)
		AND ((@loadAllForDataCollection = 1 OR @dataCollectionId IS NULL)
			OR s.RecordStartDateTime <= ISNULL(pd.RecordEndDateTime, dc.DataCollectionCloseDate)
			AND (s.RecordEndDateTime IS NULL
				OR s.RecordEndDateTime >= pd.RecordStartDateTime))
	INNER LOOP JOIN dbo.RefSex rs
		ON pd.RefSexId = rs.RefSexId
		AND rs.Code = s.SexCode
	INNER LOOP JOIN rds.DimSchoolYears sy  
		ON sy.DimSchoolYearId = @selectedSchoolYear
		AND s.RecordStartDateTime <= sy.SessionEndDate
		AND ISNULL(s.RecordEndDateTime, GETDATE()) >= sy.SessionBeginDate
	INNER LOOP JOIN rds.DimDates d
		ON CASE @useCutOffDate
			WHEN 1 THEN DATEFROMPARTS(CASE WHEN @cutOffMonth >= 7 THEN sy.SchoolYear - 1 ELSE sy.SchoolYear END, @cutOffMonth, @cutOffDay)
			ELSE sy.SessionEndDate 
		END = d.DateValue
	WHERE sy.DimSchoolYearId <> -1 
		AND s.DimK12StudentId <> -1

END