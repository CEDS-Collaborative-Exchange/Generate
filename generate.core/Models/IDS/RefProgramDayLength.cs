using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefProgramDayLength
    {
        public RefProgramDayLength()
        {
            K12programOrServiceRefKindergartenDailyLength = new HashSet<K12programOrService>();
            K12programOrServiceRefPrekindergartenDailyLength = new HashSet<K12programOrService>();
        }

        public int RefProgramDayLengthId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12programOrService> K12programOrServiceRefKindergartenDailyLength { get; set; }
        public virtual ICollection<K12programOrService> K12programOrServiceRefPrekindergartenDailyLength { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
