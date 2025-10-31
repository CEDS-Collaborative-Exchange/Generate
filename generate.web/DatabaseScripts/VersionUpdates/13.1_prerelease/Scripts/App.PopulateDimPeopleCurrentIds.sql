/*
    Populate new CurrentId fields in fact tables based on existing DimPeople foreign key relationships.
    This script maps existing fact table records to the appropriate DimPeople_Current records
    using the identifier fields from both dimension tables.
*/

SET NOCOUNT ON

PRINT 'Starting population of DimPeople_Current foreign key fields...'

-- Disable foreign key constraints during update
PRINT 'Disabling foreign key constraints...'
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

-- K12 Student tables
PRINT 'Updating K12 Student CurrentId fields...'

-- FactK12StudentCounts
UPDATE f 
SET K12Student_CurrentId = dc.DimPersonId
FROM RDS.FactK12StudentCounts f
INNER JOIN RDS.DimPeople dp ON f.K12StudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState
WHERE f.K12Student_CurrentId = -1 
  AND dp.K12StudentStudentIdentifierState IS NOT NULL
  AND dc.K12StudentStudentIdentifierState IS NOT NULL

PRINT '    FactK12StudentCounts updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StudentCourseSections
UPDATE f 
SET K12Student_CurrentId = dc.DimPersonId
FROM RDS.FactK12StudentCourseSections f
INNER JOIN RDS.DimPeople dp ON f.K12StudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState
WHERE f.K12Student_CurrentId = -1 
  AND dp.K12StudentStudentIdentifierState IS NOT NULL
  AND dc.K12StudentStudentIdentifierState IS NOT NULL

PRINT '    FactK12StudentCourseSections updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StudentAcademicAwards
UPDATE f 
SET K12Student_CurrentId = dc.DimPersonId
FROM RDS.FactK12StudentAcademicAwards f
INNER JOIN RDS.DimPeople dp ON f.K12StudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState
WHERE f.K12Student_CurrentId = -1 
  AND dp.K12StudentStudentIdentifierState IS NOT NULL
  AND dc.K12StudentStudentIdentifierState IS NOT NULL

PRINT '    FactK12StudentAcademicAwards updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StudentAcademicRecords
UPDATE f 
SET K12Student_CurrentId = dc.DimPersonId
FROM RDS.FactK12StudentAcademicRecords f
INNER JOIN RDS.DimPeople dp ON f.K12StudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState
WHERE f.K12Student_CurrentId = -1 
  AND dp.K12StudentStudentIdentifierState IS NOT NULL
  AND dc.K12StudentStudentIdentifierState IS NOT NULL

PRINT '    FactK12StudentAcademicRecords updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StudentEconomicDisadvantages
UPDATE f 
SET K12Student_CurrentId = dc.DimPersonId
FROM RDS.FactK12StudentEconomicDisadvantages f
INNER JOIN RDS.DimPeople dp ON f.K12StudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState
WHERE f.K12Student_CurrentId = -1 
  AND dp.K12StudentStudentIdentifierState IS NOT NULL
  AND dc.K12StudentStudentIdentifierState IS NOT NULL

PRINT '    FactK12StudentEconomicDisadvantages updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12GraduationCohorts
UPDATE f 
SET K12Student_CurrentId = dc.DimPersonId
FROM RDS.FactK12GraduationCohorts f
INNER JOIN RDS.DimPeople dp ON f.K12StudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState
WHERE f.K12Student_CurrentId = -1 
  AND dp.K12StudentStudentIdentifierState IS NOT NULL
  AND dc.K12StudentStudentIdentifierState IS NOT NULL

PRINT '    FactK12GraduationCohorts updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12AccessibleEducationMaterialAssignments
UPDATE f 
SET K12Student_CurrentId = dc.DimPersonId
FROM RDS.FactK12AccessibleEducationMaterialAssignments f
INNER JOIN RDS.DimPeople dp ON f.K12StudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState
WHERE f.K12Student_CurrentId = -1 
  AND dp.K12StudentStudentIdentifierState IS NOT NULL
  AND dc.K12StudentStudentIdentifierState IS NOT NULL

