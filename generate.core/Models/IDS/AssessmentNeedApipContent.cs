using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentNeedApipContent
    {
        public int AssessmentNeedApipContentId { get; set; }
        public int AssessmentPersonalNeedsProfileContentId { get; set; }
        public int? ItemTranslationDisplayLanguageTypeId { get; set; }
        public int? KeywordTranslationLanguageTypeId { get; set; }
        public int? RefAssessmentNeedSigningTypeId { get; set; }
        public int? RefAssessmentNeedAlternativeRepresentationTypeId { get; set; }
        public int? RefAssessmentNeedSpokenSourcePreferenceTypeId { get; set; }
        public bool? ReadAtStartPreferenceIndicator { get; set; }
        public int? RefAssessmentNeedUserSpokenPreferenceTypeId { get; set; }
        public bool? AssessmentNeedDirectionsOnlyIndicator { get; set; }

        public virtual AssessmentPersonalNeedsProfileContent AssessmentPersonalNeedsProfileContent { get; set; }
        public virtual RefLanguage ItemTranslationDisplayLanguageType { get; set; }
        public virtual RefLanguage KeywordTranslationLanguageType { get; set; }
        public virtual RefAssessmentNeedAlternativeRepresentationType RefAssessmentNeedAlternativeRepresentationType { get; set; }
        public virtual RefAssessmentNeedSigningType RefAssessmentNeedSigningType { get; set; }
        public virtual RefAssessmentNeedSpokenSourcePreferenceType RefAssessmentNeedSpokenSourcePreferenceType { get; set; }
        public virtual RefAssessmentNeedUserSpokenPreferenceType RefAssessmentNeedUserSpokenPreferenceType { get; set; }
    }
}
