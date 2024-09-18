using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefFirearmType
    {
        public RefFirearmType()
        {
            Incident = new HashSet<Incident>();
        }

        public int RefFirearmTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<Incident> Incident { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
