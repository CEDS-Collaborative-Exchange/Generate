SET NOCOUNT ON;

CREATE TABLE Upgrade.UpgFactK12StudentCounts (
	FactK12StudentCountId	INT
	, FactTypeId			INT
	, SchoolYearId			SMALLINT
	, AbsenteeismCode		VARCHAR(25)
    --, rdms.MilitaryConnectedStudentIndicatorCode
    --, rdms.MilitaryActiveStudentIndicatorCode
    --, rdms.MilitaryBranchCode
    --, rdms.MilitaryVeteranStudentIndicatorCode
)

INSERT INTO Upgrade.UpgFactK12StudentCounts (
   	FactK12StudentCountId
	, FactTypeId
	, SchoolYearId
	, AbsenteeismCode
)
SELECT 
	f.FactK12StudentCountId
	, f.FactTypeId
	, rdsy.DimSchoolYearId
	, rda.AbsenteeismCode
FROM RDS.FactK12StudentCounts f
JOIN RDS.DimSchoolYears rdsy ON f.SchoolYearId = rdsy.DimSchoolYearId
LEFT JOIN RDS.DimAttendances rda ON f.AttendanceId = rda.DimAttendanceId
--LEFT JOIN RDS.DimMilitaryStatuses rdms ON f.MilitaryStatusId = rdms.DimMilitaryStatusId

/*******************************************************************************************************/

CREATE TABLE Upgrade.UpgFactK12StudentDisciplines (
	FactK12StudentDisciplineId				INT
	, SchoolYearId							SMALLINT
    , MilitaryConnectedStudentIndicatorCode	NVARCHAR(200)
    , MilitaryActiveStudentIndicatorCode	NVARCHAR(200)
    , MilitaryBranchCode					NVARCHAR(200)
    , MilitaryVeteranStudentIndicatorCode	NVARCHAR(200)
)

INSERT INTO Upgrade.UpgFactK12StudentDisciplines (
   	FactK12StudentDisciplineId
	, SchoolYearId
    , MilitaryConnectedStudentIndicatorCode
    , MilitaryActiveStudentIndicatorCode
    , MilitaryBranchCode
    , MilitaryVeteranStudentIndicatorCode
)
SELECT 
	f.FactK12StudentDisciplineId
	, rdsy.DimSchoolYearId
    , rdms.MilitaryConnectedStudentIndicatorCode
    , rdms.MilitaryActiveStudentIndicatorCode
    , rdms.MilitaryBranchCode
    , rdms.MilitaryVeteranStudentIndicatorCode
FROM RDS.FactK12StudentDisciplines f
JOIN RDS.DimSchoolYears rdsy ON f.SchoolYearId = rdsy.DimSchoolYearId
JOIN RDS.DimMilitaryStatuses rdms ON f.MilitaryStatusId = rdms.DimMilitaryStatusId


/*******************************************************************************************************/

CREATE TABLE Upgrade.UpgFactK12StaffCounts (
	FactK12StaffCountId									INT
	, SchoolYearId										SMALLINT
	, K12StaffClassificationCode						NVARCHAR(200)
	, SpecialEducationSupportServicesCategoryCode		NVARCHAR(200)
	, TitleIProgramStaffCategoryCode					NVARCHAR(200)
	, SpecialEducationAgeGroupTaughtCode				NVARCHAR(200)
	, EdFactsCertificationStatusCode					NVARCHAR(200)
	, HighlyQualifiedTeacherIndicatorCode				NVARCHAR(200)
	, EdFactsTeacherInexperiencedStatusCode				NVARCHAR(200)
	, TeachingCredentialTypeCode						NVARCHAR(200)
	, EdFactsTeacherOutOfFieldStatusCode				NVARCHAR(200)
	, SpecialEducationTeacherQualificationStatusCode	NVARCHAR(200)
	, ParaprofessionalQualificationStatusCode			NVARCHAR(200)
)

INSERT INTO Upgrade.UpgFactK12StaffCounts (
   	FactK12StaffCountId
	, SchoolYearId
	, K12StaffClassificationCode
	, SpecialEducationSupportServicesCategoryCode
	, TitleIProgramStaffCategoryCode
	, SpecialEducationAgeGroupTaughtCode
	, EdFactsCertificationStatusCode
	, HighlyQualifiedTeacherIndicatorCode
	, EdFactsTeacherInexperiencedStatusCode
	, TeachingCredentialTypeCode
	, EdFactsTeacherOutOfFieldStatusCode
	, SpecialEducationTeacherQualificationStatusCode
	, ParaprofessionalQualificationStatusCode
)
SELECT 
	f.FactK12StaffCountId
	, rdsy.DimSchoolYearId
	, rdksc.K12StaffClassificationCode
	, rdksc.SpecialEducationSupportServicesCategoryCode
	, rdksc.TitleIProgramStaffCategoryCode
	, rdkss.SpecialEducationAgeGroupTaughtCode
	, rdkss.EdFactsCertificationStatusCode
	, rdkss.HighlyQualifiedTeacherIndicatorCode
	, rdkss.EdFactsTeacherInexperiencedStatusCode
	, rdkss.TeachingCredentialTypeCode
	, rdkss.EdFactsTeacherOutOfFieldStatusCode
	, rdkss.SpecialEducationTeacherQualificationStatusCode
	, rdkss.ParaprofessionalQualificationStatusCode
FROM RDS.FactK12StaffCounts f
JOIN RDS.DimSchoolYears rdsy ON f.SchoolYearId = rdsy.DimSchoolYearId
JOIN RDS.DimK12StaffCategories rdksc ON f.K12StaffCategoryId = rdksc.DimK12StaffCategoryId
JOIN RDS.DimK12StaffStatuses rdkss ON f.K12StaffStatusId = rdkss.DimK12StaffStatusId


/*******************************************************************************************************/

CREATE TABLE Upgrade.UpgFactK12StudentAssessments (
	FactK12StudentAssessmentId				INT
	, SchoolYearId							SMALLINT
    , MilitaryConnectedStudentIndicatorCode	NVARCHAR(200)
    , MilitaryActiveStudentIndicatorCode	NVARCHAR(200)
    , MilitaryBranchCode					NVARCHAR(200)
    , MilitaryVeteranStudentIndicatorCode	NVARCHAR(200)
)

INSERT INTO Upgrade.UpgFactK12StudentAssessments (
   	FactK12StudentAssessmentId
	, SchoolYearId
    , MilitaryConnectedStudentIndicatorCode
    , MilitaryActiveStudentIndicatorCode
    , MilitaryBranchCode
    , MilitaryVeteranStudentIndicatorCode
)
SELECT 
	f.FactK12StudentAssessmentId
	, rdsy.DimSchoolYearId
    , rdms.MilitaryConnectedStudentIndicatorCode
    , rdms.MilitaryActiveStudentIndicatorCode
    , rdms.MilitaryBranchCode
    , rdms.MilitaryVeteranStudentIndicatorCode
FROM RDS.FactK12StudentAssessments f
JOIN RDS.DimSchoolYears rdsy ON f.SchoolYearId = rdsy.DimSchoolYearId
JOIN RDS.DimMilitaryStatuses rdms ON f.MilitaryStatusId = rdms.DimMilitaryStatusId
