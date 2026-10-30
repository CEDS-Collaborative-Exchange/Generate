CREATE PROCEDURE [Utilities].[Student_StagingToFactDifference] (
	@factTypeCode as nvarchar(25) = null,
	@schoolYear as nvarchar(4) = null
)
AS
BEGIN

	/*
		This utility is designed for use by Student and Staff files, it does 
		not work for any organization files.
		After a successful migration of data from the staging environment to 
		the Fact and Dimension tables, this utility will compare the data in 
		the Fact table against the data returned by the Staging debug view. 
		It will then return any rows that didn't migrate into the Fact table 
		using the debug view to help identify why the record(s) were not 
		migrated.

		There are 2 parameters for this utility, Fact Type Code and School Year.  
		Fact Type Code is required.  If School Year is not included, the code will 
		use the School Year from the most recent migration.

		Sample usage: exec [Utilities].[Student_StagingToFactDifference] 'childcount', '2026'

		--Fact Type Code values
		--------------------------
			childcount
			exiting
			cte
			membership
			dropout
			graduatescompleters
			titleIIIELOct
			titleIIIELSY
			titleI
			migranteducationprogram
			immigrant
			neglectedordelinquent
			homeless
			chronicabsenteeism
			graduationrate
			hsgradpsenroll
			discipline
			assessment
			staff
	*/

	--return if no/invalid Fact Type provided 
	if isnull(@factTypeCode, 'missing') not in (
			select distinct FactTypeCode from rds.DimFactTypes
			where FactTypeCode in ('childcount','exiting','cte','membership','dropout','graduatescompleters',
				'titleIIIELOct','titleIIIELSY','titleI','migranteducationprogram','immigrant','neglectedordelinquent',
				'homeless','chronicabsenteeism','graduationrate','hsgradpsenroll','discipline','assessment','staff')
	)
	begin
		select 'Invalid or missing value provided for FactTypeCode. Valid options are:' ValidValues
		union
		select distinct FactTypeCode 
		from rds.DimFactTypes
		where FactTypeCode in ('childcount','exiting','cte','membership','dropout','graduatescompleters',
				'titleIIIELOct','titleIIIELSY','titleI','migranteducationprogram','immigrant','neglectedordelinquent',
				'homeless','chronicabsenteeism','graduationrate','hsgradpsenroll','discipline','assessment','staff')
		return
	end

	--get the School Year if one not provided
	if isnull(@schoolYear, '') = ''
	begin
	    select @SchoolYear = (	select sy.SchoolYear
								from rds.DimSchoolYearDataMigrationTypes dm
									inner join rds.dimschoolyears sy
										on dm.dimschoolyearid = sy.dimschoolyearid
								where IsSelected = 1
								and dm.DataMigrationTypeId = 3
							)
	end

	--setup for the process
	declare @sql nvarchar(max)
	declare @factTypeId int
	declare @schoolYearId int

	select @factTypeId = (select DimFactTypeId from rds.DimFactTypes where FactTypeCode = @factTypeCode)
	select @schoolYearId = (select DimSchoolYearId from rds.DimSchoolYears where SchoolYear = @schoolYear)

	--execute the code for all student fact types (staff handled below)
	if @factTypeCode <> 'Staff'
	begin

		--drop the temp table just in case 
		set @sql = ' 
		drop table if exists #StudentsNotInFact' + char(10)

		--query to get the students that did not migrate
		set @sql += '
		select distinct p.K12StudentStudentIdentifierState
		into #StudentsNotInFact
		from Staging.K12Enrollment ske
			join rds.DimPeople_Current p
				on ske.StudentIdentifierState = p.K12StudentStudentIdentifierState
				and p.IsActiveK12Student = 1
		where not exists (
			select 1
			from rds.FactK12StudentCounts f
			where f.K12Student_CurrentId = p.DimPersonId
				and f.FactTypeId = ' + convert(varchar, @FactTypeId) + '
				and f.SchoolYearId = ' + convert(varchar, @schoolYearId) + '
		);' + char(10)

		--Get any results and display them using the appropriate staging debug view
		set @sql += '
		select v.*
		from debug.vw' + @FactTypeCode + '_StagingTables v
			join #StudentsNotInFact temp
				on ltrim(rtrim(v.StudentIdentifierState)) = ltrim(rtrim(temp.K12StudentStudentIdentifierState));'

		--print (@sql)
		exec (@sql)
		
	end
	else
	begin

			--drop the temp table just in case 
		set @sql = ' 
		drop table if exists #StaffNotInFact' + char(10)

		--query to get the staff that did not migrate
		set @sql += '
		select distinct p.K12StaffStaffMemberIdentifierState
		into #StaffNotInFact
		from Staging.K12StaffAssignment s
			join rds.DimPeople_Current p
				on s.StaffMemberIdentifierState = p.K12StaffStaffMemberIdentifierState
				and p.IsActiveK12Staff = 1
		where not exists (
			select 1
			from rds.FactK12StudentCounts f
			where f.K12Staff_CurrentId = p.DimPersonId
				and f.FactTypeId = ' + convert(varchar, @FactTypeId) + '
				and f.SchoolYearId = ' + convert(varchar, @SchoolYearId) + '
		);' + char(10)

		--Get any results and display them using the appropriate staging debug view

		set @sql += '
		select v.*
		from debug.vw' + @FactTypeCode + '_StagingTables v
			join #StaffNotInFact s
				on ltrim(rtrim(v.StaffMemberIdentifierState)) = ltrim(rtrim(s.K12StaffStaffMemberIdentifierState));'

		--	print (@sql)
		exec (@sql)
		
	end

END
