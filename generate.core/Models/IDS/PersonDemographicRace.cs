using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonDemographicRace
    {
        public int PersonDemographicRaceId { get; set; }
        public int PersonId { get; set; }
        public int RefRaceId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefRace RefRace { get; set; }
    }
}
