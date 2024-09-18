using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentItemResponseTheory
    {
        public int AssessmentItemId { get; set; }
        public int? ParameterA { get; set; }
        public int? ParameterB { get; set; }
        public int? RefItemResponseTheoryDifficultyCategoryId { get; set; }
        public int? ParameterC { get; set; }
        public int? ParameterD1 { get; set; }
        public int? ParameterD2 { get; set; }
        public int? ParameterD3 { get; set; }
        public int? ParameterD4 { get; set; }
        public int? ParameterD5 { get; set; }
        public int? ParameterD6 { get; set; }
        public int? PointBiserialCorrelationValue { get; set; }
        public int? Difvalue { get; set; }
        public int? KappaValue { get; set; }
        public int? RefItemResponseTheoryKappaAlgorithmId { get; set; }

        public virtual AssessmentItem AssessmentItem { get; set; }
        public virtual RefItemResponseTheoryDifficultyCategory RefItemResponseTheoryDifficultyCategory { get; set; }
        public virtual RefItemResponseTheoryKappaAlgorithm RefItemResponseTheoryKappaAlgorithm { get; set; }
    }
}
