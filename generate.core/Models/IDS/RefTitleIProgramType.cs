using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefTitleIprogramType
    {
        public RefTitleIprogramType()
        {
            K12programOrService = new HashSet<K12programOrService>();
        }

        public int RefTitleIprogramTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12programOrService> K12programOrService { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
