CREATE PROCEDURE App.[Run_Before_Tests]
	@submissionYear int = NULL
AS
BEGIN

    SET NOCOUNT ON;
		
		
		Declare @dimSchoolYearId as INT
		
		select @dimSchoolYearId = DimSchoolYearId FROM [RDS].[DimSchoolYears] WHERE SchoolYear = @submissionYear

		update App.ToggleResponses set ResponseValue = '10/01/' + CAST(@submissionYear - 1 AS VARCHAR) where ToggleResponseId = 1

		--Reset the Membership date in toggle so it comes after the RecordStartDateTime of the Organizations
		update tr
		set ResponseValue = '10/21/' + CAST(@submissionYear - 1 AS VARCHAR)
		from App.ToggleResponses tr 
		inner join app.ToggleQuestions tq
			on tr.ToggleQuestionId = tq.ToggleQuestionId	
			and tq.EmapsQuestionAbbrv = 'MEMBERDTE'

		UPDATE [RDS].[DimSchoolYearDataMigrationTypes]  SET IsSelected = 0 
		UPDATE [RDS].[DimSchoolYearDataMigrationTypes]  SET IsSelected = 1 WHERE DimSchoolYearId = @dimSchoolYearId

		TRUNCATE TABLE App.ToggleAssessments

			;WITH CTE AS (
				SELECT DISTINCT 
				AssessmentTitle
				, AssessmentTypeAdministered
				, AssessmentAcademicSubject
				, AssessmentPerformanceLevelLabel
			FROM Staging.Assessment sa
			)
			INSERT INTO App.ToggleAssessments
			SELECT
				sa.AssessmentTitle
				, CASE sa.AssessmentTypeAdministered
					WHEN 'ALTASSALTACH'			THEN 'Alternate assessments based on alternate achievement standards'
					WHEN 'ALTASSGRADELVL'		THEN 'Alternate assessments based on grade-level achievement standards'
					WHEN 'ALTASSMODACH'			THEN 'Alternate assessments based on modified achievement standards'
					WHEN 'REGASSWACC'			THEN 'Regular assessments based on grade-level achievement standards with accommodations'
					WHEN 'REGASSWOACC'			THEN 'Regular assessments based on grade-level achievement standards without accommodations'
					WHEN 'ADVASMTWACC'			THEN 'Advanced assessment with accommodations'
					WHEN 'ADVASMTWOACC'			THEN 'Advanced assessment without accommodations'
					WHEN 'HSREGASMTIWACC'		THEN 'High school regular assessment I, with accommodations'
					WHEN 'HSREGASMTIWOACC'		THEN 'High school regular assessment I, without accommodations'
					WHEN 'HSREGASMT2WACC'		THEN 'High school regular assessment II, with accommodations'
					WHEN 'HSREGASMT2WOACC'		THEN 'High school regular assessment II, without accommodations'
					WHEN 'HSREGASMT3WACC'		THEN 'High school regular assessment III, with accommodations'
					WHEN 'HSREGASMT3WOACC'		THEN 'High school regular assessment III, without accommodations'
					WHEN 'IADAPLASMTWOACC'		THEN 'Innovative Assessment Demonstration Authority (IADA) pilot assessment without accommodations'
					WHEN 'IADAPLASMTWACC'		THEN 'Innovative Assessment Demonstration Authority (IADA) pilot assessment with accommodations'
					WHEN 'LSNRHSASMTWOACC'		THEN 'Locally-selected nationally recognized high school assessment without accommodations'
					WHEN 'LSNRHSASMTWACC'		THEN 'Locally-selected nationally recognized high school assessment with accommodations'
					WHEN 'ALTASSALTACH_1'		THEN 'Alternate assessments based on alternate achievement standards'
					WHEN 'ALTASSGRADELVL_1'		THEN 'Alternate assessments based on grade-level achievement standards'
					WHEN 'ALTASSMODACH_1'		THEN 'Alternate assessments based on modified achievement standards'
					WHEN 'REGASSWACC_1'			THEN 'Regular assessments based on grade-level achievement standards with accommodations'
					WHEN 'REGASSWOACC_1'		THEN 'Regular assessments based on grade-level achievement standards without accommodations'
					WHEN 'ADVASMTWACC_1'		THEN 'Advanced assessment with accommodations'
					WHEN 'ADVASMTWOACC_1'		THEN 'Advanced assessment without accommodations'
					WHEN 'HSREGASMTIWACC_1'		THEN 'High school regular assessment I, with accommodations'
					WHEN 'HSREGASMTIWOACC_1'	THEN 'High school regular assessment I, without accommodations'
					WHEN 'HSREGASMT2WACC_1'		THEN 'High school regular assessment II, with accommodations'
					WHEN 'HSREGASMT2WOACC_1'	THEN 'High school regular assessment II, without accommodations'
					WHEN 'HSREGASMT3WACC_1'		THEN 'High school regular assessment III, with accommodations'
					WHEN 'HSREGASMT3WOACC_1'	THEN 'High school regular assessment III, without accommodations'
					WHEN 'IADAPLASMTWOACC_1'	THEN 'Innovative Assessment Demonstration Authority (IADA) pilot assessment without accommodations'
					WHEN 'IADAPLASMTWACC_1'		THEN 'Innovative Assessment Demonstration Authority (IADA) pilot assessment with accommodations'
					WHEN 'LSNRHSASMTWOACC_1'	THEN 'Locally-selected nationally recognized high school assessment without accommodations'
					WHEN 'LSNRHSASMTWACC_1'		THEN 'Locally-selected nationally recognized high school assessment with accommodations'
				END
				, replace(sa.AssessmentTypeAdministered, '_1', '')
				, 'End of Grade'
				, left(replace(sar.GradeLevelWhenAssessed, '_1', ''), 2) 
				, COUNT(DISTINCT sar.AssessmentPerformanceLevelLabel)
				, '3'
				, CASE sa.AssessmentAcademicSubject
					WHEN '01166'	THEN 'MATH'
					WHEN '13373'	THEN 'RLA'
					WHEN '73065'	THEN 'CTE'
					WHEN '00562'	THEN 'SCIENCE'
					WHEN '01166_1'	THEN 'MATH'
					WHEN '13373_1'	THEN 'RLA'
					WHEN '73065_1'	THEN 'CTE'
					WHEN '00562_1'	THEN 'SCIENCE'
				END
			FROM CTE sa
			JOIN Staging.AssessmentResult sar
				ON sa.AssessmentTitle = sar.AssessmentTitle
				AND sa.AssessmentAcademicSubject = sar.AssessmentAcademicSubject
				AND sa.AssessmentPerformanceLevelLabel = sar.AssessmentPerformanceLevelLabel
			LEFT JOIN App.ToggleAssessments ata
				ON sa.AssessmentTitle = ata.AssessmentName
				AND sa.AssessmentTypeAdministered = ata.AssessmentTypeCode
				AND sar.GradeLevelWhenAssessed = ata.Grade
				AND CASE sa.AssessmentAcademicSubject
					WHEN '01166' THEN 'MATH'
					WHEN '13373' THEN 'RLA'
					WHEN '73065' THEN 'CTE'
					WHEN '00562' THEN 'SCIENCE'
					WHEN '01166_1'	THEN 'MATH'
					WHEN '13373_1'	THEN 'RLA'
					WHEN '73065_1'	THEN 'CTE'
					WHEN '00562_1'	THEN 'SCIENCE'
				END = ata.Subject
			WHERE sa.AssessmentAcademicSubject NOT IN ('00256', '00256_1') -- ESL
				AND ata.ToggleAssessmentId IS NULL
				AND GradeLevelWhenAssessed NOT IN ('abe', 'abe_1')
			GROUP BY 
				sa.AssessmentTitle
				, sa.AssessmentTypeAdministered
				, sar.GradeLevelWhenAssessed
				, sa.AssessmentAcademicSubject



	SET NOCOUNT OFF;

END