PRINT '    FactK12AccessibleEducationMaterialAssignments updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactSpecialEducation
UPDATE f 
SET K12Student_CurrentId = dc.DimPersonId
FROM RDS.FactSpecialEducation f
INNER JOIN RDS.DimPeople dp ON f.K12StudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState
WHERE f.K12Student_CurrentId = -1 
  AND dp.K12StudentStudentIdentifierState IS NOT NULL
  AND dc.K12StudentStudentIdentifierState IS NOT NULL

PRINT '    FactSpecialEducation updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StudentEnrollments
UPDATE f 
SET K12Student_CurrentId = dc.DimPersonId
FROM RDS.FactK12StudentEnrollments f
INNER JOIN RDS.DimPeople dp ON f.K12StudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState
WHERE f.K12Student_CurrentId = -1 
  AND dp.K12StudentStudentIdentifierState IS NOT NULL
  AND dc.K12StudentStudentIdentifierState IS NOT NULL

PRINT '    FactK12StudentEnrollments updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StudentDisciplines
UPDATE f 
SET K12Student_CurrentId = dc.DimPersonId
FROM RDS.FactK12StudentDisciplines f
INNER JOIN RDS.DimPeople dp ON f.K12StudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState
WHERE f.K12Student_CurrentId = -1 
  AND dp.K12StudentStudentIdentifierState IS NOT NULL
  AND dc.K12StudentStudentIdentifierState IS NOT NULL

PRINT '    FactK12StudentDisciplines updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12ProgramParticipations
UPDATE f 
SET K12Student_CurrentId = dc.DimPersonId
FROM RDS.FactK12ProgramParticipations f
INNER JOIN RDS.DimPeople dp ON f.K12StudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState
WHERE f.K12Student_CurrentId = -1 
  AND dp.K12StudentStudentIdentifierState IS NOT NULL
  AND dc.K12StudentStudentIdentifierState IS NOT NULL

PRINT '    FactK12ProgramParticipations updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StudentAssessments
UPDATE f 
SET K12Student_CurrentId = dc.DimPersonId
FROM RDS.FactK12StudentAssessments f
INNER JOIN RDS.DimPeople dp ON f.K12StudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState
WHERE f.K12Student_CurrentId = -1 
  AND dp.K12StudentStudentIdentifierState IS NOT NULL
  AND dc.K12StudentStudentIdentifierState IS NOT NULL

PRINT '    FactK12StudentAssessments updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StudentAttendanceRates
UPDATE f 
SET K12Student_CurrentId = dc.DimPersonId
FROM RDS.FactK12StudentAttendanceRates f
INNER JOIN RDS.DimPeople dp ON f.K12StudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState
WHERE f.K12Student_CurrentId = -1 
  AND dp.K12StudentStudentIdentifierState IS NOT NULL
  AND dc.K12StudentStudentIdentifierState IS NOT NULL

PRINT '    FactK12StudentAttendanceRates updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12ParentOrGuardians - K12Student_CurrentId
UPDATE f 
SET K12Student_CurrentId = dc.DimPersonId
FROM RDS.FactK12ParentOrGuardians f
INNER JOIN RDS.DimPeople dp ON f.K12StudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState
WHERE f.K12Student_CurrentId = -1 
  AND dp.K12StudentStudentIdentifierState IS NOT NULL
  AND dc.K12StudentStudentIdentifierState IS NOT NULL

PRINT '    FactK12ParentOrGuardians K12Student_CurrentId updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- K12 Staff tables
PRINT 'Updating K12 Staff CurrentId fields...'

-- FactK12StaffAssignments
UPDATE f 
SET K12Staff_CurrentId = dc.DimPersonId
FROM RDS.FactK12StaffAssignments f
INNER JOIN RDS.DimPeople dp ON f.K12StaffId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StaffStaffMemberIdentifierState = dc.K12StaffStaffMemberIdentifierState
WHERE f.K12Staff_CurrentId = -1 
  AND dp.K12StaffStaffMemberIdentifierState IS NOT NULL
  AND dc.K12StaffStaffMemberIdentifierState IS NOT NULL

