using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LearnerAction
    {
        public int LearnerActionId { get; set; }
        public int? AssessmentItemResponseId { get; set; }
        public int? RefLearnerActionTypeId { get; set; }
        public string Value { get; set; }
        public DateTime? LearnerActionDateTime { get; set; }
        public string LearnerActionActorIdentifier { get; set; }
        public string LearnerActionObjectDescription { get; set; }
        public string LearnerActionObjectIdentifier { get; set; }
        public string LearnerActionObjectType { get; set; }

        public virtual AssessmentItemResponse AssessmentItemResponse { get; set; }
        public virtual RefLearnerActionType RefLearnerActionType { get; set; }
    }
}
