CREATE PROCEDURE [RDS].[Migrate_DimK12StudentStatuses]
    @studentDates AS RDS.K12StudentDateTableType READONLY,
    @studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
    @dataCollectionId AS INT = NULL,
    @loadAllForDataCollection AS BIT = 0
AS
BEGIN


    DECLARE @k12StudentRoleId AS INT;
    DECLARE @schoolOrganizationTypeId AS INT;
    DECLARE @refParticipationTypeId AS INT;
    DECLARE @stateId AS INT;
    SELECT @refParticipationTypeId = RefParticipationTypeId
    FROM dbo.RefParticipationType
    WHERE code = 'MEPParticipation';
    SELECT @k12StudentRoleId = RoleId
    FROM dbo.[Role]
    WHERE Name = 'K12 Student';
    SELECT @schoolOrganizationTypeId = RefOrganizationTypeId
    FROM dbo.RefOrganizationType
    WHERE code = 'K12School';

    SELECT @stateId = rst.RefStateId
    FROM dbo.K12Sea s
        JOIN dbo.RefStateANSICode st
            ON s.RefStateANSICodeId = st.Code
        JOIN dbo.RefState rst
            ON rst.[Description] = st.[Description];

    CREATE TABLE #studentDiploma
    (
        PersonId INT,
        OrganizationId INT,
        Parent_OrganizationId INT,
        EntryDate DATE,
        ExitDate DATE,
        PlacementType VARCHAR(50),
        PlacementStatus VARCHAR(50),
        DiplomaOrCredentialAwardDate VARCHAR(10),
        RefProfessionalTechnicalCredentialTypeId INT
    );

    CREATE NONCLUSTERED INDEX IX_CTE_Person_Organization
    ON #studentDiploma (
                           PersonId,
                           Parent_OrganizationId
                       );


    INSERT INTO #studentDiploma
    (
        PersonId,
        OrganizationId,
        Parent_OrganizationId,
        EntryDate,
        ExitDate,
        PlacementType,
        PlacementStatus,
        DiplomaOrCredentialAwardDate,
        RefProfessionalTechnicalCredentialTypeId
    )
    SELECT 
		   org.PersonId,
		   org.K12SchoolOrganizationId,
		   org.LeaOrganizationId,
           ISNULL(org.K12SchoolEntryDate, org.LeaEntryDate),
           ISNULL(org.K12SchoolExitDate, org.LeaExitDate),
           CASE
               WHEN psEnrll.EntryDateIntoPostSecondary IS NOT NULL THEN
                   'ADVTRAIN'
               WHEN refEmp.code = 'Yes' THEN
                   'EMPLOYMENT'
               WHEN emp.MilitaryEnlistmentAfterExit = 1 THEN
                   'MILITARY'
               WHEN wpp.RefWfProgramParticipationId IS NOT NULL THEN
                   'POSTSEC'
               ELSE
                   'MISSING'
           END AS 'PlacementType',
           CASE
               WHEN
               (
                   psEnrll.EntryDateIntoPostSecondary IS NOT NULL
                   OR refEmp.code = 'Yes'
                   OR emp.MilitaryEnlistmentAfterExit = 1
                   OR wpp.RefWfProgramParticipationId IS NOT NULL
               ) THEN
                   'PLACED'
               ELSE
                   'NOTPLACED'
           END AS 'PlacementStatus',
           diploma.DiplomaOrCredentialAwardDate,
           diploma.RefProfessionalTechnicalCredentialTypeId
    FROM @studentDates s
        JOIN @studentOrganizations org
            ON s.PersonId = org.PersonId
		JOIN dbo.PersonProgramParticipation ppp
            ON ppp.OrganizationPersonRoleId = ISNULL(org.K12SchoolOrganizationPersonRoleId, org.LeaOrganizationPersonRoleId)
               AND ppp.RefParticipationTypeId = @refParticipationTypeId
        LEFT JOIN dbo.WorkforceEmploymentQuarterlyData emp
            ON emp.OrganizationPersonRoleId = ISNULL(org.K12SchoolOrganizationPersonRoleId, org.LeaOrganizationPersonRoleId) -- Military & Employment
        LEFT JOIN dbo.RefEmployedAfterExit refEmp
            ON refEmp.RefEmployedAfterExitId = emp.RefEmployedAfterExitId
        LEFT JOIN dbo.WorkforceProgramParticipation wpp
            ON ppp.PersonProgramParticipationId = wpp.PersonProgramParticipationId --Advanced Training
        LEFT JOIN dbo.RefWfProgramParticipation refpp
            ON refpp.RefWfProgramParticipationId = wpp.RefWfProgramParticipationId
        LEFT JOIN dbo.PsStudentEnrollment psEnrll
            ON psEnrll.[OrganizationPersonRoleId] = ISNULL(org.K12SchoolOrganizationPersonRoleId, org.LeaOrganizationPersonRoleId) ---Postsecondary Education
        LEFT JOIN dbo.K12StudentAcademicRecord diploma
            ON diploma.[OrganizationPersonRoleId] = ISNULL(org.K12SchoolOrganizationPersonRoleId, org.LeaOrganizationPersonRoleId);

    SELECT DISTINCT
           s.DimK12StudentId,
           org.DimK12SchoolId,
           org.DimLeaId,
           org.DimSeaId,
           s.PersonId,
           s.DimCountDateId,
           CASE
               WHEN (ppm.MigrantStudentQualifyingArrivalDate
                    BETWEEN CAST('9/1/' + CAST(YEAR(s.SessionBeginDate) AS VARCHAR(4)) AS DATE) AND CAST('8/31/'
                                                                                                    + CAST(YEAR(s.SessionBeginDate)
                                                                                                           + 1 AS VARCHAR(4)) AS DATE)
                    )
                    AND ppm.MepEligibilityExpirationDate > s.SessionBeginDate THEN
                   'QAD'
               ELSE
                   'MISSING'
           END AS 'MobilityStatus12moCode',
           CASE
               WHEN (ppm.MigrantStudentQualifyingArrivalDate > CAST('9/1/'
                                                                    + CAST((YEAR(s.SessionBeginDate) - 3) AS VARCHAR(4)) AS DATE)
                    )
                    AND ppm.MepEligibilityExpirationDate > s.SessionBeginDate THEN
                   'QAD36'
               ELSE
                   'MISSING'
           END AS 'MobilityStatus36moCode',
           CASE
               WHEN (ppm.MigrantStudentQualifyingArrivalDate
                    BETWEEN s.SessionBeginDate AND s.SessionEndDate
                    )
                    AND ppm.MepEligibilityExpirationDate > s.SessionBeginDate THEN
                   'QMRSY'
               ELSE
                   'MISSING'
           END AS 'MobilityStatusSYCode',
           ISNULL(rmsv.Code, 'MISSING'),
           CASE
               WHEN (
                        (
                            @loadAllForDataCollection = 1
                            OR @dataCollectionId IS NULL
                        )
                        OR sa.DiplomaOrCredentialAwardDate
                    BETWEEN CAST('10/1/' + CAST(YEAR(s.SessionBeginDate) AS VARCHAR(4)) AS DATE) AND CAST('9/30/'
                                                                                                          + CAST(YEAR(s.SessionEndDate) AS VARCHAR(4)) AS DATE)
                    )
                    AND (dt.Code = '00806') THEN
                   'REGDIP'
               WHEN (
                        (
                            @loadAllForDataCollection = 1
                            OR @dataCollectionId IS NULL
                        )
                        OR sa.DiplomaOrCredentialAwardDate
                    BETWEEN CAST('10/1/' + CAST(YEAR(s.SessionBeginDate) AS VARCHAR(4)) AS DATE) AND CAST('9/30/'
                                                                                                          + CAST(YEAR(s.SessionEndDate) AS VARCHAR(4)) AS DATE)
                    )
                    AND (dt.Code = '00811') THEN
                   'OTHCOM'
               WHEN (
                        (
                            @loadAllForDataCollection = 1
                            OR @dataCollectionId IS NULL
                        )
                        OR sa.DiplomaOrCredentialAwardDate
                    BETWEEN CAST('10/1/' + CAST(YEAR(s.SessionBeginDate) AS VARCHAR(4)) AS DATE) AND CAST('9/30/'
                                                                                                          + CAST(YEAR(s.SessionEndDate) AS VARCHAR(4)) AS DATE)
                    )
                    AND (dt.Code = '00816') THEN
                   'HSDGED'
               WHEN (
                        (
                            @loadAllForDataCollection = 1
                            OR @dataCollectionId IS NULL
                        )
                        OR sa.DiplomaOrCredentialAwardDate
                    BETWEEN CAST('10/1/' + CAST(YEAR(s.SessionBeginDate) AS VARCHAR(4)) AS DATE) AND CAST('9/30/'
                                                                                                          + CAST(YEAR(s.SessionEndDate) AS VARCHAR(4)) AS DATE)
                    )
                    AND (dt.Code = '00806')
                    AND
                    (
                        (
                            @loadAllForDataCollection = 1
                            OR @dataCollectionId IS NULL
                        )
                        OR diploma.DiplomaOrCredentialAwardDate
                    BETWEEN CAST('10/1/' + CAST(YEAR(s.SessionBeginDate) AS VARCHAR(4)) AS DATE) AND CAST('9/30/'
                                                                                                          + CAST(YEAR(s.SessionEndDate) AS VARCHAR(4)) AS DATE)
                    )
                    AND diploma.RefProfessionalTechnicalCredentialTypeId IS NOT NULL THEN
                   'HSDPROF'
               ELSE
                   'MISSING'
           END AS 'DiplomaCredentialCode',
           ISNULL(diploma.PlacementType, 'MISSING') AS PlacementType,
           ISNULL(diploma.PlacementStatus, 'MISSING') AS PlacementStatus,
           CASE
               WHEN enr.NSLPDirectCertificationIndicator = 1 THEN
                   'YES'
               WHEN enr.NSLPDirectCertificationIndicator = 0 THEN
                   'NO'
               ELSE
                   'MISSING'
           END AS 'NSLPDirectCertificationIndicatorCode'
    FROM @studentDates s
        JOIN @studentOrganizations org
            ON s.PersonId = org.PersonId
        LEFT JOIN dbo.K12StudentEnrollment enr
            ON enr.OrganizationPersonRoleId = ISNULL(org.K12SchoolOrganizationPersonRoleId, org.LeaOrganizationPersonRoleId)
        LEFT JOIN dbo.PersonProgramParticipation ppp
            ON ppp.OrganizationPersonRoleId = ISNULL(org.K12SchoolOrganizationPersonRoleId, org.LeaOrganizationPersonRoleId)
               AND ppp.RefParticipationTypeId = @refParticipationTypeId
        LEFT JOIN dbo.ProgramParticipationMigrant ppm
            ON ppm.PersonProgramParticipationId = ppp.PersonProgramParticipationId
        LEFT JOIN dbo.K12StudentAcademicRecord sa
            ON sa.OrganizationPersonRoleId = ISNULL(org.K12SchoolOrganizationPersonRoleId, org.LeaOrganizationPersonRoleId)
        LEFT JOIN dbo.RefHighSchoolDiplomaType dt
            ON dt.RefHighSchoolDiplomaTypeId = sa.RefHighSchoolDiplomaTypeId
        LEFT JOIN dbo.RefMepServiceType rmsv
            ON rmsv.RefMepServiceTypeId = ppm.RefMepServiceTypeId
               AND rmsv.Code = 'ReferralServices'
        LEFT JOIN #studentDiploma diploma
            ON s.PersonId = diploma.PersonId
               AND IIF(org.K12SchoolOrganizationId > 0, org.K12SchoolOrganizationId, org.LeaOrganizationId) = diploma.OrganizationId;

    DROP TABLE #studentDiploma;

END;