using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12studentAcademicHonor
    {
        public int K12studentAcademicHonorId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int? RefAcademicHonorTypeId { get; set; }
        public string HonorDescription { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefAcademicHonorType RefAcademicHonorType { get; set; }
    }
}
