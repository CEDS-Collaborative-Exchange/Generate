using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefRace
    {
        public RefRace()
        {
            PersonDemographicRace = new HashSet<PersonDemographicRace>();
        }

        public int RefRaceId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonDemographicRace> PersonDemographicRace { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
