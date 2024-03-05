-- DELETE ALL 'GENERATE' RULES AND REFRESH FROM THIS SCRIPT ----
delete A
from Staging.StagingValidationRules_ReportsXREF A
inner join Staging.StagingValidationRules B
	on A.StagingValidationRuleId = B.StagingValidationRuleId
where B.CreatedBy = 'Generate'

delete from Staging.StagingValidationRules
where CreatedBy = 'Generate'
----------------------------------------------------------------

SET IDENTITY_INSERT [Staging].[StagingValidationRules] ON 

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (1, 17, 284, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (2, 19, 367, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (3, 36, 612, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (4, 17, 240, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (5, 17, 255, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (6, 36, 608, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (7, 36, 636, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (8, 36, 619, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (9, 36, 647, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (10, 36, 641, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (11, 36, 643, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (12, 39, 726, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (13, 39, 743, N'Exit Reason required if Exit Date is Populated', N'where ProgramParticipationEndDate is not null and SpecialEducationExitReason is NULL', N'Exit Reason required if Exit Date is Populated', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (14, 39, 725, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (15, 39, 724, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (16, 6, 99, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (17, 6, 95, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (18, 6, 96, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (19, 6, 97, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (20, 6, 92, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (21, 6, 98, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (22, 2, 30, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (23, 2, 21, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (24, 2, 33, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (25, 2, 24, N'Cannot be NULL', N'Required', N'Cannot be NULL', N'Error', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (26, 18, 334, N'Column required for schools', N'where School_IsReportedFederally is NULL and SchoolIdentifierSEA is NOT NULL', N'Column required for schools', N'Informational', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (27, 18, 302, N'LEA must have valid Operational Status Effective Date', N'where where LEA_OperationalStatusEffectiveDate not between ''6/30/'' + convert(varchar, SchoolYear-1) and ''7/1/'' + convert(varchar, SchoolYear) is NULL', N'Operational Status Effective Date is not between dates of school year', N'Informational', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (28, 18, 357, N'Schools must have a School Name', N'where SchoolOrganizationName is NULL and SchoolIdentifierSEA is NOT NULL', N'Schools must have a School Name', N'Informational', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (29, 18, 338, N'Schools must have an Operational Status', N'where School_OperationalStatus is NULL and SchoolIdentifierSEA is NOT NULL', N'Schools must have an Operational Status', N'Informational', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (30, 19, 362, N'Checking that LeaIdentifierSeaAccountability and/or SchoolIdentifierSea is populated', N'where LEAIdentifierSeaAccountability is NULL AND SchoolIdentifierSea is NULL ', N'The LEAIdentifierSeaAccountability and/or the SchoolIdentifierSea must be populated', N'Informational', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (31, 36, 629, N'Checking that LeaIdentifierSeaAccountability and/or SchoolIdentifierSea is populated', N'where LEAIdentifierSeaAccountability is NULL AND SchoolIdentifierSea is NULL ', N'The LEAIdentifierSeaAccountability and/or the SchoolIdentifierSea must be populated', N'Informational', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (32, 36, 612, N'English Learners must have a Start Date', N'where isnull(EnglishLearnerStatus,0) = 1 and EnglishLearner_StatusStartDate is null', N'The EnglishLearnerStatus is 1 but EnglishLearner_StatusStartDate is NULL', N'Informational', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (33, 39, 727, N'Checking that LeaIdentifierSeaAccountability and/or SchoolIdentifierSea is populated', N'where LEAIdentifierSeaAccountability is NULL AND SchoolIdentifierSea is NULL ', N'The LEAIdentifierSeaAccountability and/or the SchoolIdentifierSea must be populated', N'Informational', N'Generate')

INSERT [Staging].[StagingValidationRules] ([StagingValidationRuleId], [StagingTableId], [StagingColumnId], [RuleDscr], [Condition], [ValidationMessage], [Severity], [CreatedBy]) VALUES (34, 39, 743, N'Exit Reason for ReachedMaximumAge can only apply to students that have reached maximum age according to the Toggle selection', N'select ske.StudentIdentifierState, ske.birthdate,
RDS.Get_Age(ske.Birthdate, IIF(sppse.ProgramParticipationEndDate < 
(
select 
isnull(tr.ResponseValue, ''10/1/'' + convert(varchar, ske.SchoolYear-1))
from app.togglequestions tq
left join app.ToggleResponses tr
	on tq.ToggleQuestionId = tr.ToggleQuestionId
where tq.EmapsQuestionAbbrv = ''CHDCTDTE''), 
(
select 
dateadd(year, -1, isnull(tr.ResponseValue, ''10/1/'' + convert(varchar, ske.SchoolYear-1)))
from app.togglequestions tq
left join app.ToggleResponses tr
	on tq.ToggleQuestionId = tr.ToggleQuestionId
where tq.EmapsQuestionAbbrv = ''CHDCTDTE''),
(
select 
isnull(tr.ResponseValue, ''10/1/'' + convert(varchar, ske.SchoolYear-1))
from app.togglequestions tq
left join app.ToggleResponses tr
	on tq.ToggleQuestionId = tr.ToggleQuestionId
where tq.EmapsQuestionAbbrv = ''CHDCTDTE'')
)) ExitAge, 
ske.LeaIdentifierSeaAccountability, ske.SchoolIdentifierSea,
sppse.ProgramParticipationBeginDate,
sppse.ProgramParticipationEndDate, 
sppse.SpecialEducationExitReason
from Staging.K12Enrollment ske
inner join Staging.ProgramParticipationSpecialEducation sppse 
on ske.StudentIdentifierState = sppse.StudentIdentifierState
where sppse.SpecialEducationExitReason = (
	select top 1 SpecialEducationExitReasonMap
	from rds.vwDimIdeaStatuses 
	where schoolyear = ske.SchoolYear
		and SpecialEducationExitReasonCode = ''ReachedMaximumAge''
	)
and 
RDS.Get_Age(ske.Birthdate, IIF(sppse.ProgramParticipationEndDate < 
(
select 
isnull(tr.ResponseValue, ''10/1/'' + convert(varchar, ske.SchoolYear-1))
from app.togglequestions tq
left join app.ToggleResponses tr
	on tq.ToggleQuestionId = tr.ToggleQuestionId
where tq.EmapsQuestionAbbrv = ''CHDCTDTE''), 
(
select 
dateadd(year, -1, isnull(tr.ResponseValue, ''10/1/'' + convert(varchar, ske.SchoolYear-1)))
from app.togglequestions tq
left join app.ToggleResponses tr
	on tq.ToggleQuestionId = tr.ToggleQuestionId
where tq.EmapsQuestionAbbrv = ''CHDCTDTE''),
(
select 
isnull(tr.ResponseValue, ''10/1/'' + convert(varchar, ske.SchoolYear-1))
from app.togglequestions tq
left join app.ToggleResponses tr
	on tq.ToggleQuestionId = tr.ToggleQuestionId
where tq.EmapsQuestionAbbrv = ''CHDCTDTE'')
)) < 
(
select isnull(tr.ResponseValue, 21)
from app.togglequestions tq
left join app.ToggleResponses tr
	on tq.ToggleQuestionId = tr.ToggleQuestionId
where tq.EmapsQuestionAbbrv = ''DEFEXMAXAGE''
) - 1	
', N'Invalid Age and Exit Reason Combination', N'Informational', N'Generate')

SET IDENTITY_INSERT [Staging].[StagingValidationRules] OFF

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 4, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 5, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 9, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 12, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 14, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 15, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 16, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 17, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 18, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 19, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 46, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (1, 84, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 4, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 5, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 9, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 12, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 14, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 15, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 16, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 17, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 18, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 19, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 46, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (2, 84, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (3, 4, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (3, 5, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (3, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (3, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (3, 9, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (3, 12, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (3, 14, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (3, 15, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (3, 16, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (3, 17, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (3, 18, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (3, 19, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (3, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (3, 84, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (4, 12, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (4, 15, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (4, 19, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (5, 46, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (5, 61, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (6, 4, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (6, 5, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (6, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (6, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (6, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (6, 84, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (7, 4, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (7, 5, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (7, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (7, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (7, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (7, 84, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (8, 4, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (8, 5, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (8, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (8, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (8, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (8, 84, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (9, 4, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (9, 5, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (9, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (9, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (9, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (9, 84, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (10, 4, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (10, 5, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (10, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (10, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (10, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (10, 84, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (11, 41, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (12, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (12, 8, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (13, 15, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (14, 19, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (15, 12, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (16, 16, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (16, 18, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (17, 14, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (17, 17, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (18, 8, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (19, 61, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (20, 61, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (21, 61, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (22, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (22, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (22, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (23, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (23, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (23, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (24, 4, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (24, 5, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (24, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (24, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (24, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (24, 84, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (25, 4, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (25, 5, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (25, 84, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (26, 19, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (26, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (27, 19, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (27, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (28, 19, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (28, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 9, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 10, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 11, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 12, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 14, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 15, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 16, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 17, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 18, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 19, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 26, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 39, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 41, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 44, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 46, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (29, 61, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 4, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 5, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 8, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 9, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 12, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 14, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 15, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 16, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 17, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 18, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 19, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 46, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 61, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (30, 84, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 4, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 5, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 8, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 9, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 12, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 14, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 15, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 16, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 17, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 18, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 19, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 61, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (31, 84, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 4, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 5, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 9, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 12, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 14, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 15, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 16, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 17, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 18, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 19, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 61, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (32, 84, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (33, 4, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (33, 5, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (33, 6, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (33, 7, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (33, 9, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (33, 12, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (33, 14, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (33, 15, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (33, 16, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (33, 17, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (33, 18, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (33, 19, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (33, 81, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (33, 84, 1, N'Generate')

INSERT [Staging].[StagingValidationRules_ReportsXREF] ([StagingValidationRuleId], [GenerateReportId], [Enabled], [CreatedBy]) VALUES (34, 15, 1, N'Generate')

