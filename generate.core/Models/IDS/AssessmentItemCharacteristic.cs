using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentItemCharacteristic
    {
        public int AssessmentItemCharacteristicId { get; set; }
        public int AssessmentItemId { get; set; }
        public int? RefAssessmentItemCharacteristicTypeId { get; set; }
        public string Value { get; set; }
        public string ResponseChoicePattern { get; set; }

        public virtual AssessmentItem AssessmentItem { get; set; }
        public virtual RefAssessmentItemCharacteristicType RefAssessmentItemCharacteristicType { get; set; }
    }
}
