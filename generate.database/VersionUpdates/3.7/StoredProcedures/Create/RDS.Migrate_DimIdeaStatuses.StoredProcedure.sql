CREATE PROCEDURE [RDS].[Migrate_DimIdeaStatuses]
    @studentDates AS StudentDateTableType READONLY,
    @factTypeCode AS VARCHAR(50),
    @useCutOffDate AS BIT
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
    --declare     @factTypeCode as varchar(50) = 'chronic'
    --declare     @factTypeCode as varchar(50) = 'cte'
    --declare     @factTypeCode as varchar(50) = 'datapopulation'
    --declare     @factTypeCode as varchar(50) = 'dropout'
    --declare     @factTypeCode as varchar(50) = 'grad'
    --declare     @factTypeCode as varchar(50) = 'gradrate'
    --declare     @factTypeCode as varchar(50) = 'homeless'
    --declare     @factTypeCode as varchar(50) = 'hsgradenroll'
    --declare     @factTypeCode as varchar(50) = 'mep'
    --declare     @factTypeCode as varchar(50) = 'nord'
    --declare     @factTypeCode as varchar(50) = 'other'
    --declare     @factTypeCode as varchar(50) = 'specedexit'
    --declare     @factTypeCode as varchar(50) = 'sppapr'
    --declare     @factTypeCode as varchar(50) = 'submission' --Discipline, Assessments
    --declare     @factTypeCode as varchar(50) = 'titleI'
    --declare     @factTypeCode as varchar(50) = 'titleIIIELOct'

    ----variable for UseCutOffDate, uncomment the appropriate one
    ----If you're working on     'childcount','titleIIIELOct'
    --declare @useCutOffDate as bit = 1
    ----otherwise
    --declare @useCutOffDate as bit = 0

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

    DECLARE @k12StudentRoleId AS INT,
            @schoolOrganizationTypeId AS INT,
            @specialEdProgramTypeId AS INT;

    SELECT @k12StudentRoleId = RoleId
    FROM ods.[Role]
    WHERE Name = 'K12 Student';
    SELECT @schoolOrganizationTypeId = RefOrganizationTypeId
    FROM ods.RefOrganizationType
    WHERE code = 'K12School';
    SELECT @specialEdProgramTypeId = RefProgramTypeId
    FROM ods.RefProgramType
    WHERE code = '04888';

    DECLARE @ideaStatusTypeId AS INT;
    SELECT @ideaStatusTypeId = RefPersonStatusTypeId
    FROM ods.RefPersonStatusType
    WHERE code = 'IDEA';

    DECLARE @ctePerkDisab AS VARCHAR(50);

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
    FROM RDS.Get_StudentOrganizations(@studentDates, @useCutOffDate);

    SELECT @ctePerkDisab = r.ResponseValue
    FROM app.ToggleResponses r
        INNER JOIN app.ToggleQuestions q
            ON r.ToggleQuestionId = q.ToggleQuestionId
    WHERE q.EmapsQuestionAbbrv = 'CTEPERKDISAB';

    DECLARE @isADADisability AS BIT;
    SET @isADADisability = 0;

    IF @factTypeCode = 'cte'
       AND @ctePerkDisab = 'ADA Disability'
    BEGIN
        SET @isADADisability = 1;
    END;

    CREATE TABLE #DATECTE
    (
        PersonId INT,
        RecordStartDateTime DATETIME,
        SequenceNumber INT
    );

    CREATE NONCLUSTERED INDEX IX_DATECTE
    ON #DATECTE (
                    PersonId,
                    RecordStartDateTime
                );

    INSERT INTO #DATECTE
    SELECT PersonId,
           RecordStartDateTime,
           ROW_NUMBER() OVER (PARTITION BY PersonId ORDER BY RecordStartDateTime) AS SequenceNumber
    FROM
    (
        SELECT DISTINCT
               PersonId,
               RecordStartDateTime
        FROM ods.PersonDetail
        WHERE RecordStartDateTime IS NOT NULL
        UNION
        SELECT DISTINCT
               PersonId,
               RecordStartDateTime
        FROM ods.PersonDisability
        WHERE RecordStartDateTime IS NOT NULL
        UNION
        SELECT DISTINCT
               PersonId,
               StatusStartDate
        FROM ods.PersonStatus
        WHERE StatusStartDate IS NOT NULL
              AND RefPersonStatusTypeId = 3 --IDEA 
              AND StatusValue = 1
        UNION
        SELECT DISTINCT
               PersonId,
               DATEADD(DAY, 1, StatusEndDate)
        FROM ods.PersonStatus
        WHERE StatusEndDate IS NOT NULL
              AND RefPersonStatusTypeId = 3 --IDEA
              AND StatusValue = 1
        UNION
        SELECT DISTINCT
               opr.personid,
               ppse.RecordStartDateTime
        FROM ods.organizationpersonrole opr
            INNER JOIN ods.PersonProgramParticipation ppp
                ON opr.organizationpersonroleid = ppp.OrganizationPersonRoleId
            INNER JOIN ods.ProgramParticipationSpecialEducation ppse
                ON ppp.PersonProgramParticipationId = ppse.PersonProgramParticipationId
        WHERE ppse.RecordStartDateTime IS NOT NULL
    ) dates;


    SELECT DISTINCT
           s.DimStudentId,
           r.DimSchoolId,
           r.DimLeaId,
           r.DimSeaId,
           s.PersonId,
           s.DimCountDateId,
           CASE
               WHEN @useCutOffDate = 1 THEN
                   CASE
                       WHEN statusIdea.StatusValue IS NULL THEN
                           'MISSING'
                       WHEN s.SubmissionYearDate
                            BETWEEN statusIdea.StatusStartDate AND ISNULL(statusIdea.StatusEndDate, GETDATE()) THEN
                           CASE
                               WHEN statusIdea.StatusValue = 1 THEN
                                   'IDEA'
                               ELSE
                                   'MISSING'
                           END
                       ELSE
                           'MISSING'
                   END
               ELSE
                   CASE
                       WHEN statusIdea.StatusValue IS NULL THEN
                           'MISSING'
                       WHEN statusIdea.StatusStartDate <= s.SubmissionYearEndDate
                            AND ISNULL(statusIdea.StatusEndDate, GETDATE()) >= s.SubmissionYearStartDate THEN
                           CASE
                               WHEN statusIdea.StatusValue = 1 THEN
                                   'IDEA'
                               ELSE
                                   'MISSING'
                           END
                       ELSE
                           'MISSING'
                   END
           END AS IDEAIndicator,
           CASE
               WHEN @isADADisability = 1 THEN
                   IIF(pd.DisabilityStatus = 1, ISNULL(dt.Code, 'MISSING'), 'MISSING')
               ELSE
                   ISNULL(dt.Code, 'MISSING')
           END AS DisabilityCode,
           ISNULL(e.Code, ISNULL(sa.Code, 'MISSING')) AS EducEnvCode,
           ISNULL(exitReason.Code, 'MISSING') AS BasisOfExitCode,
           CASE
               WHEN @factTypeCode = 'specedexit' THEN
                   p.SpecialEducationServicesExitDate
               ELSE
                   NULL
           END AS SpecialEducationServicesExitDate,
           startDate.RecordStartDateTime,
           endDate.RecordStartDateTime - 1 AS RecordEndDateTime
    FROM #DATECTE startDate
        LEFT JOIN #DATECTE endDate
            ON startDate.PersonId = endDate.PersonId
               AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
        INNER JOIN @studentDates s
            ON s.PersonId = startDate.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN s.SubmissionYearStartDate AND ISNULL(s.SubmissionYearEndDate, GETDATE())
        INNER JOIN #studentOrganizations r
            ON s.PersonId = r.PersonId
               AND s.DimCountDateId = r.DimCountDateId
        INNER JOIN ods.OrganizationRelationship ore
            ON IIF(r.OrganizationId > 0, r.OrganizationId, r.LeaOrganizationId) = ore.Parent_OrganizationId
        INNER JOIN ods.OrganizationPersonRole rp
            ON rp.PersonId = s.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN rp.EntryDate AND ISNULL(rp.ExitDate, GETDATE())
               AND rp.EntryDate <= s.SubmissionYearEndDate
               AND
               (
                   rp.ExitDate >= s.SubmissionYearStartDate
                   OR rp.ExitDate IS NULL
               )
               AND ore.OrganizationId = rp.OrganizationId
        INNER JOIN ods.OrganizationProgramType t
            ON t.OrganizationId = rp.OrganizationId
               AND t.RefProgramTypeId = @specialEdProgramTypeId
        LEFT OUTER JOIN ods.PersonDisability pd
            ON pd.PersonId = s.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN pd.RecordStartDateTime AND ISNULL(pd.RecordEndDateTime, GETDATE())
               AND ISNULL(pd.RecordStartDateTime, s.SubmissionYearDate) <= CASE
                                                                               WHEN @useCutOffDate = 0 THEN
                                                                                   s.SubmissionYearEndDate
                                                                               ELSE
                                                                                   s.SubmissionYearDate
                                                                           END
               AND ISNULL(pd.RecordEndDateTime, GETDATE()) >= CASE
                                                                  WHEN @useCutOffDate = 0 THEN
                                                                      s.SubmissionYearStartDate
                                                                  ELSE
                                                                      s.SubmissionYearDate
                                                              END
        LEFT JOIN ods.RefDisabilityType dt
            ON dt.RefDisabilityTypeId = pd.PrimaryDisabilityTypeId
        LEFT JOIN ods.PersonProgramParticipation ppp
            ON rp.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
               AND startDate.RecordStartDateTime
               BETWEEN ppp.RecordStartDateTime AND ISNULL(ppp.RecordEndDateTime, GETDATE())
        LEFT JOIN ods.ProgramParticipationSpecialEducation p
            ON p.PersonProgramParticipationId = ppp.PersonProgramParticipationId
               AND startDate.RecordStartDateTime
               BETWEEN p.RecordStartDateTime AND ISNULL(p.RecordEndDateTime, GETDATE())
        LEFT JOIN ods.RefIDEAEducationalEnvironmentEC e
            ON e.RefIDEAEducationalEnvironmentECId = p.RefIDEAEducationalEnvironmentECId
        LEFT JOIN ods.RefIDEAEducationalEnvironmentSchoolAge sa
            ON sa.RefIDESEducationalEnvironmentSchoolAge = p.RefIDEAEdEnvironmentSchoolAgeId
        LEFT JOIN ods.RefSpecialEducationExitReason exitReason
            ON p.RefSpecialEducationExitReasonId = exitReason.RefSpecialEducationExitReasonId
        LEFT OUTER JOIN ods.PersonStatus statusIdea
            ON s.PersonId = statusIdea.PersonId
               AND statusIdea.RefPersonStatusTypeId = @ideaStatusTypeId
               AND startDate.RecordStartDateTime
               BETWEEN statusIdea.StatusStartDate AND ISNULL(statusIdea.StatusEndDate, GETDATE());

    DROP TABLE #studentOrganizations;
    DROP TABLE #DATECTE;


END;
