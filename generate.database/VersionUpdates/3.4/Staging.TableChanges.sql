-- Staging table changes
----------------------------------
set nocount on
begin try
	begin transaction

		--StateDetail
		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'Staging.StateDetail'))
		BEGIN
			ALTER TABLE Staging.StateDetail
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'Staging.StateDetail'))
		BEGIN
			ALTER TABLE Staging.StateDetail
			ADD RecordEndDateTime datetime NULL
		END

		--Organization
		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LEA_OrganizationOperationalStatusId'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			ADD LEA_OrganizationOperationalStatusId int NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'School_OrganizationOperationalStatusId'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			ADD School_OrganizationOperationalStatusId int NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LEA_RecordStartDateTime'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			ADD LEA_RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LEA_RecordEndDateTime'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			ADD LEA_RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'School_RecordStartDateTime'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			ADD School_RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'School_RecordEndDateTime'  AND Object_ID = Object_ID(N'Staging.Organization'))
		BEGIN
			ALTER TABLE Staging.Organization
			ADD School_RecordEndDateTime datetime NULL
		END

		--OrganizationAddress
		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'Staging.OrganizationAddress'))
		BEGIN
			ALTER TABLE Staging.OrganizationAddress
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'Staging.OrganizationAddress'))
		BEGIN
			ALTER TABLE Staging.OrganizationAddress
			ADD RecordEndDateTime datetime NULL
		END

		--OrganizationGradeOffered
		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'Staging.OrganizationGradeOffered'))
		BEGIN
			ALTER TABLE Staging.OrganizationGradeOffered
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'Staging.OrganizationGradeOffered'))
		BEGIN
			ALTER TABLE Staging.OrganizationGradeOffered
			ADD RecordEndDateTime datetime NULL
		END

		--OrganizationPhone
		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'Staging.OrganizationPhone'))
		BEGIN
			ALTER TABLE Staging.OrganizationPhone
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'Staging.OrganizationPhone'))
		BEGIN
			ALTER TABLE Staging.OrganizationPhone
			ADD RecordEndDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationTelephoneId'  AND Object_ID = Object_ID(N'Staging.OrganizationPhone'))
		BEGIN
			ALTER TABLE Staging.OrganizationPhone
			ADD OrganizationTelephoneId int NULL
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'LEA_OrganizationTelephoneId'  AND Object_ID = Object_ID(N'Staging.OrganizationPhone'))
		BEGIN
			ALTER TABLE Staging.OrganizationPhone
			DROP COLUMN LEA_OrganizationTelephoneId
		END

		IF EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'School_OrganizationTelephoneId'  AND Object_ID = Object_ID(N'Staging.OrganizationPhone'))
		BEGIN
			ALTER TABLE Staging.OrganizationPhone
			DROP COLUMN School_OrganizationTelephoneId
		END

		--Person
		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordStartDateTime'  AND Object_ID = Object_ID(N'Staging.Person'))
		BEGIN
			ALTER TABLE Staging.Person
			ADD RecordStartDateTime datetime NULL
		END

		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'RecordEndDateTime'  AND Object_ID = Object_ID(N'Staging.Person'))
		BEGIN
			ALTER TABLE Staging.Person
			ADD RecordEndDateTime datetime NULL
		END

		--Enrollment
		IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE Name = N'OrganizationPersonRoleRelationshipId'  AND Object_ID = Object_ID(N'Staging.Enrollment'))
		BEGIN
			ALTER TABLE Staging.Enrollment
			ADD OrganizationPersonRoleRelationshipId INT NULL
		END

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