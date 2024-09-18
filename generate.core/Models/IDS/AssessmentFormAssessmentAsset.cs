using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentFormAssessmentAsset
    {
        public int AssessmentFormAssessmentAssetId { get; set; }
        public int AssessmentFormId { get; set; }
        public int AssessmentAssetId { get; set; }

        public virtual AssessmentAsset AssessmentAsset { get; set; }
        public virtual AssessmentForm AssessmentForm { get; set; }
    }
}
