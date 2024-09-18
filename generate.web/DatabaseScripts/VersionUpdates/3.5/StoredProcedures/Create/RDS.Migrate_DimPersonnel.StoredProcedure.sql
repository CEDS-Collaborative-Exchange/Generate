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

		 ;WITH DATECTE AS (
              SELECT
                       PersonId
                     , RecordStartDateTime
					 , RecordEndDateTime
                     , ROW_NUMBER() OVER(PARTITION BY PersonId ORDER BY RecordStartDateTime, RecordEndDateTime) AS SequenceNumber
              FROM (
                           SELECT DISTINCT 
                                    PersonId
                                  , RecordStartDateTime
                                  , RecordEndDateTime
                           FROM ods.PersonDetail
                           WHERE RecordStartDateTime IS NOT NULL

                     ) dates
       )
       , CTE as 
		( 
			select distinct p.PersonId
				, p.FirstName
				, p.MiddleName
				, p.LastName
				, p.BirthDate 
				, pi.Identifier
				, @personnelRole as PersonnelRole,
				 startDate.RecordStartDateTime AS RecordStartDateTime,
				ISNULL(startDate.RecordEndDateTime, endDate.RecordStartDateTime - 1) AS RecordEndDateTime
			from DATECTE startDate
            LEFT JOIN DATECTE endDate ON startDate.PersonId = endDate.PersonId AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
			inner join ods.PersonDetail p ON p.PersonId = startDate.PersonId  
											AND startDate.RecordStartDateTime BETWEEN p.RecordStartDateTime AND ISNULL(p.RecordEndDateTime, GETDATE())
			inner join ods.OrganizationPersonRole r on r.PersonId = p.PersonId and r.RoleId = @teacherRoleId		  
			left join ods.PersonIdentifier pi on pi.PersonId = p.PersonId
				AND pi.RefPersonIdentificationSystemId = @stateIdentificationSystemId
				AND pi.RefPersonalInformationVerificationId = @stateIssuedId
		)
		MERGE rds.DimPersonnel as trgt
		USING CTE as src
				ON  trgt.StatePersonnelIdentifier = src.Identifier
				AND trgt.PersonnelRole = src.PersonnelRole
				AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
		WHEN MATCHED THEN
				Update SET trgt.Birthdate = src.Birthdate,
				 trgt.FirstName = src.FirstName,
				 trgt.LastName = src.LastName,
				 trgt.MiddleName = src.MiddleName,
				 trgt.RecordEndDateTime = src.RecordEndDateTime 
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but not in Target
		INSERT([BirthDate],[FirstName],[LastName],[MiddleName],[StatePersonnelIdentifier],PersonnelRole,RecordStartDateTime, RecordEndDateTime)
		Values(src.Birthdate, src.FirstName, src.LastName, src.MiddleName, src.Identifier, src.PersonnelRole, src.RecordStartDateTime, src.RecordEndDateTime);


		;WITH upd AS(
				SELECT DimPersonnelId, StatePersonnelIdentifier, RecordStartDateTime, 
				LEAD(RecordStartDateTime, 1, 0) OVER (PARTITION BY StatePersonnelIdentifier ORDER BY RecordStartDateTime ASC) AS endDate 
			FROM rds.DimPersonnel  
			WHERE RecordEndDateTime is null and PersonnelRole = @personnelRole
		) 
		UPDATE personnel SET RecordEndDateTime = upd.endDate -1 
		FROM rds.DimPersonnel personnel
		inner join upd	on personnel.DimPersonnelId = upd.DimPersonnelId
		WHERE upd.endDate <> '1900-01-01 00:00:00.000'



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