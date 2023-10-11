/*  
Used to Archive Toggle questions not used in the code. 
Flatten the data and insert it into new table from ToggleQuestions, ToggleResponses, ToggleQuestionOptions, 
	ToggleQuestionTypes, ToggleSections, ToggleSectionTypes, ToggleParentToggleQuestionID
Delete Data from ToggleQuestions, ToggleQuestionOptions
*/ 

IF OBJECT_ID(N'App.ToggleArchiveQuestions') IS NOT NULL 
	DROP TABLE App.ToggleArchiveQuestions

CREATE TABLE App.ToggleArchiveQuestions (
-- ToggleQuestions
  	[EmapsQuestionAbbrv] [nvarchar](50),
	[QuestionSequence] [int],
	[QuestionText] [nvarchar](max),
--ToggleQuestionOptions
	[OptionSequence] [int],
	[OptionText] [nvarchar](max),
--ToggleQuestionTypes	
	[IsMultiOption] [bit] NOT NULL,
	[ToggleQuestionTypeCode] [nvarchar](50),
	[ToggleQuestionTypeName] [nvarchar](500),
--ToggleSections
	[EmapsParentSurveySectionAbbrv] [nvarchar](50),
	[EmapsSurveySectionAbbrv] [nvarchar](50),
	[SectionName] [nvarchar](2000),
	[SectionSequence] [int],
	[SectionTitle] [nvarchar](500),
--ToggleSectionTypes
	[EmapsSurveyTypeAbbrv] [nvarchar](50) NOT NULL,
	[SectionTypeName] [nvarchar](500) NOT NULL,
	[SectionTypeSequence] [int] NOT NULL,
	[SectionTypeShortName] [nvarchar](100) NOT NULL,
--ToggleParentToggleQuestionID
	ParentToggleQuestionEmapsQuestionAbbrv [nvarchar](50),
--ToggleResults
	[ResponseValue] [nvarchar](max),
	[ResponseQuestionText] [nvarchar](max),
	);

--Join tables to get data from toggle tables and insert
INSERT INTO App.ToggleArchiveQuestions
	SELECT 
		-- ToggleQuestions
		ISNULL(atq.EmapsQuestionAbbrv, -1)
		,ISNULL(atq.QuestionSequence,  -1)
		,ISNULL(atq.QuestionText, -1)
		--ToggleQuestionOptions
		,ISNULL(atqo.OptionSequence,  -1)
		,ISNULL(atqo.OptionText, -1)
		--ToggleQuestionTypes
		,ISNULL(atqt.IsMultiOption,  -1)
		,ISNULL(atqt.ToggleQuestionTypeCode,  -1)
		,ISNULL(atqt.ToggleQuestionTypeName, -1)
		--ToggleSections
		,ISNULL(EmapsParentSurveySectionAbbrv,  -1)
		,ISNULL(EmapsSurveySectionAbbrv,  -1)
		,ISNULL(SectionName, -1)
		,ISNULL(SectionSequence, -1)
		,ISNULL(SectionTitle, -1)
		--ToggleSectionTypes
		,ISNULL(EmapsSurveyTypeAbbrv,  -1)
		,ISNULL(SectionTypeName,  -1)
		,ISNULL(SectionTypeSequence,  -1)
		,ISNULL(SectionTypeShortName, -1)
		--ParentToggleQuestionID
		,ISNULL(atqp.EmapsQuestionAbbrv,-1) AS ParentToggleQuestionEmapsQuestionAbbrv
		--ToggleResults
		,ISNULL(atr.ResponseValue,-1)
		,ISNULL(atqo2.OptionText,-1)

	FROM App.ToggleQuestions atq
	LEFT JOIN App.ToggleQuestionOptions atqo 
		ON atqo.ToggleQuestionId = atq.ToggleQuestionId
	LEFT JOIN App.ToggleQuestionTypes atqt 
		ON atqt.ToggleQuestionTypeId = atq.ToggleQuestionTypeId
	LEFT JOIN App.ToggleSections ats 
		ON ats.ToggleSectionId = atq.ToggleSectionId
	LEFT JOIN App.ToggleSectionTypes atst 
		ON atst.ToggleSectionTypeId = ats.ToggleSectionTypeId
	LEFT JOIN App.ToggleQuestions atqp 
		ON atqp.ToggleQuestionId = atq.ParentToggleQuestionId
	LEFT JOIN App.ToggleResponses atr 
		ON atr.ToggleQuestionId = atq.ToggleQuestionId
	LEFT JOIN App.ToggleQuestionOptions atqo2 	
		ON atqo2.ToggleQuestionOptionId = atr.ToggleQuestionOptionId
	WHERE  atq.EmapsQuestionAbbrv IN ('ASSESLEP',	'CHDCTRPTFOR',	'CHDCTRPTSOP',	'DEFEXCERTNUM',	'DISCPREGPOL',
	'DISCPREM',	'ENVECHM',	'ENVECREGCL',	'ENVECRESFAC',	'ENVECSEPCL',	'ENVECSEPSCH',	'ENVECSERPRV',	'ENVSAHMHOS',
	'ENVSAPRVSCH',	'ENVSAREGCL',	'ENVSARESFAC',	'ENVSASEPSCH',	'MOECEDEF',	'STADMSLDS', 'STADMSSIS'
	)
	

