using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12leaTitleIsupportService
    {
        public int K12leaTitleIsupportServiceId { get; set; }
        public int OrganizationId { get; set; }
        public int K12LeaId { get; set; }
        public int RefK12leaTitleIsupportServiceId { get; set; }
        public DateTime RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual K12lea K12Lea { get; set; }
        public virtual RefK12leaTitleIsupportService RefK12leaTitleIsupportService { get; set; }
    }
}
