using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RequiredImmunization
    {
        public int RequiredImmunizationId { get; set; }
        public int OrganizationId { get; set; }
        public int RefImmunizationTypeId { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefImmunizationType RefImmunizationType { get; set; }
    }
}
