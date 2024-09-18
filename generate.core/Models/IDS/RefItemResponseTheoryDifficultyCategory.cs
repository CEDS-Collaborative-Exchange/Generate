using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefItemResponseTheoryDifficultyCategory
    {
        public RefItemResponseTheoryDifficultyCategory()
        {
            AssessmentItemResponseTheory = new HashSet<AssessmentItemResponseTheory>();
        }

        public int RefItemResponseTheoryDifficultyCategoryId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentItemResponseTheory> AssessmentItemResponseTheory { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
