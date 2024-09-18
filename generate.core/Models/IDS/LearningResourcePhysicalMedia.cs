using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LearningResourcePhysicalMedia
    {
        public int LearningResourcePhysicalMediaId { get; set; }
        public int LearningResourceId { get; set; }
        public int RefLearningResourcePhysicalMediaTypeId { get; set; }

        public virtual LearningResource LearningResource { get; set; }
        public virtual RefLearningResourcePhysicalMediaType RefLearningResourcePhysicalMediaType { get; set; }
    }
}
