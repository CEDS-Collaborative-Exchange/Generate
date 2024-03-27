exec Staging.StagingValidation_InsertRule
	@ReportGroupOrCode = 'Discipline',
	@StagingTableName = 'Discipline',
	@StagingColumnName = 'DisciplinaryActionStartDate',
	@RuleDscr = 'DisciplinaryActionStartDate must be before DisciplinaryActionEndDate',
	@Condition = 'where DisciplinaryActionStartDate > isnull(DisciplinaryActionEndDate, getdate())',
	@ValidationMessage = 'DisciplinaryActionStartDate must be before DisciplinaryActionEndDate',
	@CreatedBy = 'Generate',
	@Enabled = 1


exec Staging.StagingValidation_InsertRule
	@ReportGroupOrCode = 'All',
	@StagingTableName = 'K12Enrollment',
	@StagingColumnName = 'RecordStartDateTime',
	@RuleDscr = 'RecordStartDateTime must be before RecordEndDateTime',
	@Condition = 'where RecordStartDateTime > isnull(RecordEndDateTime, getdate())',
	@ValidationMessage = 'RecordStartDateTime must be before RecordEndDateTime',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@ReportGroupOrCode = 'All',
	@StagingTableName = 'K12Enrollment',
	@StagingColumnName = 'EnrollmentEntryDate',
	@RuleDscr = 'EnrollmentEntryDate must be before EnrollmentExitDate',
	@Condition = 'where EnrollmentEntryDate > isnull(EnrollmentExitDate, getdate())',
	@ValidationMessage = 'EnrollmentEntryDate must be before EnrollmentExitDate',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@ReportGroupOrCode = 'C052, C032, C086, C141',
	@StagingTableName = 'K12Enrollment',
	@StagingColumnName = 'GradeLevel',
	@RuleDscr = 'A student can only be enrolled in a single grade',
	@Condition = 'select StudentIdentifierState, count(*) GradeLevels from (
select distinct StudentIdentifierState, GradeLevel from staging.K12Enrollment) A
group by StudentIdentifierState
having count(*) > 1',
	@ValidationMessage = 'A student can only be enrolled in a single grade',
	@CreatedBy = 'Generate',
	@Enabled = 1

 
exec Staging.StagingValidation_InsertRule
	@ReportGroupOrCode = 'All',
	@StagingTableName = 'K12Organization',
	@StagingColumnName = 'LEA_RecordStartDateTime',
	@RuleDscr = 'LEA_RecordStartDateTime must be before LEA_RecordEndDateTime',
	@Condition = 'where LEA_RecordStartDateTime > isnull(LEA_RecordEndDateTime, getdate())',
	@ValidationMessage = 'LEA_RecordStartDateTime must be before LEA_RecordEndDateTime',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@ReportGroupOrCode = 'All',
	@StagingTableName = 'K12Enrollment',
	@StagingColumnName = 'StudentIdentifierState',
	@RuleDscr = 'A student has multiple versions of demographic information',
	@Condition = 'select a.StudentIdentifierState, a.LeaIdentifierSeaAccountability, a.SchoolIdentifierSea,
	a.FirstName, a.MiddleName, a.LastOrSurname, a.Birthdate, a.Sex, a.HispanicLatinoEthnicity
from staging.K12Enrollment a
left join staging.K12Enrollment b
	on a.StudentIdentifierState = b.StudentIdentifierState
where a.FirstName <> b.firstname
or a.MiddleName <> b.MiddleName
or a.LastOrSurname <> b.LastOrSurname
or a.Birthdate <> b.Birthdate
or a.sex <> b.sex
or a.HispanicLatinoEthnicity <> b.HispanicLatinoEthnicity',
	@ValidationMessage = 'A student has multiple versions of demographic information',
	@CreatedBy = 'Generate',
	@Enabled = 1

exec Staging.StagingValidation_InsertRule
	@ReportGroupOrCode = 'C141',
	@StagingTableName = 'ProgramParticipationSpecialEducation',
	@StagingColumnName = 'IdeaIndicator',
	@RuleDscr = 'Cannot be NULL',
	@Condition = 'Required',
	@ValidationMessage = 'Cannot be NULL',
	@CreatedBy = 'Generate',
	@Enabled = 1

    
