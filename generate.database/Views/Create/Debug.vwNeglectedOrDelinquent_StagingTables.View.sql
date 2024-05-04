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
		, ssrd3.OutputCode 'NeglectedOrDelingquentProgramEnrollmentSubpartEdFactsCode'
		, nord.ProgramParticipationBeginDate
		, nord.ProgramParticipationEndDate
		, nord.NeglectedOrDelinquentProgramType
		, ssrd2.OutputCode 'NeglectedOrDelinquentProgramTypeEdFactsCode'
		, nord.NeglectedOrDelinquentAcademicAchievementIndicator
		, nord.NeglectedOrDelinquentAcademicOutcomeIndicator
		, nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType	
		, ssrd.OutputCode 'EdFactsAcademicOrCareerAndTechnicalOutcomeTypeEdFactsCode'
		, nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType
		, ssrd1.OutputCode 'EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode'
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

	LEFT JOIN Staging.SourceSystemReferenceData SSRD
		on SSRD.Schoolyear = enrollment.SchoolYear
		and ssrd.tablename = 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeType'
		and nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType = ssrd.InputCode

	LEFT JOIN staging.SourceSystemReferenceData SSRD1
		on SSRD1.Schoolyear = enrollment.SchoolYear
		and SSRD1.tablename = 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeExitType'
		and nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType = SSRD1.InputCode

	LEFT JOIN staging.SourceSystemReferenceData SSRD2
		on SSRD2.Schoolyear = enrollment.SchoolYear
		and SSRD2.tablename = 'RefNeglectedOrDelinquentProgramType'
		and nord.NeglectedOrDelinquentProgramType = SSRD2.InputCode

	LEFT JOIN staging.SourceSystemReferenceData SSRD3
		on SSRD3.Schoolyear = enrollment.SchoolYear
		and SSRD3.tablename = 'RefNeglectedOrDelinquentProgramEnrollmentSubpart'
		and nord.NeglectedOrDelinquentProgramEnrollmentSubpart = SSRD3.InputCode


		--AND		ISNULL(nord.ProgramParticipationEndDate, enrollment.EnrollmentExitDate) >= enrollment.EnrollmentEntryDate

	--WHERE 1 = 1
	--AND ISNULL(nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType, '') <> ''
	--	OR ISNULL(nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType, '') <> ''

