create procedure [RDS].[Migrate_DimStudents]
as
begin

    set nocount on;

    begin try
        begin transaction;


        if not exists (select 1 from RDS.DimStudents where DimStudentId = -1)
        begin

            set identity_insert RDS.DimStudents on;

            insert into RDS.DimStudents
            (
                DimStudentId
            )
            values
            (-1 );

            set identity_insert RDS.DimStudents off;
        end;


        -- Lookup Values

        declare @studentRoleId as int;
        select @studentRoleId = RoleId
        from ods.[Role]
        where Name = 'K12 Student';

        declare @studentIdentifierTypeId as int;
        select @studentIdentifierTypeId = RefPersonIdentifierTypeId
        from ods.RefPersonIdentifierType
        where [Code] = '001075';

        declare @schoolIdentificationSystemId as int;
        select @schoolIdentificationSystemId = RefPersonIdentificationSystemId
        from ods.RefPersonIdentificationSystem
        where [Code] = 'School'
              and RefPersonIdentifierTypeId = @studentIdentifierTypeId;

        declare @stateIdentificationSystemId as int;
        select @stateIdentificationSystemId = RefPersonIdentificationSystemId
        from ods.RefPersonIdentificationSystem
        where [Code] = 'State'
              and RefPersonIdentifierTypeId = @studentIdentifierTypeId;

        declare @stateIssuedId as int;
        select @stateIssuedId = RefPersonalInformationVerificationId
        from ods.RefPersonalInformationVerification
        where [Code] = '01011';
        with DATECTE
        as (select PersonId
                 , RecordStartDateTime
                 , RecordEndDateTime
                 , row_number() over (partition by PersonId
                                      order by RecordStartDateTime
                                             , RecordEndDateTime
                                     ) as SequenceNumber
            from
            (
                select distinct
                       PersonId
                     , RecordStartDateTime
                     , RecordEndDateTime
                from ods.PersonDetail
                where RecordStartDateTime is not null
            ) dates )
           , CTE
        as (select distinct
                   p.FirstName
                 , p.MiddleName
                 , p.LastName
                 , p.BirthDate
                 , pi.Identifier
                 , ch.Cohort
                 , startDate.RecordStartDateTime                                        as RecordStartDateTime
                 , isnull(startDate.RecordEndDateTime, endDate.RecordStartDateTime - 1) as RecordEndDateTime
            from DATECTE                              startDate
                left join DATECTE                     endDate
                    on startDate.PersonId = endDate.PersonId
                       and startDate.SequenceNumber + 1 = endDate.SequenceNumber
                inner join ods.PersonDetail           p
                    on p.PersonId = startDate.PersonId
                       and startDate.RecordStartDateTime
                       between p.RecordStartDateTime and isnull(p.RecordEndDateTime, getdate())
                inner join ods.OrganizationPersonRole r
                    on p.PersonId = r.PersonId
                       and r.RoleId = @studentRoleId
                left join
                (
                    select distinct
                           r2.PersonId
                         , max(c.CohortYear) + '-' + max(c.CohortGraduationYear) as Cohort
                    from ods.OrganizationPersonRole         r2
                        inner join ods.K12StudentEnrollment enr
                            on r2.OrganizationPersonRoleId = enr.OrganizationPersonRoleId
                        inner join ods.RefGradeLevel        grades
                            on enr.RefEntryGradeLevelId = grades.RefGradeLevelId
                        inner join ods.K12StudentCohort     c
                            on r2.OrganizationPersonRoleId = c.OrganizationPersonRoleId
                    where grades.code = '09'
                    group by r2.PersonId
                )                                     as ch
                    on ch.PersonId = r.PersonId
                inner join ods.PersonIdentifier       pi
                    on p.PersonId = pi.PersonId
            where pi.RefPersonIdentificationSystemId = @stateIdentificationSystemId
                  and pi.RefPersonalInformationVerificationId = @stateIssuedId)
        merge rds.DimStudents as trgt
        using CTE as src
        on trgt.StateStudentIdentifier = src.Identifier
           and trgt.RecordStartDateTime = src.RecordStartDateTime
        when matched then
            update set trgt.Birthdate = src.Birthdate
                     , trgt.FirstName = src.FirstName
                     , trgt.LastName = src.LastName
                     , trgt.MiddleName = src.MiddleName
                     , trgt.RecordEndDateTime = src.RecordEndDateTime
                     , trgt.Cohort = src.Cohort
        when not matched by target then --- Records Exists in Source but not in Target
            insert
            (
                [BirthDate]
              , [FirstName]
              , [LastName]
              , [MiddleName]
              , [StateStudentIdentifier]
              , RecordStartDateTime
              , RecordEndDateTime
              , Cohort
            )
            values
            (src.Birthdate, src.FirstName, src.LastName, src.MiddleName, src.Identifier, src.RecordStartDateTime
           , src.RecordEndDateTime, src.Cohort);


        ;with upd
        as (select DimStudentId
                 , StateStudentIdentifier
                 , RecordStartDateTime
                 , lead(RecordStartDateTime, 1, 0) over (partition by StateStudentIdentifier
                                                         order by RecordStartDateTime asc
                                                        ) as endDate
            from rds.DimStudents
            where DimStudentId <> -1)
        update student
        set RecordEndDateTime = upd.endDate - 1
        from rds.DimStudents student
            inner join upd
                on student.DimStudentId = upd.DimStudentId
        where upd.endDate <> '1900-01-01 00:00:00.000'
              and student.RecordEndDateTime is null;


        commit transaction;

    end try
    begin catch

        if @@trancount > 0
        begin
            rollback transaction;
        end;

        declare @msg as nvarchar(max);
        set @msg = error_message();

        declare @sev as int;
        set @sev = error_severity();

        raiserror(@msg, @sev, 1);

    end catch;


    set nocount off;

end;