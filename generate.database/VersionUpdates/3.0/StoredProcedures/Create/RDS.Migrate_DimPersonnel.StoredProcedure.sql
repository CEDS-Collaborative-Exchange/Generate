CREATE PROCEDURE [RDS].[Migrate_DimPersonnel]
AS
BEGIN

	SET NOCOUNT ON;

	begin try
		begin transaction
	

		if not exists (select 1 from RDS.DimPersonnel where DimPersonnelId = -1)
		begin

			set identity_insert RDS.DimPersonnel on

			insert into RDS.DimPersonnel
			(DimPersonnelId)
			values
			(-1)
	
			set identity_insert RDS.DimPersonnel off
		end


		-- Lookup Values

		declare @teacherRoleId as int
		select @teacherRoleId = RoleId
		from ods.[Role] where Name = 'K12 Personnel'

		declare @staffIdentifierTypeId as int
		select @staffIdentifierTypeId = RefPersonIdentifierTypeId
		from ods.RefPersonIdentifierType
		where [Code] = '001074'

		declare @schoolIdentificationSystemId as int
		select @schoolIdentificationSystemId = RefPersonIdentificationSystemId
		from ods.RefPersonIdentificationSystem
		where [Code] = 'School' and RefPersonIdentifierTypeId = @staffIdentifierTypeId

		declare @stateIdentificationSystemId as int
		select @stateIdentificationSystemId = RefPersonIdentificationSystemId
		from ods.RefPersonIdentificationSystem
		where [Code] = 'State' and RefPersonIdentifierTypeId = @staffIdentifierTypeId

		declare @stateIssuedId as int
		select @stateIssuedId = RefPersonalInformationVerificationId
		from ods.RefPersonalInformationVerification
		where [Code] = '01011'


		declare @personnelRole varchar(50) = 'K12 Personnel'

		-- Create DimStudents

		insert into rds.DimPersonnel
		(
			PersonnelPersonId,
			FirstName,
			MiddleName,
			LastName,
			BirthDate,
			StatePersonnelIdentifier,
			PersonnelRole
		)
		SELECT 
			  p.PersonId
			, p.FirstName
			, p.MiddleName
			, p.LastName
			, p.BirthDate 
			, pi.Identifier
			, @personnelRole 
		FROM ods.PersonDetail p
		JOIN ods.PersonIdentifier pi
			ON p.PersonId = pi.PersonId
			AND pi.RefPersonIdentificationSystemId = @stateIdentificationSystemId
			AND pi.RefPersonalInformationVerificationId = @stateIssuedId
		JOIN ods.OrganizationPersonRole r 
			ON p.PersonId = r.PersonId
			AND r.RoleId = @teacherRoleId
		LEFT JOIN rds.DimPersonnel dim
			ON pi.Identifier = dim.StatePersonnelIdentifier
		WHERE p.RecordEndDateTime IS NULL
			AND dim.DimPersonnelId IS NULL

		INSERT INTO [RDS].[BridgePersonnelDate]
        ([DimPersonnelId]
        ,[DimDateId])
		SELECT p.DimPersonnelId, d.DimDateId
		FROM rds.DimDates d
		CROSS JOIN rds.DimPersonnel p
		JOIN rds.DimDateDataMigrationTypes dd 
			ON dd.DimDateId=d.DimDateId 
		JOIN rds.DimDataMigrationTypes b 
			ON b.DimDataMigrationTypeId=dd.DataMigrationTypeId 
		LEFT JOIN rds.BridgePersonnelDate bpd
			ON p.DimPersonnelId = bpd.DimPersonnelId
			AND d.DimDateId = bpd.DimDateId
		WHERE d.DimDateId <> -1 
			AND dd.IsSelected=1 
			AND DataMigrationTypeCode='ods'
			and bpd.DimPersonnelId IS NULL

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


	SET NOCOUNT OFF;

END


