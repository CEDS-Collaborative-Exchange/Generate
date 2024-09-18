using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefRoleStatus
    {
        public RefRoleStatus()
        {
            RoleStatus = new HashSet<RoleStatus>();
        }

        public int RefRoleStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }
        public int? RefRoleStatusTypeId { get; set; }

        public virtual ICollection<RoleStatus> RoleStatus { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
        public virtual RefRoleStatusType RefRoleStatusType { get; set; }
    }
}
