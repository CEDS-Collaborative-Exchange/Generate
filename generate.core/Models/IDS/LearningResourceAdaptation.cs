using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LearningResourceAdaptation
    {
        public int LearningResourceAdaptationId { get; set; }
        public int LearningResourceId { get; set; }
        public string AdaptationUrl { get; set; }

        public virtual LearningResource LearningResource { get; set; }
    }
}
