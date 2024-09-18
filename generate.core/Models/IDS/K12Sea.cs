using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12sea
    {
        public int K12SeaId { get; set; }
        public int OrganizationId { get; set; }
        public int RefStateAnsicodeId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }


        public virtual K12seaFederalFunds K12seaFederalFunds { get; set; }
        public virtual Organization Organization { get; set; }
        public virtual RefStateAnsicode RefStateAnsicodeNavigation { get; set; }
    }
}
