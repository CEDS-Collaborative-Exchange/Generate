using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Activity
    {
        public int OrganizationId { get; set; }
        public string ActivityDescription { get; set; }

        public virtual Organization Organization { get; set; }
    }
}
