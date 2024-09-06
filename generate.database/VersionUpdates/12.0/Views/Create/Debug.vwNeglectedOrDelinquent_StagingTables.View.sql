CREATE VIEW [debug].[vwNeglectedOrDelinquent_StagingTables] 
AS
	SELECT	DISTINCT 
		enrollment.StudentIdentifierState
		, enrollment.LEAIdentifierSeaAccountability
		, enrollment.SchoolIdentifierSea
		, enrollment.FirstName
		, enrollment.LastOrSurname
		, enrollment.MiddleName
		, enrollment.SchoolYear
		, enrollment.EnrollmentEntryDate
		, enrollment.EnrollmentExitDate
		
		--Neglected or Delinquent
		, nord.NeglectedOrDelinquentStatus
		, nord.NeglectedOrDelinquentProgramEnrollmentSubpart
		, sssrd3.OutputCode 'NeglectedOrDelingquentProgramEnrollmentSubpartEdFactsCode'
		, nord.ProgramParticipationBeginDate
		, nord.ProgramParticipationEndDate
		, nord.NeglectedOrDelinquentProgramType
		, sssrd2.OutputCode 'NeglectedOrDelinquentProgramTypeEdFactsCode'
		, nord.NeglectedOrDelinquentAcademicAchievementIndicator
		, nord.NeglectedOrDelinquentAcademicOutcomeIndicator
		, nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType	
		, sssrd.OutputCode 'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode'
		, nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType
		, sssrd1.OutputCode 'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode'
		, nord.DiplomaCredentialAwardDate
		, nord.ProgressLevel_Reading
		, nord.ProgressLevel_Math
		, nord.NeglectedProgramType
		, nord.DelinquentProgramType
		
	FROM Staging.K12Enrollment								enrollment		

	INNER JOIN Staging.ProgramParticipationNorD				nord
		ON		enrollment.StudentIdentifierState						=	nord.StudentIdentifierState
		AND		ISNULL(enrollment.LEAIdentifierSeaAccountability, '')	=	ISNULL(nord.LEAIdentifierSeaAccountability, '')
		AND		ISNULL(enrollment.SchoolIdentifierSea, '')				=	ISNULL(nord.SchoolIdentifierSea, '')

	LEFT JOIN Staging.SourceSystemReferenceData sssrd
		on sssrd.Schoolyear = enrollment.SchoolYear
		and sssrd.tablename = 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeType'
		and nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType = sssrd.InputCode

	LEFT JOIN staging.SourceSystemReferenceData sssrd1
		on sssrd1.Schoolyear = enrollment.SchoolYear
		and sssrd1.tablename = 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeExitType'
		and nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType = sssrd1.InputCode

	LEFT JOIN staging.SourceSystemReferenceData sssrd2
		on sssrd2.Schoolyear = enrollment.SchoolYear
		and sssrd2.tablename = 'RefNeglectedOrDelinquentProgramType'
		and nord.NeglectedOrDelinquentProgramType = sssrd2.InputCode

	LEFT JOIN staging.SourceSystemReferenceData sssrd3
		on sssrd3.Schoolyear = enrollment.SchoolYear
		and sssrd3.tablename = 'RefNeglectedOrDelinquentProgramEnrollmentSubpart'
		and nord.NeglectedOrDelinquentProgramEnrollmentSubpart = sssrd3.InputCode
		
		--AND		ISNULL(nord.ProgramParticipationEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate
	--WHERE 1 = 1
	--AND ISNULL(nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType, '') <> ''
	--	OR ISNULL(nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType, '') <> ''

