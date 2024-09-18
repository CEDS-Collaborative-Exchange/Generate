using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefDevelopmentalEvaluationFinding
    {
        public RefDevelopmentalEvaluationFinding()
        {
            ElchildDevelopmentalAssessment = new HashSet<ElchildDevelopmentalAssessment>();
        }

        public int RefDevelopmentalEvaluationFindingId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElchildDevelopmentalAssessment> ElchildDevelopmentalAssessment { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
