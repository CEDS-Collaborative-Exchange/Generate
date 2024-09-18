using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefEradministrativeDataSource
    {
        public RefEradministrativeDataSource()
        {
            QuarterlyEmploymentRecord = new HashSet<QuarterlyEmploymentRecord>();
        }

        public int RefEradministrativeDataSourceId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<QuarterlyEmploymentRecord> QuarterlyEmploymentRecord { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