PRINT '    FactK12StaffAssignments updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StaffProfessionalDevelopmentSessions
UPDATE f 
SET K12Staff_CurrentId = dc.DimPersonId
FROM RDS.FactK12StaffProfessionalDevelopmentSessions f
INNER JOIN RDS.DimPeople dp ON f.K12StaffId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StaffStaffMemberIdentifierState = dc.K12StaffStaffMemberIdentifierState
WHERE f.K12Staff_CurrentId = -1 
  AND dp.K12StaffStaffMemberIdentifierState IS NOT NULL
  AND dc.K12StaffStaffMemberIdentifierState IS NOT NULL

PRINT '    FactK12StaffProfessionalDevelopmentSessions updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StaffEvaluationParts
UPDATE f 
SET K12Staff_CurrentId = dc.DimPersonId
FROM RDS.FactK12StaffEvaluationParts f
INNER JOIN RDS.DimPeople dp ON f.K12StaffId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StaffStaffMemberIdentifierState = dc.K12StaffStaffMemberIdentifierState
WHERE (f.K12Staff_CurrentId = -1 OR f.K12Staff_CurrentId IS NULL)
  AND dp.K12StaffStaffMemberIdentifierState IS NOT NULL
  AND dc.K12StaffStaffMemberIdentifierState IS NOT NULL

PRINT '    FactK12StaffEvaluationParts updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StaffEmployments
UPDATE f 
SET K12Staff_CurrentId = dc.DimPersonId
FROM RDS.FactK12StaffEmployments f
INNER JOIN RDS.DimPeople dp ON f.K12StaffId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StaffStaffMemberIdentifierState = dc.K12StaffStaffMemberIdentifierState
WHERE f.K12Staff_CurrentId = -1 
  AND dp.K12StaffStaffMemberIdentifierState IS NOT NULL
  AND dc.K12StaffStaffMemberIdentifierState IS NOT NULL

PRINT '    FactK12StaffEmployments updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StaffCourseSections - K12StaffMember_CurrentId
UPDATE f 
SET K12StaffMember_CurrentId = dc.DimPersonId
FROM RDS.FactK12StaffCourseSections f
INNER JOIN RDS.DimPeople dp ON f.K12StaffId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StaffStaffMemberIdentifierState = dc.K12StaffStaffMemberIdentifierState
WHERE f.K12StaffMember_CurrentId = -1 
  AND dp.K12StaffStaffMemberIdentifierState IS NOT NULL
  AND dc.K12StaffStaffMemberIdentifierState IS NOT NULL

PRINT '    FactK12StaffCourseSections K12StaffMember_CurrentId updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StaffCompensations
UPDATE f 
SET K12Staff_CurrentId = dc.DimPersonId
FROM RDS.FactK12StaffCompensations f
INNER JOIN RDS.DimPeople dp ON f.K12StaffId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StaffStaffMemberIdentifierState = dc.K12StaffStaffMemberIdentifierState
WHERE f.K12Staff_CurrentId = -1 
  AND dp.K12StaffStaffMemberIdentifierState IS NOT NULL
  AND dc.K12StaffStaffMemberIdentifierState IS NOT NULL

PRINT '    FactK12StaffCompensations updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StaffAssessments - K12StaffPerson_CurrentId
-- UPDATE f 
-- SET K12StaffPerson_CurrentId = dc.DimPersonId
-- FROM RDS.FactK12StaffAssessments f
-- INNER JOIN RDS.DimPeople dp ON f.K12StaffId = dp.DimPersonId
-- INNER JOIN RDS.DimPeople_Current dc ON dp.K12StaffStaffMemberIdentifierState = dc.K12StaffStaffMemberIdentifierState
-- WHERE f.K12StaffPerson_CurrentId = -1 
--   AND dp.K12StaffStaffMemberIdentifierState IS NOT NULL
--   AND dc.K12StaffStaffMemberIdentifierState IS NOT NULL

