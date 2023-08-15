--Add Membership to the ReportGroups table
insert into App.GenerateReportGroups
values (7,'Membership')

--Add c033, c052, and c086 to the Report Groups xref table
insert into App.GenerateReportGroups_ReportsXREF
values 
(7,41),
(7,46),
(4,61)

--Add c033, c052, and c086 to the Staging Table xref
insert into App.GenerateReport_GenerateStagingTablesXREF
values 
(41,6),
(41,7),
(41,14),
(41,16),
(46,6),
(46,7),
(46,13),
(46,16),
(61,5),
(61,6),
(61,7),
(61,13),
(61,14),
(61,16)

--Add rules to the staging Validation table 
insert into staging.StagingValidationRules
values 
('ChildCount, Exiting, Discipline','Generate','K12Enrollment','Birthdate','Null Value',NULL,NULL,NULL,NULL,'Warning'),
('c033','Generate','PersonStatus','EligibilityStatusForSchoolFoodServicePrograms','Null Value',NULL,NULL,NULL,NULL,'Warning'),
('c033','Generate','PersonStatus','NationalSchoolLunchProgramDirectCertificationIndicator','Null Value',NULL,NULL,NULL,NULL,'Warning'),
('c086','Generate','Discipline','DisciplineMethodFirearm','Null Value',NULL,NULL,NULL,NULL,'Warning'),
('c086','Generate','Discipline','DisciplineMethodFirearm','Option Not Mapped','RefDisciplineMethodFirearms',NULL,NULL,NULL,'Warning'),
('c086','Generate','Discipline','IDEADisciplineMethodFirearm','Null Value',NULL,NULL,NULL,NULL,'Warning'),
('c086','Generate','Discipline','IDEADisciplineMethodFirearm','Option Not Mapped','RefIDEADisciplineMethodFirearm',NULL,NULL,NULL,'Warning'),
('c086','Generate','Discipline','FirearmType','Null Value',NULL,NULL,NULL,NULL,'Warning'),
('c086','Generate','Discipline','FirearmType','Option Not Mapped','RefFirearmType',NULL,NULL,NULL,'Warning')

--update the existing group rules that apply to Membership
update staging.StagingValidationRules
set ReportGroupOrCodes = concat(ReportGroupOrCodes, ', Membership')
where StagingValidationRuleId in (1,2,3,4,6,7,8,9,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,42,44,57)



