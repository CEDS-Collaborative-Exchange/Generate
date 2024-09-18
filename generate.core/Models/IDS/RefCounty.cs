using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCounty
    {
        public RefCounty()
        {
            LocationAddress = new HashSet<LocationAddress>();
            PersonAddress = new HashSet<PersonAddress>();
        }

        public int RefCountyId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<LocationAddress> LocationAddress { get; set; }
        public virtual ICollection<PersonAddress> PersonAddress { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
