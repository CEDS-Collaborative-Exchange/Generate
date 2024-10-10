-- Start of DimNOrDStatuses

DECLARE @OutcomeExitType TABLE
(
	TypeName varchar(100)
)

INSERT INTO @OutcomeExitType
SELECT 'EARNCRE'

INSERT INTO @OutcomeExitType
SELECT 'EARNDIPL'

INSERT INTO @OutcomeExitType
SELECT 'EARNGED'

INSERT INTO @OutcomeExitType
SELECT 'ENROLLGED'

INSERT INTO @OutcomeExitType
SELECT 'ENROLLSCH'

INSERT INTO @OutcomeExitType
SELECT 'ENROLLTRAIN'

INSERT INTO @OutcomeExitType
SELECT 'OBTAINEMP'

INSERT INTO @OutcomeExitType
SELECT 'POSTSEC'

INSERT INTO @OutcomeExitType
SELECT 'MISSING'

DECLARE @SubpartCode TABLE
(
	Subpart int
)

INSERT INTO @SubpartCode
SELECT 1

INSERT INTO @SubpartCode
SELECT 2

DECLARE @StatusCode TABLE
(
	Code varchar(50)
)
INSERT INTO @StatusCode
SELECT 'Yes'

INSERT INTO @StatusCode
SELECT 'No'


INSERT INTO [RDS].[DimNOrDStatuses]
           (
		   NeglectedOrDelinquentProgramEnrollmentSubpartCode
		   ,NeglectedOrDelinquentStatusCode
		   ,EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode
		   ,EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode
		   ,EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode
		   )
SELECT Subpart, Code, TypeName, 'MISSING', 'MISSING' from @OutcomeExitType
CROSS JOIN @StatusCode
CROSS JOIN @SubpartCode
LEFT JOIN [RDS].[DimNOrDStatuses] dnor 
	ON dnor.NeglectedOrDelinquentProgramEnrollmentSubpartCode = Subpart
	   AND dnor.NeglectedOrDelinquentStatusCode = Code
	   AND dnor.EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode = TypeName
WHERE dnor.DimNOrDStatusId IS NULL

INSERT INTO [RDS].[DimNOrDStatuses]
           (
		   NeglectedOrDelinquentProgramEnrollmentSubpartCode
		   ,NeglectedOrDelinquentStatusCode
		   ,EdFactsAcademicOrCareerAndTechnicalOutcomeTypeCode
		   ,EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode
		   ,EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode
		   )
SELECT Subpart, Code, 'MISSING', TypeName, TypeName from @OutcomeExitType
CROSS JOIN @StatusCode
CROSS JOIN @SubpartCode
LEFT JOIN [RDS].[DimNOrDStatuses] dnor 
	ON dnor.NeglectedOrDelinquentProgramEnrollmentSubpartCode = Subpart
	   AND dnor.NeglectedOrDelinquentStatusCode = Code
	   AND dnor.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeCode = TypeName
	   AND dnor.EdFactsAcademicOrCareerAndTechnicalOutcomeExitTypeEdFactsCode = TypeName
WHERE dnor.DimNOrDStatusId IS NULL

Update [RDS].[DimNOrDStatuses]
SET NeglectedOrDelinquentLongTermStatusCode = 'MISSING'
	,NeglectedOrDelinquentProgramTypeCode = 'MISSING'
	,NeglectedProgramTypeCode = 'MISSING'
	,DelinquentProgramTypeCode = 'MISSING'
	,NeglectedOrDelinquentAcademicAchievementIndicatorCode = 'MISSING'
	,NeglectedOrDelinquentAcademicOutcomeIndicatorCode = 'MISSING'

-- End of DimNOrDStatuses