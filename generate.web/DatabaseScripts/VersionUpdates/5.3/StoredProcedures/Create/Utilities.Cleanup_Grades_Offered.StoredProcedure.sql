CREATE PROCEDURE [Utilities].[Cleanup_Grades_Offered] (
	@organizationIdentifier nvarchar(25) = null,
	@organizationType as nvarchar(8) = null,
	@gradeLevel as nvarchar(2) = null,
	@schoolYear as smallint = null
)
AS
BEGIN

	/*
		This procedure allows for the deletion of incorrectly added Grade Level records from the 
		rds.BridgeLeaGradeLevels table or the rds.BridgeK12SchoolGradeLevels tables as required.
	
		There are 4 parameters for the stored procedure:
			@organizationIdentifier = The state ID value for the Organization
			@organizationType = One of 2 types, either 'lea' or 'school'
			@gradeLevel = The CEDS grade level code (PK, K, 01, 02, etc...)
			@schoolYear = The 4 digit School Year to limit the removal by

		If the OrganizationIdentifier or OrganizationType parameters are missing the stored 
		procedure will not execute.  
		If the Grade Level parameter is passed in, that single Grade Level value for the 
		Organization will be removed.  If Grade Level is left null, all grades for the Organization 
		will be removed.  
		If the School Year parameter is passed in, the Grade Level(s) chosen by the previous parameter 
		for that organization for that School Year value will be removed.  If School Year is left null, 
		the Grade Level(s) chosen by the previous parameter for that organization will be removed for 
		all years.  
	*/

	--Exit the stored procedure if no Organization ID and Organization Type were provided
	if isnull(@organizationIdentifier, '') <> '' 
		and (@organizationType = 'lea' or @organizationType = 'school')
	begin

		--variable to hold all the dynamically built sql
		declare @deleteSql nvarchar(max)

		--variables to hold the default SY start/end dates 
		if isnull(@schoolYear, '') <> ''
		begin 
			declare @syStart date = CAST('7/1/' + CAST(@schoolYear - 1 AS VARCHAR(4)) AS DATE)
			declare @syEnd date = CAST('6/30/' + CAST(@schoolYear  AS VARCHAR(4)) AS DATE)
		end 

		--Setup the start of the delete based on the Organization Type
		if @organizationType = 'Lea'
			begin
				set @deleteSql = 'delete bgl ' + char(10) +
								'from rds.BridgeLeaGradeLevels bgl ' + char(10) +
								'	inner join rds.dimleas dl ' + char(10) +
								'		on bgl.LeaId = dl.DimLeaId' + char(10)
				--check if the school year was provided and join on it
				if isnull(@schoolYear, '') <> ''
				begin
					set @deleteSql += concat('		and (dl.RecordStartDateTime < ''', @syStart, ''' and isnull(dl.RecordEndDateTime, '''') = '''' ') + char(10) +
									concat('			or (dl.RecordStartDateTime >= ''', @syStart, '''') + char(10) +
									concat('			and isnull(dl.RecordEndDateTime, '''') <= ''', @syEnd, '''))') + char(10)		
				end
			end
		else 
			begin
				set @deleteSql = 'delete bgl ' + char(10) +
								'from rds.BridgeK12SchoolGradeLevels bgl ' + char(10) +
								'	inner join rds.dimK12Schools ds ' + char(10) +
								'		on bgl.K12SchoolId = ds.DimK12SchoolId' + char(10)
				--check if the school year was provided and join on it
				if isnull(@schoolYear, '') <> ''
				begin
					set @deleteSql += concat('		and (ds.RecordStartDateTime < ''', @syStart, ''' and isnull(ds.RecordEndDateTime, '''') = '''' ') + char(10) +
									concat('			or (ds.RecordStartDateTime >= ''', @syStart, '''') + char(10) +
									concat('			and isnull(ds.RecordEndDateTime, '''') <= ''', @syEnd, '''))') + char(10)		
				end
			end

		--Add Grade Level join if it was passed in.
		if isnull(@gradeLevel, '') <> ''
			begin 
				set @deleteSql +=   '	inner join rds.DimGradeLevels dgl ' + char(10) +
									'		on bgl.GradeLevelId = dgl.DimGradeLevelId ' + char(10)
			end

		--Start the WHERE clause conditions
		set @deleteSql +=	'where 1 = 1 ' + char(10)

		--Add Grade Level to the where clause if it was passed in.
		if isnull(@gradeLevel, '') <> ''
			begin 
				set @deleteSql +=   'and dgl.GradeLevelCode = ''' + @gradeLevel + '''' + char(10)
			end

		--Last, add the organization condition based on Organization Type
		if @organizationType = 'Lea'
			begin
				set @deleteSql += 'and dl.LeaIdentifierState = ''' + @organizationIdentifier + ''''
			end
		else 
			begin
				set @deleteSql += 'and ds.SchoolIdentifierState = ''' + @organizationIdentifier + ''''
			end
	
		--	print (@deleteSql)
		exec (@deleteSql)

	end
END