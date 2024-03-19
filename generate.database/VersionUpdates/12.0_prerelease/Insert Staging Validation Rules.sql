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

    