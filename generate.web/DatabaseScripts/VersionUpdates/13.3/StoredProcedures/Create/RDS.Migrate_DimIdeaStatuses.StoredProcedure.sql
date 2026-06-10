CREATE PROCEDURE [RDS].[Migrate_DimIdeaStatuses]
	@studentDates AS RDS.K12StudentDateTableType READONLY,
	@factTypeCode AS VARCHAR(50),
	@useCutOffDate AS BIT,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT = 0
AS
BEGIN
    DECLARE @k12StudentRoleId AS INT,
            @schoolOrganizationTypeId AS INT,
            @specialEdProgramTypeId AS INT;
 
    SELECT @k12StudentRoleId = RoleId
    FROM dbo.[Role]
    WHERE Name = 'K12 Student';
    SELECT @schoolOrganizationTypeId = RefOrganizationTypeId
    FROM dbo.RefOrganizationType
    WHERE code = 'K12School';
    SELECT @specialEdProgramTypeId = RefProgramTypeId
    FROM dbo.RefProgramType
    WHERE code = '04888';
 
    DECLARE @ideaStatusTypeId AS INT;
    SELECT @ideaStatusTypeId = RefPersonStatusTypeId
    FROM dbo.RefPersonStatusType
    WHERE code = 'IDEA';
 
    DECLARE @ctePerkDisab AS VARCHAR(50);
 
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
        FROM dbo.PersonDetail
        WHERE RecordStartDateTime IS NOT NULL
        UNION
        SELECT DISTINCT
               PersonId,
               RecordStartDateTime
        FROM dbo.PersonDisability
        WHERE RecordStartDateTime IS NOT NULL
        UNION
        SELECT DISTINCT
               PersonId,
               StatusStartDate
        FROM dbo.PersonStatus
        WHERE StatusStartDate IS NOT NULL
              AND RefPersonStatusTypeId = 3 --IDEA 
              AND StatusValue = 1
        UNION
        SELECT DISTINCT
               PersonId,
               DATEADD(DAY, 1, StatusEndDate)
        FROM dbo.PersonStatus
        WHERE StatusEndDate IS NOT NULL
              AND RefPersonStatusTypeId = 3 --IDEA
              AND StatusValue = 1
        UNION
        SELECT DISTINCT
               opr.personid,
               ppse.RecordStartDateTime
        FROM dbo.organizationpersonrole opr
            INNER JOIN dbo.PersonProgramParticipation ppp
                ON opr.organizationpersonroleid = ppp.OrganizationPersonRoleId
            INNER JOIN dbo.ProgramParticipationSpecialEducation ppse
                ON ppp.PersonProgramParticipationId = ppse.PersonProgramParticipationId
        WHERE ppse.RecordStartDateTime IS NOT NULL
    ) dates;
 

    SELECT DISTINCT
           s.DimK12StudentId,
           r.DimK12SchoolId,
           r.DimLeaId,
           r.DimSeaId,
		   r.DimIeuId,
           s.PersonId,
           s.DimCountDateId,
           CASE
               WHEN @useCutOffDate = 1 THEN
                   CASE
                       WHEN statusIdea.StatusValue IS NULL THEN
                           'MISSING'
                       WHEN s.CountDate
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
                       WHEN statusIdea.StatusStartDate <= s.SessionEndDate
                            AND ISNULL(statusIdea.StatusEndDate, GETDATE()) >= s.SessionBeginDate THEN
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
           endDate.RecordStartDateTime - 1 AS RecordEndDateTime,
		   di.DimIdeaStatusId,
           ISNULL(rdd.DimDateId, -1) AS SpecialEducationServicesExitDateId
    FROM #DATECTE startDate
        LEFT JOIN #DATECTE endDate
            ON startDate.PersonId = endDate.PersonId
               AND startDate.SequenceNumber + 1 = endDate.SequenceNumber
        INNER JOIN @studentDates s
            ON s.PersonId = startDate.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN s.SessionBeginDate AND ISNULL(s.SessionEndDate, GETDATE())
        INNER JOIN @studentOrganizations r
            ON s.PersonId = r.PersonId
               AND s.DimCountDateId = r.DimCountDateId
        INNER JOIN dbo.OrganizationRelationship ore
            ON IIF(r.K12SchoolOrganizationId > 0, r.K12SchoolOrganizationId, r.LeaOrganizationId) = ore.Parent_OrganizationId
        INNER JOIN dbo.OrganizationPersonRole rp
            ON rp.PersonId = s.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN rp.EntryDate AND ISNULL(rp.ExitDate, GETDATE())
               AND ore.OrganizationId = rp.OrganizationId
        INNER JOIN dbo.OrganizationProgramType t
            ON t.OrganizationId = rp.OrganizationId
               AND t.RefProgramTypeId = @specialEdProgramTypeId
        INNER JOIN dbo.PersonDisability pd
            ON pd.PersonId = s.PersonId
               AND startDate.RecordStartDateTime
               BETWEEN pd.RecordStartDateTime AND ISNULL(pd.RecordEndDateTime, GETDATE())
               AND (@loadAllForDataCollection = 1
                   OR (ISNULL(pd.RecordStartDateTime, s.CountDate) <= CASE
                                                                                   WHEN @useCutOffDate = 0 THEN
                                                                                       s.SessionEndDate
                                                                                   ELSE
                                                                                       s.CountDate
                                                                               END
                   AND ISNULL(pd.RecordEndDateTime, GETDATE()) >= CASE
                                                                      WHEN @useCutOffDate = 0 THEN
                                                                          s.SessionBeginDate
                                                                      ELSE
                                                                          s.CountDate
                                                                  END
                    ))
            AND (@dataCollectionId IS NULL 
                OR pd.DataCollectionId = @dataCollectionId)            
		INNER JOIN dbo.RefDisabilityType dt
            ON dt.RefDisabilityTypeId = pd.PrimaryDisabilityTypeId
        INNER JOIN dbo.PersonProgramParticipation ppp
            ON rp.OrganizationPersonRoleId = ppp.OrganizationPersonRoleId
               AND (@loadAllForDataCollection = 1
                   OR (startDate.RecordStartDateTime BETWEEN ppp.RecordStartDateTime AND ISNULL(ppp.RecordEndDateTime, GETDATE())))
        INNER JOIN dbo.ProgramParticipationSpecialEducation p
            ON p.PersonProgramParticipationId = ppp.PersonProgramParticipationId
               AND (@loadAllForDataCollection = 1
                   OR (startDate.RecordStartDateTime BETWEEN p.RecordStartDateTime AND ISNULL(p.RecordEndDateTime, GETDATE())))
        LEFT JOIN dbo.RefIDEAEducationalEnvironmentEC e
            ON e.RefIDEAEducationalEnvironmentECId = p.RefIDEAEducationalEnvironmentECId
        LEFT JOIN dbo.RefIDEAEducationalEnvironmentSchoolAge sa
            ON sa.RefIDEAEducationalEnvironmentSchoolAgeId = p.RefIDEAEducationalEnvironmentSchoolAgeId
        LEFT JOIN dbo.RefSpecialEducationExitReason exitReason
            ON p.RefSpecialEducationExitReasonId = exitReason.RefSpecialEducationExitReasonId
        LEFT OUTER JOIN dbo.PersonStatus statusIdea
            ON s.PersonId = statusIdea.PersonId
               AND statusIdea.RefPersonStatusTypeId = @ideaStatusTypeId
               AND (@loadAllForDataCollection = 1
                    OR (startDate.RecordStartDateTime BETWEEN statusIdea.StatusStartDate AND ISNULL(statusIdea.StatusEndDate, GETDATE())))
 		LEFT JOIN rds.DimDates rdd
            ON p.SpecialEducationServicesExitDate = rdd.DateValue
        LEFT JOIN rds.DimIdeaStatuses di
			ON di.IDEAIndicatorCode = CASE
										WHEN statusIdea.StatusValue = 1 THEN 'IDEA'
										ELSE 'MISSING'
									  END
			AND di.PrimaryDisabilityTypeCode = CASE WHEN @isADADisability = 1 
										THEN IIF(pd.DisabilityStatus = 1, ISNULL(dt.Code, 'MISSING'),'MISSING')
										ELSE ISNULL(dt.Code, 'MISSING') 
									END 
			AND di.IdeaEducationalEnvironmentCode = ISNULL(e.Code, ISNULL(sa.Code, 'MISSING'))
			AND di.SpecialEducationExitReasonCode = ISNULL(exitReason.Code, 'MISSING');

    DROP TABLE #DATECTE;
END
