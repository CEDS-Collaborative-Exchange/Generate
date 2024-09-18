using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefLanguage
    {
        public RefLanguage()
        {
            AssessmentAsset = new HashSet<AssessmentAsset>();
            AssessmentForm = new HashSet<AssessmentForm>();
            AssessmentItemApipDescription = new HashSet<AssessmentItemApipDescription>();
            AssessmentLanguage = new HashSet<AssessmentLanguage>();
            AssessmentNeedApipContentItemTranslationDisplayLanguageType = new HashSet<AssessmentNeedApipContent>();
            AssessmentNeedApipContentKeywordTranslationLanguageType = new HashSet<AssessmentNeedApipContent>();
            AssessmentParticipantSession = new HashSet<AssessmentParticipantSession>();
            AssessmentPersonalNeedsProfileContent = new HashSet<AssessmentPersonalNeedsProfileContent>();
            Course = new HashSet<Course>();
            CourseSection = new HashSet<CourseSection>();
            LearningResource = new HashSet<LearningResource>();
            LearningStandardDocument = new HashSet<LearningStandardDocument>();
            LearningStandardItem = new HashSet<LearningStandardItem>();
            PersonLanguage = new HashSet<PersonLanguage>();
            ProfessionalDevelopmentSession = new HashSet<ProfessionalDevelopmentSession>();
        }

        public int RefLanguageId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentAsset> AssessmentAsset { get; set; }
        public virtual ICollection<AssessmentForm> AssessmentForm { get; set; }
        public virtual ICollection<AssessmentItemApipDescription> AssessmentItemApipDescription { get; set; }
        public virtual ICollection<AssessmentLanguage> AssessmentLanguage { get; set; }
        public virtual ICollection<AssessmentNeedApipContent> AssessmentNeedApipContentItemTranslationDisplayLanguageType { get; set; }
        public virtual ICollection<AssessmentNeedApipContent> AssessmentNeedApipContentKeywordTranslationLanguageType { get; set; }
        public virtual ICollection<AssessmentParticipantSession> AssessmentParticipantSession { get; set; }
        public virtual ICollection<AssessmentPersonalNeedsProfileContent> AssessmentPersonalNeedsProfileContent { get; set; }
        public virtual ICollection<Course> Course { get; set; }
        public virtual ICollection<CourseSection> CourseSection { get; set; }
        public virtual ICollection<LearningResource> LearningResource { get; set; }
        public virtual ICollection<LearningStandardDocument> LearningStandardDocument { get; set; }
        public virtual ICollection<LearningStandardItem> LearningStandardItem { get; set; }
        public virtual ICollection<PersonLanguage> PersonLanguage { get; set; }
        public virtual ICollection<ProfessionalDevelopmentSession> ProfessionalDevelopmentSession { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
