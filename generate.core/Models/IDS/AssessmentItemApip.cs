using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentItemApip
    {
        public AssessmentItemApip()
        {
            ApipInteraction = new HashSet<ApipInteraction>();
        }

        public int AssessmentItemId { get; set; }
        public bool? AdaptiveIndicator { get; set; }
        public string ResponseProcessingTemplateUrl { get; set; }
        public string ResponseProcessingXml { get; set; }
        public string ResponseDeclarationXml { get; set; }
        public string OutcomeDeclarationXml { get; set; }
        public string TemplateDeclarationXml { get; set; }
        public string TemplateProcessingXml { get; set; }
        public string ModalFeedbackXml { get; set; }
        public string ItemBodyXml { get; set; }

        public virtual ICollection<ApipInteraction> ApipInteraction { get; set; }
        public virtual AssessmentItemApipDescription AssessmentItemApipDescription { get; set; }
        public virtual AssessmentItem AssessmentItem { get; set; }
    }
}
