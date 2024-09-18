using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonReferral
    {
        public int PersonReferralId { get; set; }
        public int PersonId { get; set; }
        public DateTime? ReferralDate { get; set; }
        public string Reason { get; set; }
        public string Source { get; set; }
        public string ReferralTypeReceived { get; set; }
        public string ReferredTo { get; set; }
        public int? RefReferralOutcomeId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefReferralOutcome RefReferralOutcome { get; set; }
    }
}
