CREATE PROCEDURE [RDS].[Migrate_DimK12Staff]
AS
BEGIN

	SET NOCOUNT ON;

	begin try
		begin transaction
	

		if not exists (select 1 from RDS.DimK12Staff where DimK12StaffId = -1)
		begin

			set identity_insert RDS.DimK12Staff on

			insert into RDS.DimK12Staff
			(DimK12StaffId)
			values
			(-1)
	
			set identity_insert RDS.DimK12Staff off
		end


		-- Lookup Values

		declare @teacherRoleId as int
		select @teacherRoleId = RoleId
		from dbo.[Role] where Name = 'K12 Personnel'

		declare @staffIdentifierTypeId as int
		select @staffIdentifierTypeId = RefPersonIdentifierTypeId
		from dbo.RefPersonIdentifierType
		where [Code] = '001074'

		declare @schoolIdentificationSystemId as int
		select @schoolIdentificationSystemId = RefPersonIdentificationSystemId
		from dbo.RefPersonIdentificationSystem
		where [Code] = 'School' and RefPersonIdentifierTypeId = @staffIdentifierTypeId

		declare @stateIdentificationSystemId as int
		select @stateIdentificationSystemId = RefPersonIdentificationSystemId
		from dbo.RefPersonIdentificationSystem
		where [Code] = 'State' and RefPersonIdentifierTypeId = @staffIdentifierTypeId

		declare @stateIssuedId as int
		select @stateIssuedId = RefPersonalInformationVerificationId
		from dbo.RefPersonalInformationVerification
		where [Code] = '01011'


		declare @k12StaffRole varchar(50) = 'K12 Personnel'

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
                           FROM dbo.PersonDetail
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
				, @k12StaffRole as K12StaffRole,
				 startDate.RecordStartDateTime AS RecordStartDateTime,
				ISNULL(startDate.RecordEndDateTime, endDate.RecordStartDateTime - 1) AS RecordEndDateTime
			from DATECTE startDate
            LEFT JOIN DATECTE endDate ON startDate.PersonId = endDate.PersonId AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
			inner join dbo.PersonDetail p ON p.PersonId = startDate.PersonId  
											AND startDate.RecordStartDateTime BETWEEN p.RecordStartDateTime AND ISNULL(p.RecordEndDateTime, GETDATE())
			inner join dbo.OrganizationPersonRole r on r.PersonId = p.PersonId and r.RoleId = @teacherRoleId		  
			left join dbo.PersonIdentifier pi on pi.PersonId = p.PersonId
				AND pi.RefPersonIdentificationSystemId = @stateIdentificationSystemId
				AND pi.RefPersonalInformationVerificationId = @stateIssuedId
		)
		MERGE rds.DimK12Staff as trgt
		USING CTE as src
				ON  trgt.StaffMemberIdentifierState = src.Identifier
				AND trgt.K12StaffRole = src.K12StaffRole
				AND ISNULL(trgt.RecordStartDateTime, '') = ISNULL(src.RecordStartDateTime, '')
		WHEN MATCHED THEN
				Update SET trgt.Birthdate = src.Birthdate,
				 trgt.FirstName = src.FirstName,
				 trgt.LastOrSurname = src.LastName,
				 trgt.MiddleName = src.MiddleName,
				 trgt.RecordEndDateTime = src.RecordEndDateTime 
		WHEN NOT MATCHED BY TARGET THEN     --- Records Exists in Source but not in Target
		INSERT([BirthDate],[FirstName],[LastOrSurname],[MiddleName],[StaffMemberIdentifierState],K12StaffRole,RecordStartDateTime, RecordEndDateTime)
		Values(src.Birthdate, src.FirstName, src.LastName, src.MiddleName, src.Identifier, src.K12StaffRole, src.RecordStartDateTime, src.RecordEndDateTime);


		;WITH upd AS(
				SELECT DimK12StaffId, StaffMemberIdentifierState, RecordStartDateTime, 
				LEAD(RecordStartDateTime, 1, 0) OVER (PARTITION BY StaffMemberIdentifierState ORDER BY RecordStartDateTime ASC) AS endDate 
			FROM rds.DimK12Staff  
			WHERE RecordEndDateTime is null and K12StaffRole = @k12StaffRole
		) 
		UPDATE personnel SET RecordEndDateTime = upd.endDate -1 
		FROM rds.DimK12Staff personnel
		inner join upd	on personnel.DimK12StaffId = upd.DimK12StaffId
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