using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefLearningResourcePhysicalMediaType
    {
        public RefLearningResourcePhysicalMediaType()
        {
            LearningResourcePhysicalMedia = new HashSet<LearningResourcePhysicalMedia>();
        }

        public int RefLearningResourcePhysicalMediaTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<LearningResourcePhysicalMedia> LearningResourcePhysicalMedia { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
