



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

		if not exists (select 1 from RDS.DimPersonnel where DimPersonnelId <> -1)
		begin

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

			declare @personnelPersonId as int
			declare @firstName as varchar(500)
			declare @middleName as varchar(500)
			declare @lastName as varchar(500)
			declare @birthDate as datetime
		
			DECLARE personnel_cursor CURSOR FOR 
			SELECT p.PersonId, p.FirstName, p.MiddleName, p.LastName, p.BirthDate 
			FROM ods.PersonDetail p
			WHERE p.PersonId in (select PersonId from 
			ods.OrganizationPersonRole r where p.PersonId = r.PersonId
			and r.RoleId = @teacherRoleId)
			AND p.RecordEndDateTime IS NULL
		
			OPEN personnel_cursor
			FETCH NEXT FROM personnel_cursor INTO @personnelPersonId, @firstName, @middleName, @lastName, @birthDate

			WHILE @@FETCH_STATUS = 0
			BEGIN
				declare @dimPersonnelId int = 0
				declare @statePersonnelIdentifier as varchar(50) 
				select @statePersonnelIdentifier = Identifier
				from ods.PersonIdentifier
				where PersonId = @personnelPersonId
				and RefPersonIdentificationSystemId = @stateIdentificationSystemId
				and RefPersonalInformationVerificationId = @stateIssuedId


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
				values
				(
					@personnelPersonId,
					@firstName,
					@middleName,
					@lastName,
					@birthDate,
					@statePersonnelIdentifier,
					@personnelRole

				)

				set @dimPersonnelId = SCOPE_IDENTITY()

			INSERT INTO [RDS].[BridgePersonnelDate]
           ([DimPersonnelId]
           ,[DimDateId])
			
			SELECT @dimPersonnelId, DimDateId
							from rds.DimDates where DimDateId <> -1


				FETCH NEXT FROM personnel_cursor INTO @personnelPersonId, @firstName, @middleName, @lastName, @birthDate
			END

			CLOSE personnel_cursor
			DEALLOCATE personnel_cursor


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


	SET NOCOUNT OFF;

END


