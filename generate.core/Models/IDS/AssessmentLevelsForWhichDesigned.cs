using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentLevelsForWhichDesigned
    {
        public int AssessmentLevelsForWhichDesignedId { get; set; }
        public int AssessmentId { get; set; }
        public int RefGradeLevelId { get; set; }

        public virtual Assessment Assessment { get; set; }
        public virtual RefGradeLevel RefGradeLevel { get; set; }
    }
}
