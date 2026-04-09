SET NOCOUNT ON;
/*******************************************************************************************************/
-- Staff Count
UPDATE f
SET K12StaffCategoryId				= ISNULL(c.DimK12StaffCategoryId, -1)
	, K12StaffStatusId				= ISNULL(s.DimK12StaffStatusId, -1)
	, TeachingCredentialStatusId	= ISNULL(t.DimTeachingCredentialStatusId, -1)
FROM RDS.FactK12StaffCounts f
JOIN upgrade.UpgFactK12StaffCounts u
	ON f.FactK12StaffCountId = u.FactK12StaffCountId
	AND f.SchoolYearId = u.SchoolYearId
LEFT JOIN RDS.DimK12StaffCategories c
	ON u.K12StaffClassificationCode						= c.K12StaffClassificationCode										
	AND u.SpecialEducationSupportServicesCategoryCode	= c.SpecialEducationSupportServicesCategoryCode
	AND u.TitleIProgramStaffCategoryCode				= c.TitleIProgramStaffCategoryCode
	AND c.MigrantEducationProgramStaffCategoryCode		= 'MISSING'
	AND c.ProfessionalEducationalJobClassificationCode	= 'MISSING'
	AND c.TitleIIILanguageInstructionIndicatorCode		= 'MISSING'
LEFT JOIN RDS.DimK12StaffStatuses s
	ON u.SpecialEducationAgeGroupTaughtCode					= s.SpecialEducationAgeGroupTaughtCode
	AND u.EdFactsCertificationStatusCode					= s.EdFactsCertificationStatusCode
	AND u.HighlyQualifiedTeacherIndicatorCode				= s.HighlyQualifiedTeacherIndicatorCode
	AND u.EdFactsTeacherInexperiencedStatusCode				= s.EdFactsTeacherInexperiencedStatusCode
	AND u.EdFactsTeacherOutOfFieldStatusCode				= s.EdFactsTeacherOutOfFieldStatusCode
	AND u.SpecialEducationTeacherQualificationStatusCode	= s.SpecialEducationTeacherQualificationStatusCode
	AND u.ParaprofessionalQualificationStatusCode			= s.ParaprofessionalQualificationStatusCode
	AND s.SpecialEducationRelatedServicesPersonnelCode		= 'MISSING'
	AND s.CTEInstructorIndustryCertificationCode			= 'MISSING'
	AND s.SpecialEducationParaprofessionalCode				= 'MISSING'
	AND s.SpecialEducationTeacherCode						= 'MISSING'
LEFT JOIN RDS.DimTeachingCredentialStatuses t
	ON u.TeachingCredentialTypeCode							= t.TeachingCredentialTypeCode
	AND t.TeachingCredentialBasisCode						= 'MISSING'
WHERE f.FactK12StaffCountId = u.FactK12StaffCountId
AND f.SchoolYearId = u.SchoolYearId

/*******************************************************************************************************/
-- Student Count
UPDATE f
SET AttendanceId = ISNULL(a.DimAttendanceId, -1)
FROM RDS.FactK12StudentCounts f
JOIN upgrade.UpgFactK12StudentCounts u
	ON f.FactK12StudentCountId = u.FactK12StudentCountId
	AND f.SchoolYearId = u.SchoolYearId
LEFT JOIN RDS.DimAttendances a
	ON u.AbsenteeismCode				= a.ChronicStudentAbsenteeismIndicatorCode
	AND a.AttendanceEventTypeCode		= 'MISSING'
	AND a.AttendanceStatusCode			= 'MISSING'
	AND a.PresentAttendanceCategoryCode	= 'MISSING'
	AND a.AbsentAttendanceCategoryCode	= 'MISSING'
WHERE f.FactK12StudentCountId = u.FactK12StudentCountId
AND f.SchoolYearId = u.SchoolYearId
AND f.FactTypeId = u.FactTypeId

/*******************************************************************************************************/
-- Disciplines
UPDATE f
SET MilitaryStatusId = ISNULL(s.DimMilitaryStatusId, -1)
FROM RDS.FactK12StudentDisciplines f
JOIN upgrade.UpgFactK12StudentDisciplines u
	ON f.FactK12StudentDisciplineId = u.FactK12StudentDisciplineId
	AND f.SchoolYearId = u.SchoolYearId
LEFT JOIN RDS.DimMilitaryStatuses s
    ON u.MilitaryConnectedStudentIndicatorCode	= s.MilitaryConnectedStudentIndicatorCode
    AND u.MilitaryActiveStudentIndicatorCode	= s.ActiveMilitaryStatusIndicatorCode
    AND u.MilitaryBranchCode					= s.MilitaryBranchCode	
    AND u.MilitaryVeteranStudentIndicatorCode	= s.MilitaryVeteranStatusIndicatorCode
WHERE f.FactK12StudentDisciplineId = u.FactK12StudentDisciplineId
AND f.SchoolYearId = u.SchoolYearId

/*******************************************************************************************************/
-- Assessment
UPDATE f
SET MilitaryStatusId = ISNULL(s.DimMilitaryStatusId, -1)
FROM RDS.FactK12StudentAssessments f
JOIN upgrade.UpgFactK12StudentAssessments u
	ON f.FactK12StudentAssessmentId = u.FactK12StudentAssessmentId
	AND f.SchoolYearId = u.SchoolYearId
LEFT JOIN RDS.DimMilitaryStatuses s
    ON u.MilitaryConnectedStudentIndicatorCode	= s.MilitaryConnectedStudentIndicatorCode
    AND u.MilitaryActiveStudentIndicatorCode	= s.ActiveMilitaryStatusIndicatorCode
    AND u.MilitaryBranchCode					= s.MilitaryBranchCode	
    AND u.MilitaryVeteranStudentIndicatorCode	= s.MilitaryVeteranStatusIndicatorCode
WHERE f.FactK12StudentAssessmentId = u.FactK12StudentAssessmentId
AND f.SchoolYearId = u.SchoolYearId