-- PRINT '    FactK12StaffAssessments K12StaffPerson_CurrentId updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- BridgeK12StudentCourseSectionK12Staff
-- UPDATE f 
-- SET K12Staff_CurrentId = dc.DimPersonId
-- FROM RDS.BridgeK12StudentCourseSectionK12Staff f
-- INNER JOIN RDS.DimPeople dp ON f.K12StaffId = dp.DimPersonId
-- INNER JOIN RDS.DimPeople_Current dc ON dp.K12StaffStaffMemberIdentifierState = dc.K12StaffStaffMemberIdentifierState
-- WHERE f.K12Staff_CurrentId = -1 
--   AND dp.K12StaffStaffMemberIdentifierState IS NOT NULL
--   AND dc.K12StaffStaffMemberIdentifierState IS NOT NULL

-- PRINT '    BridgeK12StudentCourseSectionK12Staff updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12StaffCounts
UPDATE f 
SET K12Staff_CurrentId = dc.DimPersonId
FROM RDS.FactK12StaffCounts f
INNER JOIN RDS.DimPeople dp ON f.K12StaffId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StaffStaffMemberIdentifierState = dc.K12StaffStaffMemberIdentifierState
WHERE f.K12Staff_CurrentId = -1 
  AND dp.K12StaffStaffMemberIdentifierState IS NOT NULL
  AND dc.K12StaffStaffMemberIdentifierState IS NOT NULL

PRINT '    FactK12StaffCounts updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactOrganizationCounts
UPDATE f 
SET K12Staff_CurrentId = dc.DimPersonId
FROM RDS.FactOrganizationCounts f
INNER JOIN RDS.DimPeople dp ON f.K12StaffId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.K12StaffStaffMemberIdentifierState = dc.K12StaffStaffMemberIdentifierState
WHERE f.K12Staff_CurrentId = -1 
  AND dp.K12StaffStaffMemberIdentifierState IS NOT NULL
  AND dc.K12StaffStaffMemberIdentifierState IS NOT NULL

PRINT '    FactOrganizationCounts updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- PS Student tables
PRINT 'Updating PS Student CurrentId fields...'

-- FactPsStudentAcademicRecords
UPDATE f 
SET PsStudent_CurrentId = dc.DimPersonId
FROM RDS.FactPsStudentAcademicRecords f
INNER JOIN RDS.DimPeople dp ON f.PsStudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.PsStudentStudentIdentifierState = dc.PsStudentStudentIdentifierState
WHERE f.PsStudent_CurrentId = -1 
  AND dp.PsStudentStudentIdentifierState IS NOT NULL
  AND dc.PsStudentStudentIdentifierState IS NOT NULL

PRINT '    FactPsStudentAcademicRecords updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactPsStudentCourseTranscripts
UPDATE f 
SET PsStudent_CurrentId = dc.DimPersonId
FROM RDS.FactPsStudentCourseTranscripts f
INNER JOIN RDS.DimPeople dp ON f.PsStudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.PsStudentStudentIdentifierState = dc.PsStudentStudentIdentifierState
WHERE f.PsStudent_CurrentId = -1 
  AND dp.PsStudentStudentIdentifierState IS NOT NULL
  AND dc.PsStudentStudentIdentifierState IS NOT NULL

PRINT '    FactPsStudentCourseTranscripts updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactPsStudentEnrollments
UPDATE f 
SET PsStudent_CurrentId = dc.DimPersonId
FROM RDS.FactPsStudentEnrollments f
INNER JOIN RDS.DimPeople dp ON f.PsStudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.PsStudentStudentIdentifierState = dc.PsStudentStudentIdentifierState
WHERE f.PsStudent_CurrentId = -1 
  AND dp.PsStudentStudentIdentifierState IS NOT NULL
  AND dc.PsStudentStudentIdentifierState IS NOT NULL

PRINT '    FactPsStudentEnrollments updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactPsStudentAcademicAwards
UPDATE f 
SET PsStudent_CurrentId = dc.DimPersonId
FROM RDS.FactPsStudentAcademicAwards f
INNER JOIN RDS.DimPeople dp ON f.PsStudentId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON dp.PsStudentStudentIdentifierState = dc.PsStudentStudentIdentifierState
WHERE f.PsStudent_CurrentId = -1 
  AND dp.PsStudentStudentIdentifierState IS NOT NULL
  AND dc.PsStudentStudentIdentifierState IS NOT NULL

PRINT '    FactPsStudentAcademicAwards updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- AE Student tables
PRINT 'Updating AE Student CurrentId fields...'

