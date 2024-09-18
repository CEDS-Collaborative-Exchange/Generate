using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationProgramType
    {
        public int OrganizationProgramTypeId { get; set; }
        public int OrganizationId { get; set; }
        public int RefProgramTypeId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefProgramType RefProgramType { get; set; }
    }
}
