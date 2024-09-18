using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefChildDevelopmentalScreeningStatus
    {
        public RefChildDevelopmentalScreeningStatus()
        {
            ElchildDevelopmentalAssessment = new HashSet<ElchildDevelopmentalAssessment>();
        }

        public int RefChildDevelopmentalScreeningStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElchildDevelopmentalAssessment> ElchildDevelopmentalAssessment { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
