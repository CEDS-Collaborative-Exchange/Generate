using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class StaffEmployment
    {
        public int StaffEmploymentId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public DateTime? HireDate { get; set; }
        public string PositionTitle { get; set; }
        public int? RefEmploymentSeparationTypeId { get; set; }
        public int? RefEmploymentSeparationReasonId { get; set; }
        public string UnionMembershipName { get; set; }
        public int? WeeksEmployedPerYear { get; set; }

        public virtual ElstaffEmployment ElstaffEmployment { get; set; }
        public virtual K12staffEmployment K12staffEmployment { get; set; }
        public virtual PsStaffEmployment PsStaffEmployment { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefEmploymentSeparationReason RefEmploymentSeparationReason { get; set; }
        public virtual RefEmploymentSeparationType RefEmploymentSeparationType { get; set; }
    }
}
