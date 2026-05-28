CREATE PROCEDURE [RDS].[Migrate_DimK12EnrollmentStatuses]
	@studentDates AS K12StudentDateTableType READONLY,
	@studentOrganizations AS RDS.K12StudentOrganizationTableType READONLY,
	@dataCollectionId AS INT = NULL,
	@loadAllForDataCollection AS BIT = 0
AS
BEGIN
	
	
	DECLARE @k12StudentRoleId AS INT, @studentDiplomaTypeId as int
	SELECT @k12StudentRoleId = RoleId FROM dbo.[Role] WHERE Name = 'K12 Student'
	
	DECLARE @schoolOrgTypeId AS INT
	SELECT @schoolOrgTypeId = RefOrganizationTypeId FROM dbo.RefOrganizationType WHERE Code = 'K12School'

	select @studentDiplomaTypeId = RefHighSchoolDiplomaTypeId from dbo.RefHighSchoolDiplomaType where Code = '00806'

	DECLARE @refParticipationTypeId AS INT
	SELECT @refParticipationTypeId = RefParticipationTypeId FROM dbo.RefParticipationType WHERE code = 'CorrectionalEducationReentryServicesParticipation'

	SELECT DISTINCT
		  s.DimK12StudentId
		, org.DimK12SchoolId
		, org.DimLeaId
		, org.DimSeaId
		, s.PersonId
		, s.DimCountDateId	
		, ISNULL(refExitType.Code, 'MISSING') AS ExitOrWithdrawalCode
		, ISNULL(refes.Code, 'MISSING') AS EnrollmentStatusCode
		, case when psEnrollment.Code is null then 'MISSING'
			 when psEnrollment.Code ='NoInformation'  then 'NO'
			 when psEnrollment.Code ='Enrolled'  then 'ENROLL'
			 when psEnrollment.Code ='NotEnrolled'  then 'NOENROLL'
		END as 'PostSecondaryEnrollmentStatusCode'
		, ISNULL(refet.Code, 'MISSING') AS EntryTypeCode
		, ISNULL(de.DimK12EnrollmentStatusId, -1) AS DimK12EnrollmentStatusId
		,'MISSING'
		,'MISSING'
		--, ISNULL(inProgram.Code,'MISSING')
		--, ISNULL(exitedProgram.Code,'MISSING')
	FROM @studentDates s
	JOIN @studentOrganizations org 
		ON s.DimK12StudentId = org.DimK12StudentId 
		AND s.PersonId = org.PersonId
	JOIN dbo.OrganizationPersonRole r 
		ON r.PersonId = s.PersonId
		AND (@dataCollectionId IS NULL 
				OR r.DataCollectionId = @dataCollectionId)	
		AND r.RoleId = @k12StudentRoleId 
		AND ((@loadAllForDataCollection = 1 OR @dataCollectionId IS NULL)
			OR (r.EntryDate <= s.SessionEndDate 
				AND (r.ExitDate >=  s.SessionBeginDate 
					OR r.ExitDate IS NULL)))
		AND r.OrganizationId = IIF(org.K12SchoolOrganizationId > 0 , org.K12SchoolOrganizationId, org.LeaOrganizationId)
	JOIN dbo.OrganizationDetail od
		ON r.OrganizationId = od.OrganizationId
		AND od.RefOrganizationTypeId = @schoolOrgTypeId
	JOIN dbo.K12StudentEnrollment enr 
		ON enr.OrganizationPersonRoleId = r.OrganizationPersonRoleId 
		AND (@dataCollectionId IS NULL 
			OR enr.DataCollectionId = @dataCollectionId)	
		AND	((@loadAllForDataCollection = 1 OR @dataCollectionId IS NULL)
			OR s.CountDate BETWEEN ISNULL(enr.RecordStartDateTime, s.CountDate) AND ISNULL(enr.RecordEndDateTime, GETDATE()))
	--JOIN dbo.OrganizationPersonRole r2 
	--	ON r2.PersonId = s.PersonId
	--	AND (@dataCollectionId IS NULL 
	--		OR r2.DataCollectionId = @dataCollectionId)	
	--	AND r2.EntryDate <= s.SessionEndDate 
	--	AND (r2.ExitDate >=  s.SessionBeginDate 
	--		OR r2.ExitDate IS NULL)
	--JOIN dbo.OrganizationRelationship ore 
	--	ON r2.OrganizationId = ore.OrganizationId 
	--	AND ore.Parent_OrganizationId = r.OrganizationId
	--	AND (@dataCollectionId IS NULL 
	--		OR ore.DataCollectionId = @dataCollectionId)	
	--JOIN dbo.PersonProgramParticipation ppp 
	--	ON ppp.OrganizationPersonRoleId = r2.OrganizationPersonRoleId 
	--	AND ppp.RefParticipationTypeId = @refParticipationTypeId
	--	AND (@dataCollectionId IS NULL 
	--		OR ppp.DataCollectionId = @dataCollectionId)	
	--LEFT JOIN dbo.ProgramParticipationNeglected ppn 
	--	ON ppn.PersonProgramParticipationId = ppp.PersonProgramParticipationId
	--	AND (@dataCollectionId IS NULL 
	--		OR ppn.DataCollectionId = @dataCollectionId)	
	--LEFT JOIN dbo.RefNeglectedProgramType negprogtype 
	--	ON negprogtype.[RefNeglectedProgramTypeId] = ppn.[RefNeglectedProgramTypeId]
	--LEFT JOIN dbo.RefAcademicCareerAndTechnicalOutcomesInProgram inProgram 
	--	ON inProgram.RefAcademicCareerAndTechnicalOutcomesInProgramId = ppn.RefAcademicCareerAndTechnicalOutcomesInProgramId
	--LEFT JOIN dbo.RefAcademicCareerAndTechnicalOutcomesExitedProgram exitedProgram 
	--	ON exitedProgram.RefAcademicCareerAndTechnicalOutcomesExitedProgramId = ppn.RefAcademicCareerAndTechnicalOutcomesExitedProgramId
	LEFT JOIN dbo.RefEnrollmentStatus refes
		ON enr.RefEnrollmentStatusId = refes.RefEnrollmentStatusId 
	LEFT JOIN dbo.RefEntryType refet
		ON enr.RefEntryType = refet.RefEntryTypeId
	LEFT JOIN dbo.RefExitOrWithdrawalType refExitType 
		ON enr.RefExitOrWithdrawalTypeId = refExitType.RefExitOrWithdrawalTypeId
	LEFT JOIN rds.DimK12EnrollmentStatuses de
		ON ISNULL(refExitType.Code, 'MISSING') = de.ExitOrWithdrawalTypeCode
		AND ISNULL(refes.Code, 'MISSING') = de.EnrollmentStatusCode
		AND 'MISSING' = de.PostSecondaryEnrollmentStatusCode
		AND ISNULL(refet.Code, 'MISSING') = de.EntryTypeCode
	left join dbo.K12StudentAcademicRecord k12AcademicRecord 
		on k12AcademicRecord.OrganizationPersonRoleId = r.OrganizationPersonRoleId 
		and k12AcademicRecord.RefHighSchoolDiplomaTypeId=@studentDiplomaTypeId
		and k12AcademicRecord.DiplomaOrCredentialAwardDate between DateAdd(month,-16,s.SessionEndDate) and s.SessionEndDate
	left join dbo.RefPsEnrollmentAction psEnrollment 
		on psEnrollment.RefPsEnrollmentActionId=k12AcademicRecord.RefPsEnrollmentActionId

END



