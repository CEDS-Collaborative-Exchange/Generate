using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefControlOfInstitution
    {
        public RefControlOfInstitution()
        {
            PsInstitution = new HashSet<PsInstitution>();
        }

        public int RefControlOfInstitutionId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsInstitution> PsInstitution { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
