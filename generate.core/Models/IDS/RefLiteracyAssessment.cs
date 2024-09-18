using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefLiteracyAssessment
    {
        public RefLiteracyAssessment()
        {
            K12studentLiteracyAssessment = new HashSet<K12studentLiteracyAssessment>();
        }

        public int RefLiteracyAssessmentId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12studentLiteracyAssessment> K12studentLiteracyAssessment { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
