--SELECT * FROM app.ToggleResponses r
--SELECT * FROM app.ToggleQuestions q 

USE GENERATE

INSERT INTO app.ToggleQuestions ( EmapsQuestionAbbrv,ParentToggleQuestionId,QuestionSequence,QuestionText,ToggleQuestionTypeId,ToggleSectionId )
VALUES ('GRADEHS',NULL,704,'Aggregrate grades ''09'',''10'',''11'',''12'' into ''HS'' ?',	7,	12)

/*

INSERT ONLY IF NEEDED.

INSERT INTO app.ToggleResponses (ToggleResponseId,ResponseValue,ToggleQuestionId,ToggleQuestionOptionId)
(72,'true',63,NULL)

*/