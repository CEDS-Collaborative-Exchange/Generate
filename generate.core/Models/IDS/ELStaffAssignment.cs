using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElstaffAssignment
    {
        public int OrganizationPersonRoleId { get; set; }
        public bool ItinerantProvider { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
    }
}
