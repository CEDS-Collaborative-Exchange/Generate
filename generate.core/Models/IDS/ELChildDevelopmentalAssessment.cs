using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElchildDevelopmentalAssessment
    {
        public int PersonId { get; set; }
        public int? RefChildDevelopmentalScreeningStatusId { get; set; }
        public int? RefDevelopmentalEvaluationFindingId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefChildDevelopmentalScreeningStatus RefChildDevelopmentalScreeningStatus { get; set; }
        public virtual RefDevelopmentalEvaluationFinding RefDevelopmentalEvaluationFinding { get; set; }
    }
}
