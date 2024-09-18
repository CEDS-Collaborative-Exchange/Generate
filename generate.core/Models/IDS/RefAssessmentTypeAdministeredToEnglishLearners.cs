using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentTypeAdministeredToEnglishLearners
    {
        public RefAssessmentTypeAdministeredToEnglishLearners()
        {
            Assessment = new HashSet<Assessment>();
        }

        public int RefAssessmentTypeAdministeredToEnglishLearnersId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<Assessment> Assessment { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
