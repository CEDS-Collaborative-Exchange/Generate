using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefParticipationStatusAyp
    {
        public RefParticipationStatusAyp()
        {
            OrganizationFederalAccountabilityRefParticipationStatusMath = new HashSet<OrganizationFederalAccountability>();
            OrganizationFederalAccountabilityRefParticipationStatusRla = new HashSet<OrganizationFederalAccountability>();
        }

        public int RefParticipationStatusAypId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<OrganizationFederalAccountability> OrganizationFederalAccountabilityRefParticipationStatusMath { get; set; }
        public virtual ICollection<OrganizationFederalAccountability> OrganizationFederalAccountabilityRefParticipationStatusRla { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
