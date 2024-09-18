using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AeProvider
    {
        public int OrganizationId { get; set; }
        public int RefLevelOfInstitutionId { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefLevelOfInstitution RefLevelOfInstitution { get; set; }
    }
}
