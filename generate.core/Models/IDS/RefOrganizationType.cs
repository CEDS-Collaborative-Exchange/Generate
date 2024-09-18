using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefOrganizationType
    {
        public RefOrganizationType()
        {
            OrganizationDetail = new HashSet<OrganizationDetail>();
            RefOrganizationIndicator = new HashSet<RefOrganizationIndicator>();
        }

        public int RefOrganizationTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public int? RefOrganizationElementTypeId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<OrganizationDetail> OrganizationDetail { get; set; }
        public virtual ICollection<RefOrganizationIndicator> RefOrganizationIndicator { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
        public virtual RefOrganizationElementType RefOrganizationElementType { get; set; }
    }
}
