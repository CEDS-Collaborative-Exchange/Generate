using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationWebsite
    {
        public int OrganizationId { get; set; }
        public string Website { get; set; }

        public virtual Organization Organization { get; set; }
    }
}
