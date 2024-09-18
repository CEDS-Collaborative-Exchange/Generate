using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefPersonStatusType
    {
        public RefPersonStatusType()
        {
            PersonStatus = new HashSet<PersonStatus>();
        }

        public int RefPersonStatusTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonStatus> PersonStatus { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
