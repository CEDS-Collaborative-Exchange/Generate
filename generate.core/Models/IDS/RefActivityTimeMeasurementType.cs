using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefActivityTimeMeasurementType
    {
        public RefActivityTimeMeasurementType()
        {
            K12studentActivity = new HashSet<K12studentActivity>();
        }

        public int RefActivityTimeMeasurementTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12studentActivity> K12studentActivity { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
