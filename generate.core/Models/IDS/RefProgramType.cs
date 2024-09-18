using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefProgramType
    {
        public RefProgramType()
        {
            OrganizationProgramType = new HashSet<OrganizationProgramType>();
        }

        public int RefProgramTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<OrganizationProgramType> OrganizationProgramType { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
