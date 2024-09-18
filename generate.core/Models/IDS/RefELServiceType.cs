using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefElserviceType
    {
        public RefElserviceType()
        {
            ElchildService = new HashSet<ElchildService>();
        }

        public int RefElserviceTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElchildService> ElchildService { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