-- delete rows from database toggle questions and responses
--DELETE ToggleResponses
DELETE atr FROM [App].[ToggleResponses] atr
	JOIN App.ToggleQuestions atq on atq.ToggleQuestionId = atr.ToggleQuestionId 
	LEFT JOIN App.ToggleQuestionOptions atqo ON atqo.ToggleQuestionId = atr.ToggleQuestionId
      WHERE  atq.EmapsQuestionAbbrv IN ('ASSESLEP',	'CHDCTRPTFOR',	'CHDCTRPTSOP',	'DEFEXCERTNUM',	'DISCPREGPOL',
	'DISCPREM',	'ENVECHM',	'ENVECREGCL',	'ENVECRESFAC',	'ENVECSEPCL',	'ENVECSEPSCH',	'ENVECSERPRV',	'ENVSAHMHOS',
	'ENVSAPRVSCH',	'ENVSAREGCL',	'ENVSARESFAC',	'ENVSASEPSCH',	'MOECEDEF',	'STADMSLDS', 'STADMSSIS'
	)

--ToggleQuestionOption
DELETE atqo FROM [App].[ToggleQuestionOptions] atqo
JOIN App.ToggleQuestions atq on atq.ToggleQuestionId = atqo.ToggleQuestionId 
	
      WHERE  atq.EmapsQuestionAbbrv IN ('ASSESLEP',	'CHDCTRPTFOR',	'CHDCTRPTSOP',	'DEFEXCERTNUM',	'DISCPREGPOL',
	'DISCPREM',	'ENVECHM',	'ENVECREGCL',	'ENVECRESFAC',	'ENVECSEPCL',	'ENVECSEPSCH',	'ENVECSERPRV',	'ENVSAHMHOS',
	'ENVSAPRVSCH',	'ENVSAREGCL',	'ENVSARESFAC',	'ENVSASEPSCH',	'MOECEDEF',	'STADMSLDS', 'STADMSSIS'
	)

--ToggleQuestions
DELETE atq FROM App.ToggleQuestions atq 	
      WHERE  atq.EmapsQuestionAbbrv IN ('ASSESLEP',	'CHDCTRPTFOR',	'CHDCTRPTSOP',	'DEFEXCERTNUM',	'DISCPREGPOL',
	'DISCPREM',	'ENVECHM',	'ENVECREGCL',	'ENVECRESFAC',	'ENVECSEPCL',	'ENVECSEPSCH',	'ENVECSERPRV',	'ENVSAHMHOS',
	'ENVSAPRVSCH',	'ENVSAREGCL',	'ENVSARESFAC',	'ENVSASEPSCH',	'MOECEDEF',	'STADMSLDS', 'STADMSSIS'
	)

