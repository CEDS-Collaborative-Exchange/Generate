using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class IndividualizedProgramService
    {
        public int IndividualizedProgramServiceId { get; set; }
        public int PersonId { get; set; }
        public int? RefIndividualizedProgramPlannedServiceTypeId { get; set; }
        public int? RefMethodOfServiceDeliveryId { get; set; }
        public int? RefServiceFrequencyId { get; set; }
        public decimal? PlannedServiceDuration { get; set; }
        public DateTime? PlannedServiceStartDate { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefIndividualizedProgramPlannedServiceType RefIndividualizedProgramPlannedServiceType { get; set; }
        public virtual RefMethodOfServiceDelivery RefMethodOfServiceDelivery { get; set; }
        public virtual RefServiceFrequency RefServiceFrequency { get; set; }
    }
}
