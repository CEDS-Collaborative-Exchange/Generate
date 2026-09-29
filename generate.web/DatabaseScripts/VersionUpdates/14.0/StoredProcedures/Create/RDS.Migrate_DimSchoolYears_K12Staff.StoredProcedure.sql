CREATE PROCEDURE [RDS].[Migrate_DimSchoolYears_K12Staff]
	@migrationType AS VARCHAR(50),
	@selectedSchoolYear AS INT,
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

	declare @useCutOffDate as bit
	set @useCutOffDate = 0

	set @customReferencePeriodStartDate = null
	set @customReferencePeriodEndDate = null

	set @cutOffMonth = 11
	set @cutOffDay = 1


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
	WHERE Code = '001074'

	SELECT @personIdSystemId = RefPersonIdentificationSystemId 
	FROM dbo.RefPersonIdentificationSystem 
	WHERE Code = 'State'
		AND RefPersonIdentifierTypeId = @PersonIdTypeId

	SELECT DISTINCT 
		s.DimK12StaffId,
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
 	FROM rds.DimK12Staff s
	LEFT JOIN dbo.DataCollection dc 
		ON dc.DataCollectionId = @dataCollectionId
	INNER LOOP JOIN dbo.PersonIdentifier pi 
		ON s.StaffMemberIdentifierState = pi.Identifier 
		AND (@dataCollectionId IS NULL 
			OR pi.DataCollectionId = @dataCollectionId)
		AND pi.RefPersonIdentificationSystemId = @personIdSystemId
	INNER LOOP JOIN dbo.PersonDetail pd 
		ON pi.PersonId = pd.PersonId
		AND ISNULL(s.FirstName, 'MISSING') = ISNULL(pd.FirstName, 'MISSING')
		AND ISNULL(s.MiddleName, 'MISSING') = ISNULL(pd.MiddleName, 'MISSING')
		AND ISNULL(s.LastOrSurname, 'MISSING') = ISNULL(pd.LastName, 'MISSING')
		AND ISNULL(s.BirthDate, '1900-01-01') = ISNULL(pd.Birthdate, '1900-01-01')
		AND (@dataCollectionId IS NULL 
			OR pi.DataCollectionId = pd.DataCollectionId)
		AND ((@loadAllForDataCollection = 1 OR @dataCollectionId IS NULL)
			OR s.RecordStartDateTime <= ISNULL(pd.RecordEndDateTime, dc.DataCollectionCloseDate)
			AND (s.RecordEndDateTime IS NULL
				OR s.RecordEndDateTime >= pd.RecordStartDateTime))
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
		AND s.DimK12StaffId <> -1

END
