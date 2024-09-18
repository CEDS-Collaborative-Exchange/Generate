using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsStudentEnrollment
    {
        public int PsstudentEnrollmentId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int? RefPsEnrollmentTypeId { get; set; }
        public int? RefPsEnrollmentStatusId { get; set; }
        public bool? DegreeOrCertificateSeekingStudent { get; set; }
        public bool? FirstTimePostsecondaryStudent { get; set; }
        public int? RefPsStudentLevelId { get; set; }
        public int? RefPsEnrollmentAwardTypeId { get; set; }
        public string InitialEnrollmentTerm { get; set; }
        public int? RefTransferReadyId { get; set; }
        public decimal? InstructionalActivityHoursAttempted { get; set; }
        public decimal? InstructionalActivityHoursCompleted { get; set; }
        public int? RefInstructionalActivityHoursId { get; set; }
        public int? RefDistanceEducationCourseEnrollmentId { get; set; }
        public bool? HousingOnCampus { get; set; }
        public bool? FraternityParticipationStatus { get; set; }
        public bool? SororityParticipationStatus { get; set; }
        public DateTime? EntryDateIntoPostsecondary { get; set; }
        public bool? DistanceEducationProgramEnrollmentInd { get; set; }
        public bool? DoctoralCandidacyAdmitInd { get; set; }
        public DateTime? DoctoralCandidacyDate { get; set; }
        public DateTime? DoctoralExamTakenDate { get; set; }
        public int? RefDoctoralExamsRequiredCodeId { get; set; }
        public int? RefGraduateOrDoctoralExamResultsStatusId { get; set; }
        public bool? OralDefenseCompletedIndicator { get; set; }
        public DateTime? OralDefenseDate { get; set; }
        public bool? PostsecondaryEnteringStudentInd { get; set; }
        public string ThesisOrDissertationTitle { get; set; }
        public int? RefDevelopmentalEducationReferralStatusId { get; set; }
        public int? RefDevelopmentalEducationTypeId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefDevelopmentalEducationReferralStatus RefDevelopmentalEducationReferralStatus { get; set; }
        public virtual RefDevelopmentalEducationType RefDevelopmentalEducationType { get; set; }
        public virtual RefDistanceEducationCourseEnrollment RefDistanceEducationCourseEnrollment { get; set; }
        public virtual RefDoctoralExamsRequiredCode RefDoctoralExamsRequiredCode { get; set; }
        public virtual RefGraduateOrDoctoralExamResultsStatus RefGraduateOrDoctoralExamResultsStatus { get; set; }
        public virtual RefInstructionalActivityHours RefInstructionalActivityHours { get; set; }
        public virtual RefPsEnrollmentAwardType RefPsEnrollmentAwardType { get; set; }
        public virtual RefPsEnrollmentStatus RefPsEnrollmentStatus { get; set; }
        public virtual RefPsEnrollmentType RefPsEnrollmentType { get; set; }
        public virtual RefPsStudentLevel RefPsStudentLevel { get; set; }
        public virtual RefTransferReady RefTransferReady { get; set; }
    }
}
