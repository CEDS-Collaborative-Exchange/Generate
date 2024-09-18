using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefOrganizationRelationship
    {
        public RefOrganizationRelationship()
        {
            OrganizationRelationship = new HashSet<OrganizationRelationship>();
        }

        public int RefOrganizationRelationshipId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<OrganizationRelationship> OrganizationRelationship { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
