using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefOperationalStatus
    {
        public RefOperationalStatus()
        {
            OrganizationOperationalStatus = new HashSet<OrganizationOperationalStatus>();
        }

        public int RefOperationalStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public int? RefOperationalStatusTypeId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<OrganizationOperationalStatus> OrganizationOperationalStatus { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
        public virtual RefOperationalStatusType RefOperationalStatusType { get; set; }
    }
}
