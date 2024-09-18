using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentAsset
    {
        public AssessmentAsset()
        {
            AssessmentFormAssessmentAsset = new HashSet<AssessmentFormAssessmentAsset>();
            AssessmentFormSectionAssessmentAsset = new HashSet<AssessmentFormSectionAssessmentAsset>();
        }

        public int AssessmentAssetId { get; set; }
        public string Version { get; set; }
        public DateTime? PublishedDate { get; set; }
        public string Identifier { get; set; }
        public int? RefAssessmentAssestIdentifierType { get; set; }
        public string Name { get; set; }
        public int? RefAssessmentAssetTypeId { get; set; }
        public string Owner { get; set; }
        public int? RefAssessmentLanguageId { get; set; }
        public string ContentXml { get; set; }
        public string ContentMimeType { get; set; }
        public string ContentUrl { get; set; }
        public int? LearningResourceId { get; set; }

        public virtual ICollection<AssessmentFormAssessmentAsset> AssessmentFormAssessmentAsset { get; set; }
        public virtual ICollection<AssessmentFormSectionAssessmentAsset> AssessmentFormSectionAssessmentAsset { get; set; }
        public virtual LearningResource LearningResource { get; set; }
        public virtual RefAssessmentAssetIdentifierType RefAssessmentAssestIdentifierTypeNavigation { get; set; }
        public virtual RefAssessmentAssetType RefAssessmentAssetType { get; set; }
        public virtual RefLanguage RefAssessmentLanguage { get; set; }
    }
}
