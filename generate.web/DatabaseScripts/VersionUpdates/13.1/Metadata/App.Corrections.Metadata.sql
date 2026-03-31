-- Corrections to dynamically generated metadata in the App schema (from EDFacts and CEDS)
-- Note - these corrections should eventually be made in the source databases and removed from this file
----------------------------------

set nocount on
begin try
 
	begin transaction

	-- Update EdFactsTableTypeId and TableTypeId with values from existing metadata
	--	This was only necessary because the EdFactsTableTypeId field was just added 
	--	It will not be needed in future releases

	update app.CategorySets set EdFactsTableTypeId = (select EdFactsTableTypeId from App.TableTypes where TableTypeId = cs.TableTypeId)
	from App.CategorySets cs
	where cs.EdFactsTableTypeId is null and cs.TableTypeId is not null

	update app.CategorySets set TableTypeId = (select TableTypeId from App.TableTypes where EdFactsTableTypeId = cs.EdFactsTableTypeId)
	from App.CategorySets cs
	where (cs.TableTypeId is null or cs.TableTypeId = 0) and cs.EdFactsTableTypeId is not null

	Update app.GenerateReports set ReportName = 'C151: Cohorts for Adjusted-Cohort Graduation Rate' where ReportCode = 'c151'

	Update app.CategoryOptions set CategoryOptionName = 'Did not graduate with a regular or alternate high school diploma within the allowable time' where CategoryOptionCode = 'COHNO'

	Update app.CategoryOptions set CategoryOptionName = 'Other Programs' where CategoryOptionName = 'Other programs'
 
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