-- FactAeStudentEnrollments
-- UPDATE f 
-- SET AeStudent_CurrentId = dc.DimPersonId
-- FROM RDS.FactAeStudentEnrollments f
-- INNER JOIN RDS.DimPeople dp ON f.AeStudentId = dp.DimPersonId
-- INNER JOIN RDS.DimPeople_Current dc ON (
--     dp.K12StudentStudentIdentifierState = dc.K12StudentStudentIdentifierState OR
--     dp.PsStudentStudentIdentifierState = dc.PsStudentStudentIdentifierState
-- )
-- WHERE f.AeStudent_CurrentId = -1 
--   AND (dp.K12StudentStudentIdentifierState IS NOT NULL OR dp.PsStudentStudentIdentifierState IS NOT NULL)
--   AND (dc.K12StudentStudentIdentifierState IS NOT NULL OR dc.PsStudentStudentIdentifierState IS NOT NULL)

-- PRINT '    FactAeStudentEnrollments updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- Person/Contact tables (using generic person matching)
PRINT 'Updating generic person CurrentId fields...'

-- FactK12StudentDailyAttendances - Person_CurrentId
UPDATE f 
SET Person_CurrentId = dc.DimPersonId
FROM RDS.FactK12StudentDailyAttendances f
INNER JOIN RDS.DimPeople dp ON f.PersonId = dp.DimPersonId
INNER JOIN RDS.DimPeople_Current dc ON (
    ISNULL(dp.K12StudentStudentIdentifierState,'') = ISNULL(dc.K12StudentStudentIdentifierState,'') AND
    ISNULL(dp.K12StaffStaffMemberIdentifierState,'') = ISNULL(dc.K12StaffStaffMemberIdentifierState,'') AND
    ISNULL(dp.PsStudentStudentIdentifierState,'') = ISNULL(dc.PsStudentStudentIdentifierState,'')
)
WHERE f.Person_CurrentId = -1 
  AND (dp.K12StudentStudentIdentifierState IS NOT NULL OR dp.K12StaffStaffMemberIdentifierState IS NOT NULL OR dp.PsStudentStudentIdentifierState IS NOT NULL)

PRINT '    FactK12StudentDailyAttendances Person_CurrentId updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactQuarterlyEmployments - Person_CurrentId  
-- UPDATE f 
-- SET Person_CurrentId = dc.DimPersonId
-- FROM RDS.FactQuarterlyEmployments f
-- INNER JOIN RDS.DimPeople dp ON f.PersonId = dp.DimPersonId
-- INNER JOIN RDS.DimPeople_Current dc ON (
--     ISNULL(dp.K12StudentStudentIdentifierState,'') = ISNULL(dc.K12StudentStudentIdentifierState,'') AND
--     ISNULL(dp.K12StaffStaffMemberIdentifierState,'') = ISNULL(dc.K12StaffStaffMemberIdentifierState,'') AND
--     ISNULL(dp.PsStudentStudentIdentifierState,'') = ISNULL(dc.PsStudentStudentIdentifierState,'')
-- )
-- WHERE f.Person_CurrentId = -1 
--   AND (dp.K12StudentStudentIdentifierState IS NOT NULL OR dp.K12StaffStaffMemberIdentifierState IS NOT NULL OR dp.PsStudentStudentIdentifierState IS NOT NULL)

-- PRINT '    FactQuarterlyEmployments Person_CurrentId updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12ParentOrGuardians - ParentOrGuardian_CurrentId
-- UPDATE f 
-- SET ParentOrGuardian_CurrentId = dc.DimPersonId
-- FROM RDS.FactK12ParentOrGuardians f
-- INNER JOIN RDS.DimPeople dp ON f.ParentOrGuardianId = dp.DimPersonId
-- INNER JOIN RDS.DimPeople_Current dc ON (
--     ISNULL(dp.K12StudentStudentIdentifierState,'') = ISNULL(dc.K12StudentStudentIdentifierState,'') AND
--     ISNULL(dp.K12StaffStaffMemberIdentifierState,'') = ISNULL(dc.K12StaffStaffMemberIdentifierState,'') AND
--     ISNULL(dp.PsStudentStudentIdentifierState,'') = ISNULL(dc.PsStudentStudentIdentifierState,'')
-- )
-- WHERE f.ParentOrGuardian_CurrentId = -1 
--   AND (dp.K12StudentStudentIdentifierState IS NOT NULL OR dp.K12StaffStaffMemberIdentifierState IS NOT NULL OR dp.PsStudentStudentIdentifierState IS NOT NULL)

