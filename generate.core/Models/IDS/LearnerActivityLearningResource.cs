using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LearnerActivityLearningResource
    {
        public int LearnerActivityLearningResourceId { get; set; }
        public int LearnerActivityId { get; set; }
        public int LearningResourceId { get; set; }

        public virtual LearnerActivity LearnerActivity { get; set; }
        public virtual LearningResource LearningResource { get; set; }
    }
}
