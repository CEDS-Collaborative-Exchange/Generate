using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LearningStandardItemEducationLevel
    {
        public int LearningStandardItemEducationLevelId { get; set; }
        public int LearningStandardsItemId { get; set; }
        public int RefEducationLevelId { get; set; }

        public virtual LearningStandardItem LearningStandardsItem { get; set; }
        public virtual RefEducationLevel RefEducationLevel { get; set; }
    }
}
