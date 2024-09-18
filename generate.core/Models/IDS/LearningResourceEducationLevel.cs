using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LearningResourceEducationLevel
    {
        public int LearningResourceEducationLevelId { get; set; }
        public int LearningResourceId { get; set; }
        public int RefEducationLevelId { get; set; }

        public virtual LearningResource LearningResource { get; set; }
        public virtual RefEducationLevel RefEducationLevel { get; set; }
    }
}
