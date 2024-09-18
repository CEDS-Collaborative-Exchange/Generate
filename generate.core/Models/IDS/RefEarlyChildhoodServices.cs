using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefEarlyChildhoodServices
    {
        public RefEarlyChildhoodServices()
        {
            ElchildServiceRefEarlyChildhoodServicesOffered = new HashSet<ElchildService>();
            ElchildServiceRefEarlyChildhoodServicesReceived = new HashSet<ElchildService>();
        }

        public int RefEarlyChildhoodServicesId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElchildService> ElchildServiceRefEarlyChildhoodServicesOffered { get; set; }
        public virtual ICollection<ElchildService> ElchildServiceRefEarlyChildhoodServicesReceived { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
