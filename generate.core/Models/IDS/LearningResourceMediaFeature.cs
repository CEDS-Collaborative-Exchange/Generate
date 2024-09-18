using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LearningResourceMediaFeature
    {
        public int LearningResourceMediaFeatureId { get; set; }
        public int LearningResourceId { get; set; }
        public int RefLearningResourceMediaFeatureTypeId { get; set; }

        public virtual LearningResource LearningResource { get; set; }
        public virtual RefLearningResourceMediaFeatureType RefLearningResourceMediaFeatureType { get; set; }
    }
}
