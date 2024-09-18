using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefActivityRecognitionType
    {
        public RefActivityRecognitionType()
        {
            ActivityRecognition = new HashSet<ActivityRecognition>();
        }

        public int RefActivityRecognitionTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ActivityRecognition> ActivityRecognition { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
