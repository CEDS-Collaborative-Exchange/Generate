using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefServiceOption
    {
        public RefServiceOption()
        {
            ElclassSection = new HashSet<ElclassSection>();
            Elenrollment = new HashSet<Elenrollment>();
            ElorganizationAvailability = new HashSet<ElorganizationAvailability>();
        }

        public int RefServiceOptionId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElclassSection> ElclassSection { get; set; }
        public virtual ICollection<Elenrollment> Elenrollment { get; set; }
        public virtual ICollection<ElorganizationAvailability> ElorganizationAvailability { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
