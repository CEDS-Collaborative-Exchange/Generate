CREATE PROCEDURE [RDS].[Migrate_DimDisciplines] @studentDates AS StudentDateTableType READONLY
AS
BEGIN

    /*****************************
For Debugging 
*****************************/
    --declare @studentDates as rds.StudentDateTableType
    --declare @migrationType varchar(3) = 'rds'

    ----select the appropriate date variable, 8=17-18, 9=18-19, 10=19-20, etc...
    --declare @selectedDate int = 9

    ----variable for the file spec, uncomment the appropriate one 
    --declare     @factTypeCode as varchar(50) = 'childcount'
    --declare     @factTypeCode as varchar(50) = 'datapopulation'
    --declare     @factTypeCode as varchar(50) = 'submission' --Discipline, Assessments

    --insert into @studentDates
    --(
    --     DimStudentId,
    --     PersonId,
    --     DimCountDateId,
    --     SubmissionYearDate,
    --     [Year],
    --     SubmissionYearStartDate,
    --     SubmissionYearEndDate
    --)
    --exec rds.Migrate_DimDates_Students @factTypeCode, @migrationType, @selectedDate
    /*****************************
End of Debugging code 
*****************************/

    DECLARE @lepPersonStatusTypeId AS INT;
    SELECT @lepPersonStatusTypeId = RefPersonStatusTypeId
    FROM ods.RefPersonStatusType
    WHERE code = 'LEP';

    CREATE TABLE #studentOrganizations
    (
        DimStudentId INT,
        PersonId INT,
        DimCountDateId INT,
        DimSchoolId INT,
        DimLeaId INT,
        DimSeaId INT,
        OrganizationId INT,
        LeaOrganizationId INT
    );

    INSERT INTO #studentOrganizations
    (
        DimStudentId,
        PersonId,
        DimCountDateId,
        DimSchoolId,
        DimLeaId,
        DimSeaId,
        OrganizationId,
        LeaOrganizationId
    )
    SELECT DimStudentId,
           PersonId,
           DimCountDateId,
           DimSchoolId,
           DimLeaId,
           DimSeaId,
           OrganizationId,
           LeaOrganizationId
    FROM RDS.Get_StudentOrganizations(@studentDates, 0);

    SELECT s.DimStudentId,
           r.PersonId,
           d.DimCountDateId,
           ISNULL(org.DimSchoolId, -1) AS DimSchoolId,
           NULL AS DimLeaId,
           NULL AS DimSeaId,
           dis.IncidentId,
           ISNULL(act.Code, 'MISSING') AS DisciplineActionCode,
           CASE
               WHEN act.Code IN ( '03086', '03087', '03101', '03102', '03154', '03155' ) THEN
                   'OUTOFSCHOOL'
               WHEN act.Code IN ( '03100' ) THEN
                   'INSCHOOL'
               ELSE
                   'MISSING'
           END AS DisciplineMethodCode,
           CASE
               WHEN act.Code IN ( '03086' ) THEN
                   'SERVPROV'
               WHEN act.Code IN ( '03087' ) THEN
                   'SERVNOTPROV'
               ELSE
                   'MISSING'
           END AS EducationalServicesCode,
           CASE
               WHEN removalReason.Code IN ( 'Drugs' ) THEN
                   'D'
               WHEN removalReason.Code IN ( 'Weapons' ) THEN
                   'W'
               WHEN removalReason.Code IN ( 'SeriousBodilyInjury' ) THEN
                   'SBI'
               ELSE
                   'MISSING'
           END AS RemovalReasonCode,
           CASE
               WHEN removalType.Code IN ( 'REMDW' )
                    OR act.Code IN ( '03156', '03157' ) THEN
                   'REMDW'
               WHEN removalType.Code IN ( 'REMHO' )
                    OR act.Code IN ( '03158' ) THEN
                   'REMHO'
               ELSE
                   'MISSING'
           END AS RemovalTypeCode,
           CASE
               WHEN statusLep.StatusValue IS NULL THEN
                   'MISSING'
               WHEN (
                        statusLep.StatusStartDate IS NULL
                        AND statusLep.StatusEndDate IS NULL
                    )
                    OR
                    (
                        NOT statusLep.StatusStartDate IS NULL
                        AND NOT statusLep.StatusEndDate IS NULL
                        AND statusLep.StatusStartDate <= d.SubmissionYearStartDate
                        AND statusLep.StatusEndDate >= d.SubmissionYearEndDate
                        AND dis.DisciplinaryActionStartDate
                    BETWEEN statusLep.StatusStartDate AND statusLep.StatusEndDate
                    )
                    OR
                    (
                        NOT statusLep.StatusStartDate IS NULL
                        AND statusLep.StatusEndDate IS NULL
                        AND statusLep.StatusStartDate <= d.SubmissionYearStartDate
                        AND statusLep.StatusStartDate <= dis.DisciplinaryActionStartDate
                    ) THEN
                   CASE
                       WHEN statusLep.StatusValue = 1 THEN
                           'LEP'
                       ELSE
                           'NLEP'
                   END
               ELSE
                   'MISSING'
           END AS LepStatusCode,
           ISNULL(dis.DurationOfDisciplinaryAction, 0.0) AS DisciplineDuration,
           dis.DisciplinaryActionStartDate
    INTO #Disciplines
    FROM rds.DimStudents s
        INNER JOIN @studentDates d
            ON s.DimStudentId = d.DimStudentId
        INNER JOIN #studentOrganizations org
            ON s.DimStudentId = org.DimStudentId
               AND d.DimCountDateId = org.DimCountDateId
        INNER JOIN ods.OrganizationDetail od
            ON org.OrganizationId = od.OrganizationId
        INNER JOIN ods.RefOrganizationType ot
            ON od.RefOrganizationTypeId = ot.RefOrganizationTypeId
               AND ot.Code = 'K12School'
        INNER JOIN ods.OrganizationPersonRole r
            ON d.PersonId = r.PersonId
               AND r.OrganizationId = org.OrganizationId
               AND r.EntryDate <= d.SubmissionYearEndDate
               AND
               (
                   r.ExitDate >= d.SubmissionYearStartDate
                   OR r.ExitDate IS NULL
               )
        INNER JOIN ods.K12studentDiscipline dis
            ON r.OrganizationPersonRoleId = dis.OrganizationPersonRoleId
               AND
               (
                   dis.DisciplinaryActionStartDate
               BETWEEN d.SubmissionYearStartDate AND d.SubmissionYearEndDate
                   OR dis.DisciplinaryActionEndDate IS NULL
                   OR dis.DisciplinaryActionEndDate
               BETWEEN d.SubmissionYearStartDate AND d.SubmissionYearEndDate
               )
        LEFT OUTER JOIN ods.PersonStatus statusLep
            ON d.PersonId = statusLep.PersonId
               AND statusLep.RefPersonStatusTypeId = @lepPersonStatusTypeId
               AND dis.DisciplinaryActionStartDate >= CONVERT(DATE, statusLep.StatusStartDate)
               AND dis.DisciplinaryActionStartDate <= CONVERT(
                                                                 DATE,
                                                                 ISNULL(
                                                                           statusLep.StatusEndDate,
                                                                           dis.DisciplinaryActionStartDate
                                                                       )
                                                             )
        LEFT OUTER JOIN ods.RefDisciplinaryActionTaken act
            ON dis.RefDisciplinaryActionTakenId = act.RefDisciplinaryActionTakenId
        LEFT OUTER JOIN ods.RefIDEAInterimRemoval removalType
            ON dis.RefIdeaInterimRemovalId = removalType.RefIDEAInterimRemovalId
        LEFT OUTER JOIN ods.RefIDEAInterimRemovalReason removalReason
            ON dis.RefIdeaInterimRemovalReasonId = removalReason.RefIDEAInterimRemovalReasonId
    WHERE s.DimStudentId <> -1;

    UPDATE #Disciplines
    SET DimLeaId = org.DimLeaId,
        DimSeaId = org.DimSeaId
    FROM #Disciplines d
        INNER JOIN #studentOrganizations org
            ON d.DimStudentId = org.DimStudentId
               AND d.DimCountDateId = org.DimCountDateId
               AND d.DimSchoolId = org.DimSchoolId
        INNER JOIN ods.OrganizationDetail od
            ON org.LeaOrganizationId = od.OrganizationId
        INNER JOIN ods.RefOrganizationType ot
            ON od.RefOrganizationTypeId = ot.RefOrganizationTypeId
               AND ot.Code = 'LEA'
        INNER JOIN ods.OrganizationPersonRole r
            ON d.PersonId = r.PersonId
               AND r.OrganizationId = org.LeaOrganizationId
               AND d.DisciplinaryActionStartDate
               BETWEEN r.EntryDate AND ISNULL(r.ExitDate, GETDATE())
        INNER JOIN ods.K12studentDiscipline dis
            ON r.OrganizationPersonRoleId = dis.OrganizationPersonRoleId
               AND dis.DisciplinaryActionStartDate = d.DisciplinaryActionStartDate;


    SELECT *
    FROM #Disciplines;

    DROP TABLE #studentOrganizations;
    DROP TABLE #Disciplines;


END;