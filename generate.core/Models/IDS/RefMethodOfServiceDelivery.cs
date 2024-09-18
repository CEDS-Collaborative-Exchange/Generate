using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefMethodOfServiceDelivery
    {
        public RefMethodOfServiceDelivery()
        {
            IndividualizedProgramService = new HashSet<IndividualizedProgramService>();
        }

        public int RefMethodOfServiceDeliveryId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<IndividualizedProgramService> IndividualizedProgramService { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
