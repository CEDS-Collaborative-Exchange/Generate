-- Release-Specific table changes for the RDS schema
-- e.g. new fact/dimension tables/fields
----------------------------------
set nocount on
begin try
	begin transaction

	-- c203
	if not exists	(SELECT * 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='FK_K12StaffAssignment_RefUnexperiencedStatus' ) 
	begin
		print 'no'
		ALTER TABLE [ODS].[K12StaffAssignment]
		ADD CONSTRAINT FK_K12StaffAssignment_RefUnexperiencedStatus FOREIGN KEY (RefUnexperiencedStatusId)     
		REFERENCES [ODS].RefUnexperiencedStatus (RefUnexperiencedStatusId)     
	end
	
	if not exists	(SELECT * 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='FK_K12StaffAssignment_RefEmergencyOrProvisionalCredentialStatus' )
	begin
		print 'no'
		ALTER TABLE [ODS].[K12StaffAssignment]
		ADD CONSTRAINT FK_K12StaffAssignment_RefEmergencyOrProvisionalCredentialStatus FOREIGN KEY (RefEmergencyOrProvisionalCredentialStatusId)     
		REFERENCES [ODS].RefEmergencyOrProvisionalCredentialStatus (RefEmergencyOrProvisionalCredentialStatusId)     
	end


	if not exists	(SELECT * 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='FK_K12StaffAssignment_RefOutOfFieldStatus' )
	begin
		print 'no'
		ALTER TABLE [ODS].[K12StaffAssignment]
		ADD CONSTRAINT FK_K12StaffAssignment_RefOutOfFieldStatus FOREIGN KEY (RefOutOfFieldStatusId)     
		REFERENCES [ODS].RefOutOfFieldStatus (RefOutOfFieldStatusId)     
	end

	--c206
	if not exists	(SELECT * 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='FK_K12SchoolStatus_RefComprehensiveAndTargetedSupport' ) 
	begin
		print 'no'
		ALTER TABLE [ODS].[K12SchoolStatus]
		ADD CONSTRAINT FK_K12SchoolStatus_RefComprehensiveAndTargetedSupport FOREIGN KEY (RefComprehensiveAndTargetedSupportId)     
		REFERENCES [ODS].RefComprehensiveAndTargetedSupport (RefComprehensiveAndTargetedSupportId)     
	end
	
	if not exists	(SELECT * 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='FK_K12SchoolStatus_RefComprehensiveSupport' )
	begin
		print 'no'
		ALTER TABLE [ODS].[K12SchoolStatus]
		ADD CONSTRAINT FK_K12SchoolStatus_RefComprehensiveSupport FOREIGN KEY (RefComprehensiveSupportId)     
		REFERENCES [ODS].RefComprehensiveSupport (RefComprehensiveSupportId)     
	end


	if not exists	(SELECT * 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='FK_K12SchoolStatus_RefTargetedSupport' )
	begin
		print 'no'
		ALTER TABLE [ODS].[K12SchoolStatus]
		ADD CONSTRAINT FK_K12SchoolStatus_RefTargetedSupport FOREIGN KEY (RefTargetedSupportId)     
		REFERENCES [ODS].RefTargetedSupport (RefTargetedSupportId)     
	end

	-- c202
	if not exists	(SELECT * 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='FK_K12SchoolIndicatorStatus_RefIndicatorStatusCustomType' ) 
	begin
		print 'no'
		ALTER TABLE [ODS].[K12SchoolIndicatorStatus]
		ADD CONSTRAINT FK_K12SchoolIndicatorStatus_RefIndicatorStatusCustomType FOREIGN KEY (RefIndicatorStatusCustomTypeId)     
		REFERENCES [ODS].RefIndicatorStatusCustomType (RefIndicatorStatusCustomTypeId)     
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