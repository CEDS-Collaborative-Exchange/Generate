using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationRelationship
    {
        public int OrganizationRelationshipId { get; set; }
        public int ParentOrganizationId { get; set; }
        public int OrganizationId { get; set; }
        public int? RefOrganizationRelationshipId { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual Organization ParentOrganization { get; set; }
        public virtual RefOrganizationRelationship RefOrganizationRelationship { get; set; }
    }
}
