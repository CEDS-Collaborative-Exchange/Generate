using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElchildProgramEligibility
    {
        public int OrganizationPersonRoleId { get; set; }
        public int? RefElprogramEligibilityStatusId { get; set; }
        public DateTime? StatusDate { get; set; }
        public DateTime? ExpirationDate { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
    }
}
