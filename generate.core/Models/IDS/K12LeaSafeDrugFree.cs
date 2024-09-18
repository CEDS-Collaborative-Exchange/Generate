using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12leaSafeDrugFree
    {
        public int OrganizationId { get; set; }
        public string Baseline { get; set; }
        public string BaselineYear { get; set; }
        public string CollectionFrequency { get; set; }
        public string IndicatorName { get; set; }
        public string Instrument { get; set; }
        public string Performance { get; set; }
        public string Target { get; set; }
        public string MostRecentCollection { get; set; }

        public virtual K12lea Organization { get; set; }
    }
}
