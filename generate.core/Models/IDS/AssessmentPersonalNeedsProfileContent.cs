using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentPersonalNeedsProfileContent
    {
        public AssessmentPersonalNeedsProfileContent()
        {
            AssessmentNeedApipContent = new HashSet<AssessmentNeedApipContent>();
            AssessmentPersonalNeedLanguageLearner = new HashSet<AssessmentPersonalNeedLanguageLearner>();
        }

        public int AssessmentPersonalNeedsProfileContentId { get; set; }
        public int AssessmentPersonalNeedsProfileId { get; set; }
        public int? RefAssessmentNeedHazardTypeId { get; set; }
        public int? RefAssessmentNeedSupportToolId { get; set; }
        public bool? CognitiveGuidanceActivateByDefaultIndicator { get; set; }
        public bool? CognitiveGuidanceAssignedSupportIndicator { get; set; }
        public bool? ScaffoldingAssignedSupportIndicator { get; set; }
        public bool? ScaffoldingActivateByDefaultIndicator { get; set; }
        public bool? ChunkingAssignedSupportIndicator { get; set; }
        public bool? ChunkingActivateByDefaultIndicator { get; set; }
        public bool? KeywordEmphasisAssignedSupportIndicator { get; set; }
        public bool? KeywordEmphasisActivateByDefaultIndicator { get; set; }
        public bool? ReducedAnswersAssignedSupportIndicator { get; set; }
        public bool? ReducedAnswersActivateByDefaultIndicator { get; set; }
        public bool? NegativesRemovedAssignedSupportIndicator { get; set; }
        public bool? NegativesRemovedActivateByDefaultIndicator { get; set; }
        public int? RefKeywordTranslationsLanguageId { get; set; }
        public bool? KeywordTranslationsAssignedSupportIndicator { get; set; }
        public bool? KeywordTranslationsActivateByDefaultIndicator { get; set; }

        public virtual ICollection<AssessmentNeedApipContent> AssessmentNeedApipContent { get; set; }
        public virtual ICollection<AssessmentPersonalNeedLanguageLearner> AssessmentPersonalNeedLanguageLearner { get; set; }
        public virtual AssessmentPersonalNeedsProfile AssessmentPersonalNeedsProfile { get; set; }
        public virtual RefAssessmentNeedHazardType RefAssessmentNeedHazardType { get; set; }
        public virtual RefAssessmentNeedSupportTool RefAssessmentNeedSupportTool { get; set; }
        public virtual RefLanguage RefKeywordTranslationsLanguage { get; set; }
    }
}
