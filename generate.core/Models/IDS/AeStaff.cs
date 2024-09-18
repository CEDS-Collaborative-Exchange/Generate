using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AeStaff
    {
        public int OrganizationPersonRoleId { get; set; }
        public int? RefAeStaffClassificationId { get; set; }
        public int? RefAeStaffEmploymentStatusId { get; set; }
        public decimal? YearsOfPriorAeTeachingExperience { get; set; }
        public int? RefAeCertificationTypeId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefAeCertificationType RefAeCertificationType { get; set; }
        public virtual RefAeStaffClassification RefAeStaffClassification { get; set; }
        public virtual RefAeStaffEmploymentStatus RefAeStaffEmploymentStatus { get; set; }
    }
}