-- PRINT '    FactK12ParentOrGuardians ParentOrGuardian_CurrentId updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactK12OrganizationContacts - Contact_CurrentId
-- UPDATE f 
-- SET Contact_CurrentId = dc.DimPersonId
-- FROM RDS.FactK12OrganizationContacts f
-- INNER JOIN RDS.DimPeople dp ON f.OrganizationContactPersonId = dp.DimPersonId
-- INNER JOIN RDS.DimPeople_Current dc ON (
--     ISNULL(dp.K12StudentStudentIdentifierState,'') = ISNULL(dc.K12StudentStudentIdentifierState,'') AND
--     ISNULL(dp.K12StaffStaffMemberIdentifierState,'') = ISNULL(dc.K12StaffStaffMemberIdentifierState,'') AND
--     ISNULL(dp.PsStudentStudentIdentifierState,'') = ISNULL(dc.PsStudentStudentIdentifierState,'')
-- )
-- WHERE f.Contact_CurrentId = -1 
--   AND (dp.K12StudentStudentIdentifierState IS NOT NULL OR dp.K12StaffStaffMemberIdentifierState IS NOT NULL OR dp.PsStudentStudentIdentifierState IS NOT NULL)

-- PRINT '    FactK12OrganizationContacts Contact_CurrentId updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- FactCredentialAwards - CredentialAwardRecipientPerson_CurrentId
-- UPDATE f 
-- SET CredentialAwardRecipientPerson_CurrentId = dc.DimPersonId
-- FROM RDS.FactCredentialAwards f
-- INNER JOIN RDS.DimPeople dp ON f.CredentialAwardRecipientPersonId = dp.DimPersonId
-- INNER JOIN RDS.DimPeople_Current dc ON (
--     ISNULL(dp.K12StudentStudentIdentifierState,'') = ISNULL(dc.K12StudentStudentIdentifierState,'') AND
--     ISNULL(dp.K12StaffStaffMemberIdentifierState,'') = ISNULL(dc.K12StaffStaffMemberIdentifierState,'') AND
--     ISNULL(dp.PsStudentStudentIdentifierState,'') = ISNULL(dc.PsStudentStudentIdentifierState,'')
-- -- )
-- WHERE (f.CredentialAwardRecipientPerson_CurrentId = -1 OR f.CredentialAwardRecipientPerson_CurrentId IS NULL)
--   AND (dp.K12StudentStudentIdentifierState IS NOT NULL OR dp.K12StaffStaffMemberIdentifierState IS NOT NULL OR dp.PsStudentStudentIdentifierState IS NOT NULL)

-- PRINT '    FactCredentialAwards CredentialAwardRecipientPerson_CurrentId updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- Bridge tables for incident relationships
-- PRINT 'Updating incident bridge table CurrentId fields...'

-- BridgeK12IncidentIncidentWitnesses
-- UPDATE f 
-- SET Person_CurrentId = dc.DimPersonId
-- FROM RDS.BridgeK12IncidentIncidentWitnesses f
-- INNER JOIN RDS.DimPeople dp ON f.PersonId = dp.DimPersonId
-- INNER JOIN RDS.DimPeople_Current dc ON (
--     ISNULL(dp.K12StudentStudentIdentifierState,'') = ISNULL(dc.K12StudentStudentIdentifierState,'') AND
--     ISNULL(dp.K12StaffStaffMemberIdentifierState,'') = ISNULL(dc.K12StaffStaffMemberIdentifierState,'') AND
--     ISNULL(dp.PsStudentStudentIdentifierState,'') = ISNULL(dc.PsStudentStudentIdentifierState,'')
-- )
-- WHERE (f.Person_CurrentId = -1 OR f.Person_CurrentId IS NULL)
--   AND (dp.K12StudentStudentIdentifierState IS NOT NULL OR dp.K12StaffStaffMemberIdentifierState IS NOT NULL OR dp.PsStudentStudentIdentifierState IS NOT NULL)

