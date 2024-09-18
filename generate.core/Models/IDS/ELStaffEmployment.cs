using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElstaffEmployment
    {
        public int StaffEmploymentId { get; set; }
        public int? RefEmploymentStatusId { get; set; }
        public decimal? HoursWorkedPerWeek { get; set; }
        public decimal? HourlyWage { get; set; }
        public int? RefWageCollectionMethodId { get; set; }
        public int? RefWageVerificationId { get; set; }
        public bool? UnionMembershipStatus { get; set; }
        public bool? StaffApprovalIndicator { get; set; }
        public int? RefEleducationStaffClassificationId { get; set; }
        public int? RefElemploymentSeparationReasonId { get; set; }
        public int? RefElserviceProfessionalStaffClassificationId { get; set; }

        public virtual RefEleducationStaffClassification RefEleducationStaffClassification { get; set; }
        public virtual RefElemploymentSeparationReason RefElemploymentSeparationReason { get; set; }
        public virtual RefElserviceProfessionalStaffClassification RefElserviceProfessionalStaffClassification { get; set; }
        public virtual RefEmploymentStatus RefEmploymentStatus { get; set; }
        public virtual RefWageCollectionMethod RefWageCollectionMethod { get; set; }
        public virtual RefWageVerification RefWageVerification { get; set; }
        public virtual StaffEmployment StaffEmployment { get; set; }
    }
}
