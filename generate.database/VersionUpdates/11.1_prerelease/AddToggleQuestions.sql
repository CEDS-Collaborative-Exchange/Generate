--Add the new toggle question for lower grade assessments
insert into app.ToggleQuestions
values('ASSESSTYPLG', NULL, 702, 'Please indicate any of the following Lower Grade (3-8) Assessments used by your state.', 8, 12)

--Add the new toggle question for high school assessments
insert into app.ToggleQuestions
values('ASSESSTYPHS', NULL, 703, 'Please indicate any of the following High School (9-12) Assessments used by your state.', 8, 12)

declare @lgQuestionid int
declare @hsQuestionid int

set @lgQuestionid = (select ToggleQuestionId from app.ToggleQuestions where EmapsQuestionAbbrv = 'ASSESSTYPLG')
set @hsQuestionid = (select ToggleQuestionId from app.ToggleQuestions where EmapsQuestionAbbrv = 'ASSESSTYPHS')


--Add the options for the new Assessment LG/HS questions
--LG
insert into app.ToggleQuestionOptions
values (1, 'Advanced assessment without accommodations', @lgQuestionid),
	(2, 'Advanced assessment with accommodations', @lgQuestionid),
	(3, 'Innovative Assessment Demonstration Authority (IADA) pilot assessment without accommodations', @lgQuestionid),
	(4, 'Innovative Assessment Demonstration Authority (IADA) pilot assessment with accommodations', @lgQuestionid)

--HS
insert into app.ToggleQuestionOptions
values (1, 'High school regular assessment II, without accommodations', @hsQuestionid),
	(2, 'High school regular assessment II, with accommodations', @hsQuestionid),
	(3, 'High school regular assessment III, without accommodations', @hsQuestionid),
	(4, 'High school regular assessment III, with accommodations', @hsQuestionid),
	(5, 'Advanced assessment without accommodations', @hsQuestionid),
	(6, 'Advanced assessment with accommodations', @hsQuestionid),
	(7, 'Innovative Assessment Demonstration Authority (IADA) pilot assessment without accommodations', @hsQuestionid),
	(8, 'Innovative Assessment Demonstration Authority (IADA) pilot assessment with accommodations', @hsQuestionid),
	(9, 'Locally-selected nationally recognized high school assessment without accommodations', @hsQuestionid),
	(10, 'Locally-selected nationally recognized high school assessment with accommodations', @hsQuestionid)


--insert into Toggle Responses for Assessment LG question
insert into app.ToggleResponses
values ('ADVASMTWOACC', @lgQuestionid, (select ToggleQuestionOptionId from app.ToggleQuestionOptions where ToggleQuestionId = @lgQuestionid and OptionSequence = 1)), 
	('ADVASMTWACC', @lgQuestionid, (select ToggleQuestionOptionId from app.ToggleQuestionOptions where ToggleQuestionId = @lgQuestionid and OptionSequence = 2)), 
	('IADAPLASMTWOACC', @lgQuestionid, (select ToggleQuestionOptionId from app.ToggleQuestionOptions where ToggleQuestionId = @lgQuestionid and OptionSequence = 3)), 
	('IADAPLASMTWACC', @lgQuestionid, (select ToggleQuestionOptionId from app.ToggleQuestionOptions where ToggleQuestionId = @lgQuestionid and OptionSequence = 4))

--insert into Toggle Responses for Assessment LG question
insert into app.ToggleResponses
values ('HSREGASMT2WOACC', @hsQuestionid, (select ToggleQuestionOptionId from app.ToggleQuestionOptions where ToggleQuestionId = @hsQuestionid and OptionSequence = 1)), 
	('HSREGASMT2WACC', @hsQuestionid, (select ToggleQuestionOptionId from app.ToggleQuestionOptions where ToggleQuestionId = @hsQuestionid and OptionSequence = 2)), 
	('HSREGASMT3WOACC', @hsQuestionid, (select ToggleQuestionOptionId from app.ToggleQuestionOptions where ToggleQuestionId = @hsQuestionid and OptionSequence = 3)), 
	('HSREGASMT3WACC', @hsQuestionid, (select ToggleQuestionOptionId from app.ToggleQuestionOptions where ToggleQuestionId = @hsQuestionid and OptionSequence = 4)),
	('ADVASMTWOACC', @hsQuestionid, (select ToggleQuestionOptionId from app.ToggleQuestionOptions where ToggleQuestionId = @hsQuestionid and OptionSequence = 5)), 
	('ADVASMTWACC', @hsQuestionid, (select ToggleQuestionOptionId from app.ToggleQuestionOptions where ToggleQuestionId = @hsQuestionid and OptionSequence = 6)), 
	('IADAPLASMTWOACC', @hsQuestionid, (select ToggleQuestionOptionId from app.ToggleQuestionOptions where ToggleQuestionId = @hsQuestionid and OptionSequence = 7)), 
	('IADAPLASMTWACC', @hsQuestionid, (select ToggleQuestionOptionId from app.ToggleQuestionOptions where ToggleQuestionId = @hsQuestionid and OptionSequence = 8)),
	('LSNRHSASMTWOACC', @hsQuestionid, (select ToggleQuestionOptionId from app.ToggleQuestionOptions where ToggleQuestionId = @hsQuestionid and OptionSequence = 9)), 
	('LSNRHSASMTWACC', @hsQuestionid, (select ToggleQuestionOptionId from app.ToggleQuestionOptions where ToggleQuestionId = @hsQuestionid and OptionSequence = 10)) 
