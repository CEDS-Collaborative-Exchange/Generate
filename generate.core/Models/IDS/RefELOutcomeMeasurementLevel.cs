using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefEloutcomeMeasurementLevel
    {
        public RefEloutcomeMeasurementLevel()
        {
            AssessmentResult = new HashSet<AssessmentResult>();
        }

        public int RefEloutcomeMeasurementLevelId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentResult> AssessmentResult { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
