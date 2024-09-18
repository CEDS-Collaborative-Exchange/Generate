using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentNeedBraille
    {
        public int AssessmentNeedBrailleId { get; set; }
        public int? AssessmentPersonalNeedsProfileDisplayId { get; set; }
        public int? RefAssessmentNeedUsageTypeId { get; set; }
        public int? RefAssessmentNeedBrailleGradeTypeId { get; set; }
        public int? RefAssessmentNeedNumberOfBrailleDotsId { get; set; }
        public int? NumberOfBrailleCells { get; set; }
        public int? RefAssessmentNeedBrailleMarkTypeId { get; set; }
        public decimal? BrailleDotPressure { get; set; }
        public int? RefAssessmentNeedBrailleStatusCellTypeId { get; set; }

        public virtual AssessmentPersonalNeedsProfileDisplay AssessmentPersonalNeedsProfileDisplay { get; set; }
        public virtual RefAssessmentNeedBrailleGradeType RefAssessmentNeedBrailleGradeType { get; set; }
        public virtual RefAssessmentNeedBrailleMarkType RefAssessmentNeedBrailleMarkType { get; set; }
        public virtual RefAssessmentNeedBrailleStatusCellType RefAssessmentNeedBrailleStatusCellType { get; set; }
        public virtual RefAssessmentNeedNumberOfBrailleDots RefAssessmentNeedNumberOfBrailleDots { get; set; }
        public virtual RefAssessmentNeedUsageType RefAssessmentNeedUsageType { get; set; }
    }
}
