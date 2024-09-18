using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonImmunization
    {
        public int PersonImmunizationId { get; set; }
        public int PersonId { get; set; }
        public DateTime ImmunizationDate { get; set; }
        public int RefImmunizationTypeId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefImmunizationType RefImmunizationType { get; set; }
    }
}
