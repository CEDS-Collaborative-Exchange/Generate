using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElservicePartner
    {
        public int OrganizationId { get; set; }
        public string ServicePartnerName { get; set; }
        public string ServicePartnerDescription { get; set; }
        public DateTime? MemorandumOfUnderstandingEndDate { get; set; }
        public DateTime? MemorandumOfUnderstandingStartDate { get; set; }

        public virtual Organization Organization { get; set; }
    }
}
