using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12LeaFederalFunds
    {

        public int K12LeaFederalFundsId { get; set; }
        public int OrganizationCalendarSessionId { get; set; }
        public decimal? InnovativeProgramsFundsReceived { get; set; }
        public decimal? InnovativeDollarsSpent { get; set; }
        public decimal? InnovativeDollarsSpentOnStrategicPriorities { get; set; }
        public decimal? PublicSchoolChoiceFundsSpent { get; set; }
        public decimal? SesFundsSpent { get; set; }
        public decimal? SesSchoolChoice20PercentObligation { get; set; }
        public int? RefRlisProgramUseId { get; set; }
        public decimal? ParentalInvolvementReservationFunds { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public virtual OrganizationCalendarSession OrganizationCalendarSession { get; set; }
        public virtual RefRlisProgramUse RefRlisProgramUse { get; set; }
    }
}
