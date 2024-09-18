using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RoleStatus
    {
        public int RoleStatusId { get; set; }
        public DateTime StatusStartDate { get; set; }
        public DateTime? StatusEndDate { get; set; }
        public int? RefRoleStatusId { get; set; }
        public int OrganizationPersonRoleId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefRoleStatus RefRoleStatus { get; set; }
    }
}
