using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentItemPossibleResponse
    {
        public int AssessmentItemPossibleResponseId { get; set; }
        public int AssessmentItemId { get; set; }
        public string PossibleResponseOption { get; set; }
        public string Value { get; set; }
        public bool? CorrectIndicator { get; set; }
        public string FeedbackMessage { get; set; }
        public int? SequenceNumber { get; set; }

        public virtual AssessmentItem AssessmentItem { get; set; }
    }
}
