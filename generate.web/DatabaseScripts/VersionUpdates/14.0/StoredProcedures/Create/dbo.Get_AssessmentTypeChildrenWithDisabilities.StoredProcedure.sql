CREATE PROCEDURE [dbo].[Get_AssessmentTypeChildrenWithDisabilities]
@subject as varchar(50),
@grade as varchar(50)
AS
BEGIN

	declare @isLowerGrade as bit = 0

	IF @grade IN ('03', '04', '05', '06', '07', '08')
	BEGIN
		set @isLowerGrade = 1
	END
	ELSE IF @grade = '09' AND @subject = 'SCIENCE'
	BEGIN
		set @isLowerGrade = 1
	END

	IF @isLowerGrade = 1
	BEGIN

		SELECT 1 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Regular assessments based on grade-level achievement standards without accommodations' as [Description], 
			   'REGASSWOACC' as Code, 'Regular assessments based on grade-level achievement standards without accommodations' as [Definition], NULL as RefJurisdictionId, 1.0 as SortOrder
		UNION
		SELECT 2 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Regular assessments based on grade-level achievement standards with accommodations' as [Description], 
			   'REGASSWACC' as Code, 'Regular assessments based on grade-level achievement standards with accommodations' as [Definition], NULL as RefJurisdictionId, 2.0 as SortOrder
		UNION
		SELECT 3 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Alternate assessments based on alternate achievement standards' as [Description], 
			   'ALTASSALTACH' as Code, 'Alternate assessments based on alternate achievement standards' as [Definition], NULL as RefJurisdictionId, 3.0 as SortOrder
		UNION
		SELECT 4 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Advanced assessment without accommodations' as [Description], 
			   'ADVASMTWOACC' as Code, 'Advanced assessment without accommodations' as [Definition], NULL as RefJurisdictionId, 4.0 as SortOrder
		FROM app.ToggleQuestions q
			LEFT JOIN app.ToggleResponses r
				ON q.ToggleQuestionId = r.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ASSESSTYPLG'
		AND r.ResponseValue = 'Advanced assessment without accommodations'

		UNION
		SELECT 5 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Advanced assessment with accommodations' as [Description], 
			   'ADVASMTWACC' as Code, 'Advanced assessment with accommodations' as [Definition], NULL as RefJurisdictionId, 5.0 as SortOrder
		FROM app.ToggleQuestions q
			LEFT JOIN app.ToggleResponses r
				ON q.ToggleQuestionId = r.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ASSESSTYPLG'
		AND r.ResponseValue = 'Advanced assessment with accommodations'

		UNION
		SELECT 6 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Innovative assessment Demonstration Authority (IADA) pilot assessment without accommodations' as [Description], 
			   'IADAPLASMTWOACC' as Code, 'Innovative assessment Demonstration Authority (IADA) pilot assessment without accommodations' as [Definition], NULL as RefJurisdictionId, 6.0 as SortOrder
		FROM app.ToggleQuestions q
			LEFT JOIN app.ToggleResponses r
				ON q.ToggleQuestionId = r.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ASSESSTYPLG'
		AND r.ResponseValue = 'Innovative assessment Demonstration Authority (IADA) pilot assessment without accommodations'

		UNION
		SELECT 7 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Innovative assessment Demonstration Authority (IADA) pilot assessment with accommodations' as [Description], 
			   'IADAPLASMTWACC' as Code, 'Innovative assessment Demonstration Authority (IADA) pilot assessment with accommodations' as [Definition], NULL as RefJurisdictionId, 7.0 as SortOrder
		FROM app.ToggleQuestions q
			LEFT JOIN app.ToggleResponses r
				ON q.ToggleQuestionId = r.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ASSESSTYPLG'
		AND r.ResponseValue = 'Innovative assessment Demonstration Authority (IADA) pilot assessment with accommodations'

			--SELECT [RefAssessmentTypeChildrenWithDisabilitiesId]
			--  ,[Description]
			--  ,[Code]
			--  ,[Definition]
			--  ,[RefJurisdictionId]
			--  ,[SortOrder]
		 -- FROM [dbo].[RefAssessmentTypeChildrenWithDisabilities]

	END
	ELSE
	BEGIN

		SELECT 1 as RefAssessmentTypeChildrenWithDisabilitiesId, 'High school regular assessment I, without accommodations' as [Description], 
			   'HSREGASMTIWOACC' as Code, 'High school regular assessment I, without accommodations' as [Definition], NULL as RefJurisdictionId, 1.0 as SortOrder

		UNION
		SELECT 2 as RefAssessmentTypeChildrenWithDisabilitiesId, 'High school regular assessment I, with accommodations' as [Description], 
			   'HSREGASMTIWACC' as Code, 'High school regular assessment I, with accommodations' as [Definition], NULL as RefJurisdictionId, 2.0 as SortOrder

		UNION
		SELECT 3 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Alternate assessment' as [Description], 
			   'ALTASSALTACH' as Code, 'Alternate assessment' as [Definition], NULL as RefJurisdictionId, 3.0 as SortOrder

		UNION
		SELECT 4 as RefAssessmentTypeChildrenWithDisabilitiesId, 'High school regular assessment II, without accommodations' as [Description], 
			   'HSREGASMT2WOACC' as Code, 'High school regular assessment II, without accommodations' as [Definition], NULL as RefJurisdictionId, 4.0 as SortOrder
		FROM app.ToggleQuestions q
			LEFT JOIN app.ToggleResponses r
				ON q.ToggleQuestionId = r.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ASSESSTYPHS'
		AND r.ResponseValue = 'High school regular assessment II, without accommodations'

		UNION
		SELECT 5 as RefAssessmentTypeChildrenWithDisabilitiesId, 'High school regular assessment II, with accommodations' as [Description], 
			   'HSREGASMT2WACC' as Code, 'High school regular assessment II, with accommodations' as [Definition], NULL as RefJurisdictionId, 5.0 as SortOrder
		FROM app.ToggleQuestions q
			LEFT JOIN app.ToggleResponses r
				ON q.ToggleQuestionId = r.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ASSESSTYPHS'
		AND r.ResponseValue = 'High school regular assessment II, with accommodations'

		UNION
		SELECT 6 as RefAssessmentTypeChildrenWithDisabilitiesId, 'High school regular assessment III, without accommodations' as [Description], 
			   'HSREGASMT3WOACC' as Code, 'High school regular assessment III, without accommodations' as [Definition], NULL as RefJurisdictionId, 6.0 as SortOrder
		FROM app.ToggleQuestions q
			LEFT JOIN app.ToggleResponses r
				ON q.ToggleQuestionId = r.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ASSESSTYPHS'
		AND r.ResponseValue = 'High school regular assessment III, without accommodations'

		UNION
		SELECT 7 as RefAssessmentTypeChildrenWithDisabilitiesId, 'High school regular assessment III, with accommodations' as [Description], 
			   'HSREGASMT3WACC' as Code, 'High school regular assessment III, with accommodations' as [Definition], NULL as RefJurisdictionId, 7.0 as SortOrder
		FROM app.ToggleQuestions q
			LEFT JOIN app.ToggleResponses r
				ON q.ToggleQuestionId = r.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ASSESSTYPHS'
		AND r.ResponseValue = 'High school regular assessment III, with accommodations'

		UNION
		SELECT 8 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Advanced assessment without accommodations' as [Description], 
			   'ADVASMTWOACC' as Code, 'Advanced assessment without accommodations' as [Definition], NULL as RefJurisdictionId, 8.0 as SortOrder
		FROM app.ToggleQuestions q
			LEFT JOIN app.ToggleResponses r
				ON q.ToggleQuestionId = r.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ASSESSTYPHS'
		AND r.ResponseValue = 'Advanced assessment without accommodations'

		UNION
		SELECT 9 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Advanced assessment with accommodations' as [Description], 
			   'ADVASMTWACC' as Code, 'Advanced assessment with accommodations' as [Definition], NULL as RefJurisdictionId, 9.0 as SortOrder
		FROM app.ToggleQuestions q
			LEFT JOIN app.ToggleResponses r
				ON q.ToggleQuestionId = r.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ASSESSTYPHS'
		AND r.ResponseValue = 'Advanced assessment with accommodations'

		UNION
		SELECT 10 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Innovative Assessment Demonstration Authority (IADA) pilot assessment without accommodations' as [Description], 
			   'IADAPLASMTWOACC' as Code, 'Innovative Assessment Demonstration Authority (IADA) pilot assessment without accommodations' as [Definition], NULL as RefJurisdictionId, 10.0 as SortOrder
		FROM app.ToggleQuestions q
			LEFT JOIN app.ToggleResponses r
				ON q.ToggleQuestionId = r.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ASSESSTYPHS'
		AND r.ResponseValue = 'Innovative Assessment Demonstration Authority (IADA) pilot assessment without accommodations'

		UNION
		SELECT 11 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Innovative Assessment Demonstration Authority (IADA) pilot assessment with accommodations' as [Description], 
			   'IADAPLASMTWACC' as Code, 'Innovative Assessment Demonstration Authority (IADA) pilot assessment with accommodations' as [Definition], NULL as RefJurisdictionId, 11.0 as SortOrder
		FROM app.ToggleQuestions q
			LEFT JOIN app.ToggleResponses r
				ON q.ToggleQuestionId = r.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ASSESSTYPHS'
		AND r.ResponseValue = 'Innovative Assessment Demonstration Authority (IADA) pilot assessment with accommodations'

		UNION
		SELECT 12 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Locally-selected nationally recognized high school assessment without accommodations' as [Description], 
			   'LSNRHSASMTWOACC' as Code, 'Locally-selected nationally recognized high school assessment without accommodations' as [Definition], NULL as RefJurisdictionId, 12.0 as SortOrder
		FROM app.ToggleQuestions q
			LEFT JOIN app.ToggleResponses r
				ON q.ToggleQuestionId = r.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ASSESSTYPHS'
		AND r.ResponseValue = 'Locally-selected nationally recognized high school assessment without accommodations'

		UNION
		SELECT 13 as RefAssessmentTypeChildrenWithDisabilitiesId, 'Locally-selected nationally recognized high school assessment with accommodations' as [Description], 
			   'LSNRHSASMTWACC' as Code, 'Locally-selected nationally recognized high school assessment with accommodations' as [Definition], NULL as RefJurisdictionId, 13.0 as SortOrder
		FROM app.ToggleQuestions q
			LEFT JOIN app.ToggleResponses r
				ON q.ToggleQuestionId = r.ToggleQuestionId
		WHERE q.EmapsQuestionAbbrv = 'ASSESSTYPHS'
		AND r.ResponseValue = 'Locally-selected nationally recognized high school assessment with accommodations'

	END

END