using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElchildTransitionPlan
    {
        public int PersonId { get; set; }
        public bool? PartB619potentialEligibilityInd { get; set; }
        public DateTime? IdeapartCtoPartBnotificationDate { get; set; }
        public DateTime? TransitionConferenceDate { get; set; }
        public DateTime? TransitionConferenceDeclineDate { get; set; }
        public DateTime? DateOfTransitionPlan { get; set; }
        public DateTime? IdeapartCtoPartBnotificationOptOutDate { get; set; }
        public bool? IdeapartCtoPartBnotificationOptOutIndicator { get; set; }
        public int? RefReasonDelayTransitionConfId { get; set; }
        public int? IndividualizedProgramId { get; set; }

        public virtual IndividualizedProgram IndividualizedProgram { get; set; }
        public virtual Person Person { get; set; }
        public virtual RefReasonDelayTransitionConf RefReasonDelayTransitionConf { get; set; }
    }
}
