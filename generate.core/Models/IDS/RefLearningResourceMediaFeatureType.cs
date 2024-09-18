using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefLearningResourceMediaFeatureType
    {
        public RefLearningResourceMediaFeatureType()
        {
            LearningResourceMediaFeature = new HashSet<LearningResourceMediaFeature>();
        }

        public int RefLearningResourceMediaFeatureTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<LearningResourceMediaFeature> LearningResourceMediaFeature { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
