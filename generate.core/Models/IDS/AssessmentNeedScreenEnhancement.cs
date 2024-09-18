using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentNeedScreenEnhancement
    {
        public int AssessmentNeedScreenEnhancementId { get; set; }
        public int AssessmentPersonalNeedsProfileDisplayId { get; set; }
        public bool? InvertColorChoice { get; set; }
        public decimal? Magnification { get; set; }
        public int? AssessmentPersonalNeedsProfileScreenEnhancementId { get; set; }
        public string ForegroundColor { get; set; }

        public virtual AssessmentPersonalNeedsProfileDisplay AssessmentPersonalNeedsProfileDisplay { get; set; }
        public virtual AssessmentPersonalNeedsProfileScreenEnhancement AssessmentPersonalNeedsProfileScreenEnhancement { get; set; }
    }
}
