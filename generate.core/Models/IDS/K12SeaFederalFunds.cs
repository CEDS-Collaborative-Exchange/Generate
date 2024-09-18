using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12seaFederalFunds
    {
        public K12seaFederalFunds()
        {
            K12seaAlternateFundUse = new HashSet<K12seaAlternateFundUse>();
        }

        public int K12seaFederalFundsId { get; set; }
        public int OrganizationCalendarSessionId { get; set; }
        public bool? StateTransferabilityOfFunds { get; set; }
        public DateTime? DateStateReceivedTitleIiiallocation { get; set; }
        public DateTime? DateTitleIiifundsAvailableToSubgrantees { get; set; }
        public decimal? NumberOfDaysForTitleIiisubgrants { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        

        public virtual ICollection<K12seaAlternateFundUse> K12seaAlternateFundUse { get; set; }
        public virtual OrganizationCalendarSession OrganizationCalendarSession { get; set; }
    }
}
