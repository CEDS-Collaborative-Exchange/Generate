using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Role
    {
        public Role()
        {
            OrganizationPersonRole = new HashSet<OrganizationPersonRole>();
        }

        public int RoleId { get; set; }
        public string Name { get; set; }
        public int? RefJurisdictionId { get; set; }

        public virtual ICollection<OrganizationPersonRole> OrganizationPersonRole { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
