using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ApipInteraction
    {
        public int ApipInteractionId { get; set; }
        public int AssessmentItemId { get; set; }
        public int? RefApipInteractionTypeId { get; set; }
        public string Xml { get; set; }
        public int? SequenceNumber { get; set; }
        public decimal? ApipinteractionSequenceNumber { get; set; }

        public virtual AssessmentItemApip AssessmentItem { get; set; }
        public virtual RefApipInteractionType RefApipInteractionType { get; set; }
    }
}
