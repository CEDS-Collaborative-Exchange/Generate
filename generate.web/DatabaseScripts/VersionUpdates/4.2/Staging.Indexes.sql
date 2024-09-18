CREATE NONCLUSTERED INDEX [IX_Staging_K12Enrollment_EnrollmentEntryDate_WithIncludes]
ON [Staging].[K12Enrollment] ([EnrollmentEntryDate])
INCLUDE ([Student_Identifier_State],[LEA_Identifier_State],[School_Identifier_State],[FirstName],[LastName],[MiddleName],[Birthdate],[HispanicLatinoEthnicity],[EnrollmentExitDate],[GradeLevel],[CohortYear],[SchoolYear])

CREATE NONCLUSTERED INDEX [IX_Staging_K12Enrollment_StudentId_SchoolId_EnrollmentDate_WithIncludes]
ON [Staging].[K12Enrollment] ([Student_Identifier_State],[School_Identifier_State],[EnrollmentEntryDate])
INCLUDE ([LEA_Identifier_State],[FirstName],[LastName],[MiddleName],[Birthdate],[HispanicLatinoEthnicity],[EnrollmentExitDate],[GradeLevel],[CohortYear],[SchoolYear])

CREATE NONCLUSTERED INDEX [IX_Staging_PPSE_ProgramParticipationBeginDate_WithIncludes]
ON [Staging].[ProgramParticipationSpecialEducation] ([ProgramParticipationBeginDate])
INCLUDE ([Student_Identifier_State],[LEA_Identifier_State],[School_Identifier_State],[ProgramParticipationEndDate],[SpecialEducationExitReason],[IDEAEducationalEnvironmentForEarlyChildhood],[IDEAEducationalEnvironmentForSchoolAge])

CREATE NONCLUSTERED INDEX [IX_Staging_PersonStatus_IDEAStatusStartDate_WithIncludes]
ON [Staging].[PersonStatus] ([IDEA_StatusStartDate])
INCLUDE ([Student_Identifier_State],[School_Identifier_State],[IDEAIndicator],[IDEA_StatusEndDate],[PrimaryDisabilityType])

CREATE NONCLUSTERED INDEX [IX_Staging_PersonStatus_StudentId_IDEAStatusStartDate]
ON [Staging].[PersonStatus] ([Student_Identifier_State],[IDEA_StatusStartDate])
INCLUDE ([School_Identifier_State],[IDEAIndicator],[IDEA_StatusEndDate],[PrimaryDisabilityType])

CREATE NONCLUSTERED INDEX [IX_Staging_ProgramParticipationSpecialEducation_StudentId_LeaId_BeginDate]
ON [Staging].[ProgramParticipationSpecialEducation] ([Student_Identifier_State],[LEA_Identifier_State],[ProgramParticipationBeginDate])
INCLUDE ([School_Identifier_State],[ProgramParticipationEndDate],[SpecialEducationExitReason],[IDEAEducationalEnvironmentForEarlyChildhood],[IDEAEducationalEnvironmentForSchoolAge])

CREATE NONCLUSTERED INDEX [IX_Staging_SourceSystemReferenceData_OutputCode_TableName_SchoolYear]
ON [Staging].[SourceSystemReferenceData] ([OutputCode], [TableName], [SchoolYear])
INCLUDE ([TableFilter],[InputCode])