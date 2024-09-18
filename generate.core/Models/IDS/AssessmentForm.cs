using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentForm
    {
        public AssessmentForm()
        {
            AssessmentFormAssessmentAsset = new HashSet<AssessmentFormAssessmentAsset>();
            AssessmentFormAssessmentFormSection = new HashSet<AssessmentFormAssessmentFormSection>();
            AssessmentRegistration = new HashSet<AssessmentRegistration>();
            AssessmentSubtest = new HashSet<AssessmentSubtest>();
        }

        public int AssessmentFormId { get; set; }
        public int AssessmentId { get; set; }
        public string FormNumber { get; set; }
        public string Name { get; set; }
        public string Version { get; set; }
        public DateTime? PublishedDate { get; set; }
        public string AccommodationList { get; set; }
        public DateTime? IntendedAdministrationStartDate { get; set; }
        public DateTime? IntendedAdministrationEndDate { get; set; }
        public string AssessmentItemBankIdentifier { get; set; }
        public string AssessmentItemBankName { get; set; }
        public string PlatformsSupported { get; set; }
        public int? RefAssessmentLanguageId { get; set; }
        public bool? AssessmentSecureIndicator { get; set; }
        public int? LearningResourceId { get; set; }
        public bool? AssessmentFormAdaptiveIndicator { get; set; }
        public string AssessmentFormAlgorithmIdentifier { get; set; }
        public string AssessmentFormAlgorithmVersion { get; set; }
        public string AssessmentFormGuid { get; set; }

        public virtual ICollection<AssessmentFormAssessmentAsset> AssessmentFormAssessmentAsset { get; set; }
        public virtual ICollection<AssessmentFormAssessmentFormSection> AssessmentFormAssessmentFormSection { get; set; }
        public virtual ICollection<AssessmentRegistration> AssessmentRegistration { get; set; }
        public virtual ICollection<AssessmentSubtest> AssessmentSubtest { get; set; }
        public virtual Assessment Assessment { get; set; }
        public virtual LearningResource LearningResource { get; set; }
        public virtual RefLanguage RefAssessmentLanguage { get; set; }
    }
}
