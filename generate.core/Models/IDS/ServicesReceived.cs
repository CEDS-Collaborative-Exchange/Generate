using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ServicesReceived
    {
        public int ServicesReceivedId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int RefServicesId { get; set; }
        public decimal? FullTimeEquivalency { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefServices RefServices { get; set; }
    }
}
