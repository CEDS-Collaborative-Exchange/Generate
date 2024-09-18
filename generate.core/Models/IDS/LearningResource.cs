using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LearningResource
    {
        public LearningResource()
        {
            AssessmentAsset = new HashSet<AssessmentAsset>();
            AssessmentForm = new HashSet<AssessmentForm>();
            AssessmentFormSection = new HashSet<AssessmentFormSection>();
            AssessmentItem = new HashSet<AssessmentItem>();
            LearnerActivityLearningResource = new HashSet<LearnerActivityLearningResource>();
            LearningResourceAdaptation = new HashSet<LearningResourceAdaptation>();
            LearningResourceEducationLevel = new HashSet<LearningResourceEducationLevel>();
            LearningResourceMediaFeature = new HashSet<LearningResourceMediaFeature>();
            LearningResourcePeerRating = new HashSet<LearningResourcePeerRating>();
            LearningResourcePhysicalMedia = new HashSet<LearningResourcePhysicalMedia>();
        }

        public int LearningResourceId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Url { get; set; }
        public string ConceptKeyword { get; set; }
        public string SubjectName { get; set; }
        public string SubjectCode { get; set; }
        public string SubjectCodeSystem { get; set; }
        public int? RefLearningResourceTypeId { get; set; }
        public DateTime? DateCreated { get; set; }
        public string Version { get; set; }
        public string Creator { get; set; }
        public string PublisherName { get; set; }
        public DateTime? PublishedDate { get; set; }
        public string CopyrightHolderName { get; set; }
        public string CopyrightYear { get; set; }
        public string LearningResourceLicenseUrl { get; set; }
        public string BasedOnUrl { get; set; }
        public int? RefLearningResourceIntendedEndUserRoleId { get; set; }
        public int? RefLearningResourceEducationalUseId { get; set; }
        public int? RefLearningResourceInteractivityTypeId { get; set; }
        public int? RefLanguageId { get; set; }
        public decimal? TimeRequired { get; set; }
        public byte? TypicalAgeRangeMinimum { get; set; }
        public byte? TypicalAgeRangeMaximum { get; set; }
        public string TextComplexityValue { get; set; }
        public string TextComplexitySystem { get; set; }
        public string AdaptedFromUrl { get; set; }
        public bool? AssistiveTechnologiesCompatibleInd { get; set; }
        public int? PeerRatingSampleSize { get; set; }
        public int? RefLearningResourceAccessApitypeId { get; set; }
        public int? RefLearningResourceAccessHazardTypeId { get; set; }
        public int? RefLearningResourceAccessModeTypeId { get; set; }
        public int? RefLearningResourceBookFormatTypeId { get; set; }
        public int? RefLearningResourceControlFlexibilityTypeId { get; set; }
        public int? RefLearningResourceDigitalMediaSubTypeId { get; set; }
        public int? RefLearningResourceDigitalMediaTypeId { get; set; }
        public string LearningResourceAuthorEmail { get; set; }
        public string LearningResourceAuthorUrl { get; set; }
        public DateTime? LearningResourceDateModified { get; set; }
        public string LearningResourcePublisherEmail { get; set; }
        public string LearningResourcePublisherUrl { get; set; }
        public int? RefLearningResourceAccessRightsUrlId { get; set; }
        public int? RefLearningResourceAuthorTypeId { get; set; }
        public int? RefLearningResourceInteractionModeId { get; set; }

        public virtual ICollection<AssessmentAsset> AssessmentAsset { get; set; }
        public virtual ICollection<AssessmentForm> AssessmentForm { get; set; }
        public virtual ICollection<AssessmentFormSection> AssessmentFormSection { get; set; }
        public virtual ICollection<AssessmentItem> AssessmentItem { get; set; }
        public virtual ICollection<LearnerActivityLearningResource> LearnerActivityLearningResource { get; set; }
        public virtual ICollection<LearningResourceAdaptation> LearningResourceAdaptation { get; set; }
        public virtual ICollection<LearningResourceEducationLevel> LearningResourceEducationLevel { get; set; }
        public virtual ICollection<LearningResourceMediaFeature> LearningResourceMediaFeature { get; set; }
        public virtual ICollection<LearningResourcePeerRating> LearningResourcePeerRating { get; set; }
        public virtual ICollection<LearningResourcePhysicalMedia> LearningResourcePhysicalMedia { get; set; }
        public virtual RefLanguage RefLanguage { get; set; }
        public virtual RefLearningResourceAccessApitype RefLearningResourceAccessApitype { get; set; }
        public virtual RefLearningResourceAccessHazardType RefLearningResourceAccessHazardType { get; set; }
        public virtual RefLearningResourceAccessModeType RefLearningResourceAccessModeType { get; set; }
        public virtual RefLearningResourceAccessRightsUrl RefLearningResourceAccessRightsUrl { get; set; }
        public virtual RefLearningResourceAuthorType RefLearningResourceAuthorType { get; set; }
        public virtual RefLearningResourceBookFormatType RefLearningResourceBookFormatType { get; set; }
        public virtual RefLearningResourceControlFlexibilityType RefLearningResourceControlFlexibilityType { get; set; }
        public virtual RefLearningResourceDigitalMediaSubType RefLearningResourceDigitalMediaSubType { get; set; }
        public virtual RefLearningResourceDigitalMediaType RefLearningResourceDigitalMediaType { get; set; }
        public virtual RefLearningResourceEducationalUse RefLearningResourceEducationalUse { get; set; }
        public virtual RefLearningResourceIntendedEndUserRole RefLearningResourceIntendedEndUserRole { get; set; }
        public virtual RefLearningResourceInteractionMode RefLearningResourceInteractionMode { get; set; }
        public virtual RefLearningResourceInteractivityType RefLearningResourceInteractivityType { get; set; }
        public virtual RefLearningResourceType RefLearningResourceType { get; set; }
    }
}
