using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefEducationLevelType
    {
        public RefEducationLevelType()
        {
            RefEducationLevel = new HashSet<RefEducationLevel>();
        }

        public int RefEducationLevelTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<RefEducationLevel> RefEducationLevel { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
