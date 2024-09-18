using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefPurposeOfMonitoringVisit
    {
        public RefPurposeOfMonitoringVisit()
        {
            ElorganizationMonitoring = new HashSet<ElorganizationMonitoring>();
        }

        public int RefPurposeOfMonitoringVisitId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElorganizationMonitoring> ElorganizationMonitoring { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
