using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12studentEnrollment
    {
        public int OrganizationPersonRoleId { get; set; }
        public int? RefEntryGradeLevelId { get; set; }
        public int? RefPublicSchoolResidence { get; set; }
        public int? RefEnrollmentStatusId { get; set; }
        public int? RefEntryType { get; set; }
        public int? RefExitGradeLevel { get; set; }
        public int? RefExitOrWithdrawalStatusId { get; set; }
        public int? RefExitOrWithdrawalTypeId { get; set; }
        public bool? DisplacedStudentStatus { get; set; }
        public int? RefEndOfTermStatusId { get; set; }
        public int? RefPromotionReasonId { get; set; }
        public int? RefNonPromotionReasonId { get; set; }
        public int? RefFoodServiceEligibilityId { get; set; }
        public DateTime? FirstEntryDateIntoUsschool { get; set; }
        public int? RefDirectoryInformationBlockStatusId { get; set; }
        public bool? NslpdirectCertificationIndicator { get; set; }
        public int K12studentEnrollmentId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefDirectoryInformationBlockStatus RefDirectoryInformationBlockStatus { get; set; }
        public virtual RefEndOfTermStatus RefEndOfTermStatus { get; set; }
        public virtual RefEnrollmentStatus RefEnrollmentStatus { get; set; }
        public virtual RefGradeLevel RefEntryGradeLevel { get; set; }
        public virtual RefEntryType RefEntryTypeNavigation { get; set; }
        public virtual RefGradeLevel RefExitGradeLevelNavigation { get; set; }
        public virtual RefExitOrWithdrawalStatus RefExitOrWithdrawalStatus { get; set; }
        public virtual RefExitOrWithdrawalType RefExitOrWithdrawalType { get; set; }
        public virtual RefFoodServiceEligibility RefFoodServiceEligibility { get; set; }
        public virtual RefNonPromotionReason RefNonPromotionReason { get; set; }
        public virtual RefPromotionReason RefPromotionReason { get; set; }
        public virtual RefPublicSchoolResidence RefPublicSchoolResidenceNavigation { get; set; }
    }
}
