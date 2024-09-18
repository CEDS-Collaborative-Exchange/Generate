


using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonHomelessness
    {
        public int PersonId { get; set; }
        public bool HomelessnessStatus { get; set; }
        public int RefHomelessNighttimeResidenceId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefHomelessNighttimeResidence RefHomelessNighttimeResidence { get; set; }
    }
}
