using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefLearningResourceEducationalUse
    {
        public RefLearningResourceEducationalUse()
        {
            LearningResource = new HashSet<LearningResource>();
        }

        public int RefLearningResourceEducationalUseId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<LearningResource> LearningResource { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
