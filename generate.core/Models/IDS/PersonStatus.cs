using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonStatus
    {
        public int PersonStatusId { get; set; }
        public int PersonId { get; set; }
        public int RefPersonStatusTypeId { get; set; }
        public bool StatusValue { get; set; }
        public DateTime? StatusStartDate { get; set; }
        public DateTime? StatusEndDate { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefPersonStatusType RefPersonStatusType { get; set; }
    }
}
