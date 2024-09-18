using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationIndicator
    {
        public int OrganizationIndicatorId { get; set; }
        public int OrganizationId { get; set; }
        public string IndicatorValue { get; set; }
        public int RefOrganizationIndicatorId { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefOrganizationIndicator RefOrganizationIndicator { get; set; }
    }
}
