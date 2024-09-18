using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefSessionType
    {
        public RefSessionType()
        {
            OrganizationCalendarSession = new HashSet<OrganizationCalendarSession>();
        }

        public int RefSessionTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<OrganizationCalendarSession> OrganizationCalendarSession { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