-- PRINT '    BridgeK12IncidentIncidentWitnesses updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- BridgeK12IncidentIncidentVictims
-- UPDATE f 
-- SET Person_CurrentId = dc.DimPersonId
-- FROM RDS.BridgeK12IncidentIncidentVictims f
-- INNER JOIN RDS.DimPeople dp ON f.PersonId = dp.DimPersonId
-- INNER JOIN RDS.DimPeople_Current dc ON (
--     ISNULL(dp.K12StudentStudentIdentifierState,'') = ISNULL(dc.K12StudentStudentIdentifierState,'') AND
--     ISNULL(dp.K12StaffStaffMemberIdentifierState,'') = ISNULL(dc.K12StaffStaffMemberIdentifierState,'') AND
--     ISNULL(dp.PsStudentStudentIdentifierState,'') = ISNULL(dc.PsStudentStudentIdentifierState,'')
-- )
-- WHERE (f.Person_CurrentId = -1 OR f.Person_CurrentId IS NULL)
--   AND (dp.K12StudentStudentIdentifierState IS NOT NULL OR dp.K12StaffStaffMemberIdentifierState IS NOT NULL OR dp.PsStudentStudentIdentifierState IS NOT NULL)

-- PRINT '    BridgeK12IncidentIncidentVictims updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- -- BridgeK12IncidentIncidentReporters
-- UPDATE f 
-- SET Person_CurrentId = dc.DimPersonId
-- FROM RDS.BridgeK12IncidentIncidentReporters f
-- INNER JOIN RDS.DimPeople dp ON f.PersonId = dp.DimPersonId
-- INNER JOIN RDS.DimPeople_Current dc ON (
--     ISNULL(dp.K12StudentStudentIdentifierState,'') = ISNULL(dc.K12StudentStudentIdentifierState,'') AND
--     ISNULL(dp.K12StaffStaffMemberIdentifierState,'') = ISNULL(dc.K12StaffStaffMemberIdentifierState,'') AND
--     ISNULL(dp.PsStudentStudentIdentifierState,'') = ISNULL(dc.PsStudentStudentIdentifierState,'')
-- )
-- WHERE (f.Person_CurrentId = -1 OR f.Person_CurrentId IS NULL)
--   AND (dp.K12StudentStudentIdentifierState IS NOT NULL OR dp.K12StaffStaffMemberIdentifierState IS NOT NULL OR dp.PsStudentStudentIdentifierState IS NOT NULL)

-- PRINT '    BridgeK12IncidentIncidentReporters updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- -- BridgeK12IncidentIncidentPerpetrators
-- UPDATE f 
-- SET Person_CurrentId = dc.DimPersonId
-- FROM RDS.BridgeK12IncidentIncidentPerpetrators f
-- INNER JOIN RDS.DimPeople dp ON f.PersonId = dp.DimPersonId
-- INNER JOIN RDS.DimPeople_Current dc ON (
--     ISNULL(dp.K12StudentStudentIdentifierState,'') = ISNULL(dc.K12StudentStudentIdentifierState,'') AND
--     ISNULL(dp.K12StaffStaffMemberIdentifierState,'') = ISNULL(dc.K12StaffStaffMemberIdentifierState,'') AND
--     ISNULL(dp.PsStudentStudentIdentifierState,'') = ISNULL(dc.PsStudentStudentIdentifierState,'')
-- )
-- WHERE (f.Person_CurrentId = -1 OR f.Person_CurrentId IS NULL)
--   AND (dp.K12StudentStudentIdentifierState IS NOT NULL OR dp.K12StaffStaffMemberIdentifierState IS NOT NULL OR dp.PsStudentStudentIdentifierState IS NOT NULL)

-- PRINT '    BridgeK12IncidentIncidentPerpetrators updated: ' + CAST(@@ROWCOUNT AS VARCHAR(10))

-- Re-enable foreign key constraints
PRINT 'Re-enabling foreign key constraints...'
EXEC sp_msforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

PRINT 'Population of DimPeople_Current foreign key fields completed successfully!'
