using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefEnvironmentSetting
    {
        public RefEnvironmentSetting()
        {
            ElclassSection = new HashSet<ElclassSection>();
            ElorganizationAvailability = new HashSet<ElorganizationAvailability>();
        }

        public int RefEnvironmentSettingId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElclassSection> ElclassSection { get; set; }
        public virtual ICollection<ElorganizationAvailability> ElorganizationAvailability { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
