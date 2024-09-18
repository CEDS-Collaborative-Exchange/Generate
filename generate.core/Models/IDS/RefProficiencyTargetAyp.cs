using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefProficiencyTargetAyp
    {
        public RefProficiencyTargetAyp()
        {
            OrganizationFederalAccountabilityRefProficiencyTargetStatusMath = new HashSet<OrganizationFederalAccountability>();
            OrganizationFederalAccountabilityRefProficiencyTargetStatusRla = new HashSet<OrganizationFederalAccountability>();
        }

        public int RefProficiencyTargetAypId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<OrganizationFederalAccountability> OrganizationFederalAccountabilityRefProficiencyTargetStatusMath { get; set; }
        public virtual ICollection<OrganizationFederalAccountability> OrganizationFederalAccountabilityRefProficiencyTargetStatusRla { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
