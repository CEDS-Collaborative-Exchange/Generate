using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationOperationalStatus
    {
        public int OrganizationOperationalStatusId { get; set; }
        public int OrganizationId { get; set; }
        public int RefOperationalStatusId { get; set; }
        public DateTime? OperationalStatusEffectiveDate { get; set; }
        public DateTime? RecordStartDateTime{ get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefOperationalStatus RefOperationalStatus { get; set; }
    }
}
