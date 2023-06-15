SET NOCOUNT ON;


IF NOT EXISTS (SELECT 1 FROM app.[FactTables] WHERE [FactTableName] = 'FactK12ProgramParticipations')
BEGIN
	INSERT INTO [App].[FactTables]
           ([FactFieldName]
           ,[FactReportDtoIdName]
           ,[FactReportDtoName]
           ,[FactReportTableIdName]
           ,[FactReportTableName]
           ,[FactTableIdName]
           ,[FactTableName])
     VALUES('StudentCount', NULL, NULL, NULL, NULL, 'FactK12ProgramParticipationId', 'FactK12ProgramParticipations')
	
END

IF NOT EXISTS (SELECT 1 FROM app.[FactTables] WHERE [FactTableName] = 'FactK12StudentAttendance')
BEGIN

    Update app.FactTables set FactReportDtoIdName = NULL, FactReportDtoName = NULL, FactTableName = 'FactK12StudentAttendanceRates'
    Where [FactTableName] = 'FactK12StudentAttendance'

END

IF NOT EXISTS (SELECT 1 FROM app.[FactTables] WHERE [FactTableName] = 'FactK12StudentCourseSections')
BEGIN
	INSERT INTO [App].[FactTables]
           ([FactFieldName]
           ,[FactReportDtoIdName]
           ,[FactReportDtoName]
           ,[FactReportTableIdName]
           ,[FactReportTableName]
           ,[FactTableIdName]
           ,[FactTableName])
     VALUES('StudentCourseSectionCount', NULL, NULL, NULL, NULL, 'FactK12StudentCourseSectionId', 'FactK12StudentCourseSections')
	
END

IF NOT EXISTS (SELECT 1 FROM app.[FactTables] WHERE [FactTableName] = 'FactK12StudentEnrollments')
BEGIN
	INSERT INTO [App].[FactTables]
           ([FactFieldName]
           ,[FactReportDtoIdName]
           ,[FactReportDtoName]
           ,[FactReportTableIdName]
           ,[FactReportTableName]
           ,[FactTableIdName]
           ,[FactTableName])
     VALUES('StudentCount', NULL, NULL, NULL, NULL, 'FactK12StudentEnrollmentId', 'FactK12StudentEnrollments')
	
END

IF NOT EXISTS (SELECT 1 FROM app.[FactTables] WHERE [FactTableName] = 'FactPsStudentAcademicAwards')
BEGIN
	INSERT INTO [App].[FactTables]
           ([FactFieldName]
           ,[FactReportDtoIdName]
           ,[FactReportDtoName]
           ,[FactReportTableIdName]
           ,[FactReportTableName]
           ,[FactTableIdName]
           ,[FactTableName])
     VALUES('StudentCount', NULL, NULL, NULL, NULL, 'FactPsStudentAcademicAwardId', 'FactPsStudentAcademicAwards')
	
END

IF NOT EXISTS (SELECT 1 FROM app.[FactTables] WHERE [FactTableName] = 'FactPsStudentAcademicRecords')
BEGIN
	INSERT INTO [App].[FactTables]
           ([FactFieldName]
           ,[FactReportDtoIdName]
           ,[FactReportDtoName]
           ,[FactReportTableIdName]
           ,[FactReportTableName]
           ,[FactTableIdName]
           ,[FactTableName])
     VALUES('StudentCourseCount', NULL, NULL, NULL, NULL, 'FactPsStudentAcademicRecordId', 'FactPsStudentAcademicRecords')
	
END

IF NOT EXISTS (SELECT 1 FROM app.[FactTables] WHERE [FactTableName] = 'FactPsStudentEnrollments')
BEGIN
	INSERT INTO [App].[FactTables]
           ([FactFieldName]
           ,[FactReportDtoIdName]
           ,[FactReportDtoName]
           ,[FactReportTableIdName]
           ,[FactReportTableName]
           ,[FactTableIdName]
           ,[FactTableName])
     VALUES('StudentCount', NULL, NULL, NULL, NULL, 'FactPsStudentEnrollmentId', 'FactPsStudentEnrollments')
	
END

UPDATE app.[FactTables] SET FactFieldName = 'StaffFullTimeEquivalency' WHERE [FactTableName] = 'FactK12StaffCounts'