using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationLocation
    {
        public int OrganizationLocationId { get; set; }
        public int OrganizationId { get; set; }
        public int LocationId { get; set; }
        public int? RefOrganizationLocationTypeId { get; set; }

        public virtual Location Location { get; set; }
        public virtual Organization Organization { get; set; }
        public virtual RefOrganizationLocationType RefOrganizationLocationType { get; set; }
    }
}
