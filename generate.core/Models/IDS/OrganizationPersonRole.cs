using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationPersonRole
    {
        public OrganizationPersonRole()
        {
            ActivityRecognition = new HashSet<ActivityRecognition>();
            Authentication = new HashSet<Authentication>();
            Authorization = new HashSet<Authorization>();
            FinancialAidApplication = new HashSet<FinancialAidApplication>();
            FinancialAidAward = new HashSet<FinancialAidAward>();
            Incident = new HashSet<Incident>();
            IndividualizedProgram = new HashSet<IndividualizedProgram>();
            K12organizationStudentResponsibility = new HashSet<K12organizationStudentResponsibility>();
            K12staffAssignment = new HashSet<K12staffAssignment>();
            K12studentAcademicHonor = new HashSet<K12studentAcademicHonor>();
            K12studentDiscipline = new HashSet<K12studentDiscipline>();
            K12studentEnrollment = new HashSet<K12studentEnrollment>();
            K12studentSession = new HashSet<K12studentSession>();
            PersonProgramParticipation = new HashSet<PersonProgramParticipation>();
            ProfessionalDevelopmentRequirement = new HashSet<ProfessionalDevelopmentRequirement>();
            ProfessionalDevelopmentSessionInstructor = new HashSet<ProfessionalDevelopmentSessionInstructor>();
            PsStudentAcademicAward = new HashSet<PsStudentAcademicAward>();
            PsStudentAcademicRecord = new HashSet<PsStudentAcademicRecord>();
            PsStudentAdmissionTest = new HashSet<PsStudentAdmissionTest>();
            PsStudentEnrollment = new HashSet<PsStudentEnrollment>();
            PsstudentProgram = new HashSet<PsstudentProgram>();
            RoleAttendance = new HashSet<RoleAttendance>();
            RoleAttendanceEvent = new HashSet<RoleAttendanceEvent>();
            RoleStatus = new HashSet<RoleStatus>();
            ServicesReceived = new HashSet<ServicesReceived>();
            StaffEmployment = new HashSet<StaffEmployment>();
            StaffEvaluation = new HashSet<StaffEvaluation>();
            StaffProfessionalDevelopmentActivity = new HashSet<StaffProfessionalDevelopmentActivity>();
            StaffTechnicalAssistance = new HashSet<StaffTechnicalAssistance>();
        }

        public int OrganizationPersonRoleId { get; set; }
        public int OrganizationId { get; set; }
        public int PersonId { get; set; }
        public int RoleId { get; set; }
        public DateTime? EntryDate { get; set; }
        public DateTime? ExitDate { get; set; }

        public virtual ICollection<ActivityRecognition> ActivityRecognition { get; set; }
        public virtual AeStaff AeStaff { get; set; }
        public virtual AeStudentAcademicRecord AeStudentAcademicRecord { get; set; }
        public virtual AeStudentEmployment AeStudentEmployment { get; set; }
        public virtual ICollection<Authentication> Authentication { get; set; }
        public virtual ICollection<Authorization> Authorization { get; set; }
        public virtual CteStudentAcademicRecord CteStudentAcademicRecord { get; set; }
        public virtual ElchildProgramEligibility ElchildProgramEligibility { get; set; }
        public virtual ElchildService ElchildService { get; set; }
        public virtual ElchildServicesApplication ElchildServicesApplication { get; set; }
        public virtual Elenrollment Elenrollment { get; set; }
        public virtual Elstaff Elstaff { get; set; }
        public virtual ElstaffAssignment ElstaffAssignment { get; set; }
        public virtual ICollection<FinancialAidApplication> FinancialAidApplication { get; set; }
        public virtual ICollection<FinancialAidAward> FinancialAidAward { get; set; }
        public virtual ICollection<Incident> Incident { get; set; }
        public virtual ICollection<IndividualizedProgram> IndividualizedProgram { get; set; }
        public virtual ICollection<K12organizationStudentResponsibility> K12organizationStudentResponsibility { get; set; }
        public virtual ICollection<K12staffAssignment> K12staffAssignment { get; set; }
        public virtual ICollection<K12studentAcademicHonor> K12studentAcademicHonor { get; set; }
        public virtual K12studentAcademicRecord K12studentAcademicRecord { get; set; }
        public virtual K12studentActivity K12studentActivity { get; set; }
        public virtual K12studentCohort K12studentCohort { get; set; }
        public virtual K12studentCourseSection K12studentCourseSection { get; set; }
        public virtual ICollection<K12studentDiscipline> K12studentDiscipline { get; set; }
        public virtual K12studentEmployment K12studentEmployment { get; set; }
        public virtual ICollection<K12studentEnrollment> K12studentEnrollment { get; set; }
        public virtual K12studentGraduationPlan K12studentGraduationPlan { get; set; }
        public virtual K12studentLiteracyAssessment K12studentLiteracyAssessment { get; set; }
        public virtual ICollection<K12studentSession> K12studentSession { get; set; }
        public virtual ICollection<PersonProgramParticipation> PersonProgramParticipation { get; set; }
        public virtual ICollection<ProfessionalDevelopmentRequirement> ProfessionalDevelopmentRequirement { get; set; }
        public virtual ICollection<ProfessionalDevelopmentSessionInstructor> ProfessionalDevelopmentSessionInstructor { get; set; }
        public virtual ICollection<PsStudentAcademicAward> PsStudentAcademicAward { get; set; }
        public virtual ICollection<PsStudentAcademicRecord> PsStudentAcademicRecord { get; set; }
        public virtual ICollection<PsStudentAdmissionTest> PsStudentAdmissionTest { get; set; }
        public virtual PsStudentApplication PsStudentApplication { get; set; }
        public virtual PsStudentCohort PsStudentCohort { get; set; }
        public virtual PsStudentDemographic PsStudentDemographic { get; set; }
        public virtual PsStudentEmployment PsStudentEmployment { get; set; }
        public virtual ICollection<PsStudentEnrollment> PsStudentEnrollment { get; set; }
        public virtual PsStudentFinancialAid PsStudentFinancialAid { get; set; }
        public virtual ICollection<PsstudentProgram> PsstudentProgram { get; set; }
        public virtual PsStudentSection PsStudentSection { get; set; }
        public virtual ICollection<RoleAttendance> RoleAttendance { get; set; }
        public virtual ICollection<RoleAttendanceEvent> RoleAttendanceEvent { get; set; }
        public virtual ICollection<RoleStatus> RoleStatus { get; set; }
        public virtual ICollection<ServicesReceived> ServicesReceived { get; set; }
        public virtual ICollection<StaffEmployment> StaffEmployment { get; set; }
        public virtual ICollection<StaffEvaluation> StaffEvaluation { get; set; }
        public virtual ICollection<StaffProfessionalDevelopmentActivity> StaffProfessionalDevelopmentActivity { get; set; }
        public virtual ICollection<StaffTechnicalAssistance> StaffTechnicalAssistance { get; set; }
        public virtual WorkforceEmploymentQuarterlyData WorkforceEmploymentQuarterlyData { get; set; }
        public virtual Organization Organization { get; set; }
        public virtual Person Person { get; set; }
        public virtual Role Role { get; set; }
    }
}
