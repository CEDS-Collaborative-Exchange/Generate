using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Program
    {
        public int OrganizationId { get; set; }
        public decimal? CreditsRequired { get; set; }

        public virtual Organization Organization { get; set; }
    }
}
