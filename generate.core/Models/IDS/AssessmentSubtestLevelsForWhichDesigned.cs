using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentSubtestLevelsForWhichDesigned
    {
        public int AssessmentSubtestLevelsForWhichDesignedId { get; set; }
        public int AssessmentSubTestId { get; set; }
        public int RefGradeId { get; set; }

        public virtual AssessmentSubtest AssessmentSubTest { get; set; }
        public virtual RefGradeLevel RefGrade { get; set; }
    }
}
