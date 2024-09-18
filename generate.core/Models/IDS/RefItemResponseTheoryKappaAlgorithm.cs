using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefItemResponseTheoryKappaAlgorithm
    {
        public RefItemResponseTheoryKappaAlgorithm()
        {
            AssessmentItemResponseTheory = new HashSet<AssessmentItemResponseTheory>();
        }

        public int RefItemResponseTheoryKappaAlgorithmId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentItemResponseTheory> AssessmentItemResponseTheory { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
