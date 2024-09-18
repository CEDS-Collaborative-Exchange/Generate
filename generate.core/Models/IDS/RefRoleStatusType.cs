using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefRoleStatusType
    {
        public RefRoleStatusType()
        {
            RefRoleStatus = new HashSet<RefRoleStatus>();
        }

        public int RefRoleStatusTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<RefRoleStatus> RefRoleStatus { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
