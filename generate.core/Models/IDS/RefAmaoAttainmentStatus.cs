using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAmaoAttainmentStatus
    {
        public RefAmaoAttainmentStatus()
        {
            OrganizationFederalAccountabilityAmaoAypProgressAttainmentLepStudentsNavigation = new HashSet<OrganizationFederalAccountability>();
            OrganizationFederalAccountabilityAmaoProficiencyAttainmentLepStudentsNavigation = new HashSet<OrganizationFederalAccountability>();
            OrganizationFederalAccountabilityAmaoProgressAttainmentLepStudentsNavigation = new HashSet<OrganizationFederalAccountability>();
        }

        public int RefAmaoAttainmentStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<OrganizationFederalAccountability> OrganizationFederalAccountabilityAmaoAypProgressAttainmentLepStudentsNavigation { get; set; }
        public virtual ICollection<OrganizationFederalAccountability> OrganizationFederalAccountabilityAmaoProficiencyAttainmentLepStudentsNavigation { get; set; }
        public virtual ICollection<OrganizationFederalAccountability> OrganizationFederalAccountabilityAmaoProgressAttainmentLepStudentsNavigation { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
