using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefHomelessNighttimeResidence
    {
        public RefHomelessNighttimeResidence()
        {
            PersonHomelessness = new HashSet<PersonHomelessness>();
        }

        public int RefHomelessNighttimeResidenceId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonHomelessness> PersonHomelessness { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
