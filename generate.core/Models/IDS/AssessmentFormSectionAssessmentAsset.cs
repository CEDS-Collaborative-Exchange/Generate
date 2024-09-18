using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentFormSectionAssessmentAsset
    {
        public int AssessmentFormSectionAssessmentAssetId { get; set; }
        public int AssessmentFormSectionId { get; set; }
        public int AssessmentAssetId { get; set; }

        public virtual AssessmentAsset AssessmentAsset { get; set; }
        public virtual AssessmentFormSection AssessmentFormSection { get; set; }
    }
}
