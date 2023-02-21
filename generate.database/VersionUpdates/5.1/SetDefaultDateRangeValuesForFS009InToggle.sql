DECLARE 
@ToggleStartDate DATE,
@ToggleEndDate DATE

SELECT @ToggleStartDate = tr.ResponseValue
FROM App.ToggleQuestions tq
JOIN App.ToggleResponses tr
	ON tq.ToggleQuestionId = tr.ToggleQuestionId
WHERE tq.EmapsQuestionAbbrv = 'DEFEXREFDTESTART'

SELECT @ToggleEndDate = tr.ResponseValue
FROM App.ToggleQuestions tq
JOIN App.ToggleResponses tr
	ON tq.ToggleQuestionId = tr.ToggleQuestionId
WHERE tq.EmapsQuestionAbbrv = 'DEFEXREFDTEEND'

IF @ToggleStartDate = '03/10/2020' and @ToggleEndDate = '07/15/2020' BEGIN
		UPDATE App.ToggleResponses
		SET ResponseValue = 'true'
		FROM App.ToggleQuestions tq
		JOIN App.ToggleResponses tr
			ON tq.ToggleQuestionId = tr.ToggleQuestionId
		WHERE tq.EmapsQuestionAbbrv = 'DEFEXREFPER'

END