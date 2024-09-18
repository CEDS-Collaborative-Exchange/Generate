using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefOrganizationLocationType
    {
        public RefOrganizationLocationType()
        {
            OrganizationLocation = new HashSet<OrganizationLocation>();
        }

        public int RefOrganizationLocationTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<OrganizationLocation> OrganizationLocation { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
