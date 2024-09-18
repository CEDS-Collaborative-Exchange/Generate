-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction

	if not exists	(SELECT * 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='FK_FactStudentAssessments_DimNorDProgramStatuses' )
	begin
		print 'no'
		ALTER TABLE [RDS].[FactStudentAssessments]
		ADD CONSTRAINT FK_FactStudentAssessments_DimNorDProgramStatuses FOREIGN KEY (DimNorDProgramStatusId)     
		REFERENCES [RDS].DimNorDProgramStatuses (DimNorDProgramStatusId)     
	end


	-- c202
	if not exists	(SELECT * 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='FK_FactOrganizationStatusCounts_DimStateDefinedCustomIndicators' )
	begin
		print 'no'
		ALTER TABLE [RDS].[FactOrganizationStatusCounts]
		ADD CONSTRAINT FK_FactOrganizationStatusCounts_DimStateDefinedCustomIndicators FOREIGN KEY (DimStateDefinedCustomIndicatorId)
		REFERENCES [RDS].DimStateDefinedCustomIndicators (DimStateDefinedCustomIndicatorId)
	end

	-- MEP
	if not exists	(SELECT * 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='FK_FactOrganizationStatusCounts_DimIndicatorStatusTypes' )
	begin
		print 'no'
		ALTER TABLE [RDS].[FactOrganizationStatusCounts]
		ADD CONSTRAINT FK_FactOrganizationStatusCounts_DimIndicatorStatusTypes FOREIGN KEY (DimIndicatorStatusTypeId)
		REFERENCES [RDS].DimIndicatorStatusTypes (DimIndicatorStatusTypeId)
	end
	
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