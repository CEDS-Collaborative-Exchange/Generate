using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElchildService
    {
        public int OrganizationPersonRoleId { get; set; }
        public bool? Eceapeligibility { get; set; }
        public string EligibilityPriorityPoints { get; set; }
        public string ReasonForDeclinedServices { get; set; }
        public DateTime? ServiceDate { get; set; }
        public int? RefEarlyChildhoodServicesOfferedId { get; set; }
        public int? RefEarlyChildhoodServicesReceivedId { get; set; }
        public int? RefElserviceTypeId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefEarlyChildhoodServices RefEarlyChildhoodServicesOffered { get; set; }
        public virtual RefEarlyChildhoodServices RefEarlyChildhoodServicesReceived { get; set; }
        public virtual RefElserviceType RefElserviceType { get; set; }
    }
}
