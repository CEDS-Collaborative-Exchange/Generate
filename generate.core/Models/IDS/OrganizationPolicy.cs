using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationPolicy
    {
        public int OrganizationPolicyId { get; set; }
        public int OrganizationId { get; set; }
        public string PolicyType { get; set; }
        public string Value { get; set; }

        public virtual Organization Organization { get; set; }
    }
}
