using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefElgroupSizeStandardMet
    {
        public RefElgroupSizeStandardMet()
        {
            ElclassSectionService = new HashSet<ElclassSectionService>();
        }

        public int RefElgroupSizeStandardMetId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElclassSectionService> ElclassSectionService { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
