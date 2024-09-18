using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefOrganizationElementType
    {
        public RefOrganizationElementType()
        {
            RefOrganizationType = new HashSet<RefOrganizationType>();
        }

        public int RefOrganizationElementTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<RefOrganizationType> RefOrganizationType { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
